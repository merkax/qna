require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe "GET #show" do
    before { get :show, params: { id: answer } }

    it "renders show view" do
      expect(response).to render_template :show
    end
  end
  
  describe "GET #new" do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it "renders new view" do
      expect(response).to render_template :new
    end
  end
  
  describe "POST #create" do
    before { login(user) }

    context "with valid attributes" do
      it "saves a new answer in the database" do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user: user }, format: :js }
        .to change(question.answers, :count).by(1)
      end
      
      it 'created by current user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, user: user }, format: :js
        expect(assigns(:answer).user).to eq user
        expect(assigns(:answer).question).to eq question
      end

      it "renders create template" do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
    
    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end
  
      it "re-renders create template" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATH #update' do

    context "Authenticated user" do
      
      before { login(user) }

      context "with valid attributes" do

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it "renders update view" do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context "with invalid attributes" do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } , format: :js
          end.to_not change(answer, :body)
        end

        it "renders update view" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'user not creator answer'do
        let(:not_author) { create(:user) }
        
        before { login(not_author) }

        it "does not change attributes" do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to_not eq 'new body'
        end

        it "renders update view" do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :update
        end
      end
    end
    
    context "Unauthenticated user" do
      it "tries change attributes" do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'response' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response.status).to eq 401
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context "Authenticated user" do
      
      context "user creator answer" do
        before { login(user) }
        
        it 'deletes the answer' do
          expect{ delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "user not creator answer" do
        let(:not_author) { create(:user) }
        
        before { login(not_author) }

        it 'tries deletes the answer' do
          expect{ delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end

        it "response" do
          delete :destroy, params: { id: answer }, format: :js

          expect(response.body).to be_empty #стоит проверять ?
        end
      end
    end
  
    context "Unauthenticated user" do
      it 'tries deletes the answer' do
        expect{ delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'response' do
        delete :destroy, params: { id: answer }, format: :js
      
        expect(response.status).to eq 401
        expect(response.body).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end

  describe "PATCH #set_best" do
    let(:author) { create(:user) }
    let(:author_question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: author_question) }

    context 'User is author of question' do
      before { login(author) }
      
      it 'set best answer' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        
        expect(answer).to be_best
      end
      
      it 'render set best view' do
        patch :set_best, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :set_best #стоит проверять ?
      end
    end

    context "User not author of question" do
      before { login(user) }

      it 'tries set best answer' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        
        expect(answer).to_not be_best
      end

      it 'render set best view' do
        patch :set_best, params: { id: answer, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :set_best
      end
    end

    context "Unauthenticated user" do
      before { login(user) }

      it 'tries set best answer' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        
        expect(answer).to_not be_best
      end
    end
  end
end
