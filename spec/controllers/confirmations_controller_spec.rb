require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    let(:provider) {  mock_auth_hash('github', email: nil).provider }
    let(:uid) {  mock_auth_hash('github', email: nil).uid }
    let(:valid_email) {  'new@user.com' }
    let(:invalid_email) { 'wrong_email' }
 
    before do
      session["devise.provider"] = provider
      session["devise.uid"] = uid
    end
    
    describe "with valid attribute" do
      context "user registered" do
        let!(:user) { create(:user, email: valid_email) }

        it 'creates user authorization' do
          expect { post :create, params: { user: { email: valid_email } } }.to change(user.authorizations, :count).by 1
        end

        it 'creates authorization with correct data' do
          post :create, params: { user: { email: valid_email } }

          expect(user.authorizations.first.provider).to eq provider
          expect(user.authorizations.first.uid).to eq uid
        end

        it 'login user' do
          post :create, params: { user: { email: valid_email } }

          expect(subject.current_user).to eq user
        end

        it 'redirects to root' do
          post :create, params: { user: { email: valid_email } }

          expect(response).to redirect_to root_path
        end
      end

      context "user unregistered" do
        it 'saves user' do
          expect { post :create, params: { user: { email: valid_email } } }.to change(User, :count).by 1
        end

        it 'does render new view' do
          post :create, params: { user: { email: valid_email } }

          expect(response).to render_template 'devise/mailer/confirmation_instructions'
        end
      end
    end

    describe "with invalid attribute" do
      it 'does not save user' do
        expect { post :create, params: { user: { email: invalid_email } } }.to_not change(User, :count)
      end

      it 're-renders new view' do
        post :create, params: { user: { email: invalid_email } }

        expect(response).to render_template :new
      end
    end
  end
end
