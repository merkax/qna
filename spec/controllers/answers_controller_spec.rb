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

    before { login(user) }

    context "with valid attributes" do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it "renders update view" do
        post :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context "with invalid attributes" do
      it 'does not change answer attributes' do
        expect do
          post :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } , format: :js
        end.to_not change(answer, :body)
      end

      it "renders update view" do
        post :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context "Authenticated user" do
      
      context "user creator answer" do
        before { login(user) }
        
        it 'deletes the answer' do
          expect{ delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
        end

        it 'redirects to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context "user not creator answer" do
        let(:not_author) { create(:user) }
        
        before { login(not_author) }

        it 'tries deletes the answer' do
          expect{ delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end

        it "redirects to index" do
          delete :destroy, params: { id: answer }

          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context "Unauthenticated user" do
      it 'tries deletes the answer' do
        expect{ delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
