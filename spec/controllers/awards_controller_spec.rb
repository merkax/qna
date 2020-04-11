require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:awards) { create_list(:award, 2, user: user) }
  
  describe "GET #index" do
    context "User with awards" do

      before do
        login user
        get :index
      end 

      it 'populates an array of all awardss' do
        expect(assigns(:awards)).to match_array(awards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context "User without awards" do

      before do
        login another_user
        get :index
      end

      it 'populates an array of all awardss' do
        expect(assigns(:awards)).to be_empty
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context "Unauthenticated user" do
      before { get :index }

      it 'trying to get a list of rewards' do
        expect(response.status).to eq 302
        expect(response).to redirect_to '/users/sign_in'
      end

    end
  end
end
