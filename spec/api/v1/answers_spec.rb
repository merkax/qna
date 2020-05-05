require 'rails_helper'

describe 'Answers API', type: :request do
 let(:headers) {  { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'Returns successful status'

      it_behaves_like 'Returns list' do
        let(:resource_response) { json['answers'] }
        let(:resource) { answers }
      end

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_files) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:links) { create_list(:link, 2, linkable: answer ) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer']}

      before { get api_path, params: { access_token: access_token.token }, headers: headers }
      
      it_behaves_like 'Returns successful status'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end

      describe "comments" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { answer_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe "files" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { answer_response['files'] }
          let(:resource) { answer.files }
        end
      end

      describe "links" do
        it_behaves_like 'Returns list' do
          let(:resource_response) { answer_response['links'] }
          let(:resource) { links }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
    
    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context "with valid attribute" do
        it "saves a new answer in the database" do
          expect { post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }, headers: headers }
          .to change(Answer, :count).by(1)
        end

        it "returns status successful" do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }
          expect(response).to be_successful
        end
      end
      
      context 'with invalid attributes' do
        it "does not save the answer" do
          expect { post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }
          .to_not change(Answer, :count)
        end
        
        it "returns status unprocessable_entity" do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end
    
    context 'authorized' do
      context "with valid attribute" do
        before { patch api_path, params: { id: answer, answer: { body: 'new body' },
                                          access_token: access_token.token }, headers: headers }

        it "changes answer attributes" do
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it_behaves_like 'Returns successful status'
      end
      
      context 'with invalid attributes' do
        before { patch api_path, params: { id: answer, answer: { body: '' },
                                          access_token: access_token.token }, headers: headers }

        it "does not change answer" do
          original_body = answer.body
          answer.reload
          
          expect(answer.body).to eq original_body
        end

        it "returns status: unprocessable_entity" do
          expect(response.status).to eq 422
        end
      end
    end

    context "user not creator answer" do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }

      before { patch other_api_path, params: { id: other_answer, answer: { body: 'new body' },
                                              access_token: access_token.token }, headers: headers }

      it "does not change answer" do
        original_body = answer.body
        answer.reload

        expect(answer.body).to eq original_body
      end

      it 'returns status forbidden' do
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE /api/v1/answers/id' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end
    
    context 'authorized' do

      before { delete api_path, params: { id: answer, access_token: access_token.token }, headers: headers }

      it "deletes the answer" do
        expect(Answer.count).to eq 0
      end

      it 'returns json message' do
        expect(json['messages']).to eq 'Answer was succesfully deleted.'
      end
    end

    context "user not creator answer" do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }
      
      before { delete other_api_path, params: { id: other_answer, access_token: access_token.token }, headers: headers }
      
      it 'tries deletes the answer' do
        expect(Answer.count).to eq 1
      end

      it 'returns status forbidden' do
        expect(response.status).to eq 403
      end
    end
  end
end
