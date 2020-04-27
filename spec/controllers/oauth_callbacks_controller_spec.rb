require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Provider' do
    let(:oauth_data) { mock_auth_hash('github', email:'new@user.com') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context "user exists" do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end
      
      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context "user does not exist" do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      end

      it 'create new user' do
        expect { get :github }.to change(User, :count).by 1
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context "user does not exist and provider without email" do
      let(:oauth_data_without_email) { mock_auth_hash('vkontakte', email: nil) }

      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
      end

      it 'create new user' do
        expect { get :vkontakte }.to_not change(User, :count)
      end
    end
  end
end
