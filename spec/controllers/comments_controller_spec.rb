require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context "Authenticated user" do
      before { login(user) }

      context 'with valid attributes' do
        it "saves a new comment in the database" do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }
            .to change(Comment, :count).by(1)
        end
          
        it 'created by current user' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(assigns(:comment).user).to eq user
        end

        it "render create view" do
          post :create, params: { comment: attributes_for(:comment),  question_id: question, format: :js }

          expect(response).to render_template :create
          expect(response).to have_http_status :ok
        end

        it 'saves new comment of correct question' do
          post :create, params: { comment: attributes_for(:question), question_id: question}, format: :js
          expect(assigns(:comment).commentable).to eq question
        end

        it 'saves new comment of correct answer' do
          post :create, params: { comment: attributes_for(:answer), answer_id: answer}, format: :js
          expect(assigns(:comment).commentable).to eq answer
        end
      end

      context 'with invalid attributes' do
        it "does not save the comment" do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }
            .to_not change(Comment, :count)
        end
        
        it "re-renders create view" do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question  }, format: :js
          expect(response).to render_template :create
          expect(response).to have_http_status :ok
        end
      end
    end

    context "Unauthenticated user" do
      it "does not save the comment" do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }
          .to_not change(Comment, :count)
      end
        
      it "re-renders create view" do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to have_http_status :unauthorized
        expect(response.body).to have_content "You need to sign in or sign up before continuing."
      end
    end
  end
end
