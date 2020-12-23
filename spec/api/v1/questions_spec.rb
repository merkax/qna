require 'rails_helper'

describe 'Questions API', type: :request do
 let(:headers) {  { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last } # почему теперь сортирует в обратном порядке(был first)? 
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'Returns successful status'

      it_behaves_like 'Returns list' do
        let(:resource_response) { json['questions'] }
        let(:resource) { questions }
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(10)
      end

      describe 'answers' do
        let!(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 2, linkable: question ) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question']}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'Returns successful status'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      describe "comments" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { question_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe "files" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { question_response['files'] }
          let(:resource) { question.files }
        end
      end

      describe "links" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { question_response['links'] }
          let(:resource) { links }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context "with valid attribute" do
        it "saves a new question in the database" do
          expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers }
          .to change(Question, :count).by(1)
        end

        it "returns status successful" do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
          expect(response).to be_successful
        end
      end
      
      context 'with invalid attributes' do
        it "does not save the question" do
          expect { post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token } }
          .to_not change(Question, :count)
        end
        
        it "returns status unprocessable_entity" do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end
    
    context 'authorized' do

      context "with valid attribute" do
        before { patch api_path, params: { id: question, question: { title: 'new title', body: 'new body' },
                                          access_token: access_token.token }, headers: headers }

        it "changes question attributes" do
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it_behaves_like 'Returns successful status'
      end
      
      context 'with invalid attributes' do
        before { patch api_path, params: { id: question, question: { title: '', body: '' },
                                          access_token: access_token.token }, headers: headers }

        it "does not change question" do
          original_title = question.title
          original_body = question.body
          question.reload
          
          expect(question.title).to eq original_title
          expect(question.body).to eq original_body
        end

        it "returns status: unprocessable_entity" do
          expect(response.status).to eq 422
        end
      end
    end

    context "user not creator question" do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

      before { patch other_api_path, params: { id: other_question, question: { title: 'new title', body: 'new body' },
                                              access_token: access_token.token }, headers: headers }

      it "does not change question" do
        original_title = question.title
        original_body = question.body
        question.reload
        
        expect(question.title).to eq original_title
        expect(question.body).to eq original_body
      end

      it 'returns status forbidden' do
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end
    
    context 'authorized' do

      before { delete api_path, params: { id: question, access_token: access_token.token }, headers: headers }

      it "deletes the question" do
        expect(Question.count).to eq 0
      end

      it 'returns json message' do
        expect(json['messages']).to eq 'Question was succesfully deleted.'
      end
    end

    context "user not creator question" do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }
      
      before { delete other_api_path, params: { id: other_question, access_token: access_token.token }, headers: headers }
      
      it 'tries deletes the question' do
        expect(Question.count).to eq 1
      end

      it 'returns status forbidden' do
        expect(response.status).to eq 403
      end
    end
  end
end
