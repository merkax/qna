require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) } 
  let(:question) { create(:question) } 

  describe "POST #create" do
    context 'Authenticated user' do
      before { login(user) }

      it "saves a new question in the database" do
        expect { post :create, params: { question_id: question }, format: :js }.to change(question.subscriptions, :count).by(1)
      end
        
      it 'created by current user' do
        post :create, params: { question_id: question }, format: :js
        expect(assigns(:subscription).user).to eq user
      end

      it "render to create view" do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end

      it "return to successful status" do
        post :create, params: { question_id: question }, format: :js

        expect(response).to be_successful
      end
    end

    context 'Unauthenticated user' do
      it "does not save the question" do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(question.subscriptions, :count)
      end
      
      it "return to 401 status" do
        post :create, params: { question_id: question }, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:subscription) { create(:subscription, question: question, user: user) }
    
    context 'Authenticated user' do
      before { login(user) }

      it "deletes question subscription from database" do
        expect { post :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it "render to destroy view" do
        post :destroy, params: { id: subscription  }, format: :js

        expect(response).to render_template :destroy
      end

      it "return to successful status" do
        post :destroy, params: { id: subscription}, format: :js
        
        expect(response).to be_successful
      end
    end

    context 'Another user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it "tries deletes question subscription from database" do
        expect { post :destroy, params: { id: subscription }, format: :js }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'Unauthenticated user' do
      it "does not delete subscription" do
        expect { post :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
      
      it "return to 401 status" do
        post :destroy, params: { id: subscription }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
