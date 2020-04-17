require 'rails_helper'

shared_examples_for 'voted' do
  let(:controller) { described_class } 
  let(:model) { controller.controller_name.classify.constantize } 

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:votable) { create(model.to_s.underscore.to_sym, user: author) }

  describe 'PATCH #vote_up' do

    context "Authenticated user" do
      context "author resource" do
        before { login(author) }
        
        it 'tries vote for resource' do 
          patch :vote_up, params: { id: votable }, format: :json
          votable.reload

          expect(votable.rating).to eq 0
        end

        it 'render error response' do
          patch :vote_up, params: { id: votable }, format: :json
          
          expect(response.status).to eq 403
          expect(JSON.parse(response.body)['message']).to eq "Error: Author cannot vote for himself"
        end
      end

      context 'user not creator resource' do
        before { login(user) }

        it "assigns the requested votable to @votable" do 
          patch :vote_up, params: { id: votable }, format: :json 
          expect(assigns(:votable)).to eq votable
        end

        it 'tries vote for resource' do
          patch :vote_up, params: { id: votable }, format: :json
          votable.reload

          expect(votable.rating).to eq 1
        end

        it 'tries vote twice' do
          patch :vote_up, params: { id: votable }, format: :json
          patch :vote_up, params: { id: votable }, format: :json
          votable.reload

          expect(votable.rating).to eq 1
        end

        it 'render vote JSON response' do
          patch :vote_up, params: { id: votable }, format: :json
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['rating']).to eq(votable.rating)
        end
      end
    end

    context "Unauthenticated user" do

      it 'tries vote for resource' do
        patch :vote_up, params: { id: votable }, format: :json
        
        expect(response.status).to eq 401 
        expect(response.body).to have_content "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'PATCH #vote_down' do
    context "author resource" do
      before { login(author) }

      it 'tries vote for resource' do
        patch :vote_down, params: { id: votable }, format: :json
        votable.reload

        expect(votable.rating).to eq 0
      end

      it 'render error response' do
        patch :vote_down, params: { id: votable }, format: :json
          
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq "Error: Author cannot vote for himself"
      end
    end

    context 'user not creator votable' do
      before { login(user) }

      it "assigns the requested votable to @votable" do
        patch :vote_down, params: { id: votable }, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'tries vote for resource' do
        patch :vote_down, params: { id: votable }, format: :json
        votable.reload

        expect(votable.rating).to eq -1
      end

      it 'tries vote twice' do
        patch :vote_down, params: { id: votable }, format: :json
        patch :vote_down, params: { id: votable }, format: :json
        votable.reload

        expect(votable.rating).to eq -1
      end

      it 'render vote JSON response' do 
        patch :vote_down, params: { id: votable }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['rating']).to eq(votable.rating)
      end
    end

    context "Unauthenticated user" do

      it 'tries vote for resource' do
        patch :vote_down, params: { id: votable }, format: :json
        
        expect(response.status).to eq 401 
        expect(response.body).to have_content "You need to sign in or sign up before continuing."
      end
    end
  end

  describe 'DELETE #vote_cancel' do

    context "author resource" do
      before { login(author) }

      it 'tries cancel vote for resource' do
        patch :vote_up, params: { id: votable }, format: :json
        expect { delete :vote_cancel, params: { id: votable }, format: :json }.to_not change{ votable.rating }
      end

      it 'render error response' do
        delete :vote_cancel, params: { id: votable }, format: :json
          
        expect(response.status).to eq 403
        expect(JSON.parse(response.body)['message']).to eq "Error: Author cannot vote for himself"
      end
    end

    context 'user not creator votable' do
      before { login(user) }

      it "assigns the requested votable to @votable" do 
        delete :vote_cancel, params: { id: votable }, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'tries cancel vote for resource' do
        patch :vote_up, params: { id: votable }, format: :json
        expect { delete :vote_cancel, params: { id: votable }, format: :json }.to change{ votable.rating }.from(1).to(0)
      end

      it 'render vote JSON response' do
        delete :vote_cancel, params: { id: votable }, format: :json
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['rating']).to eq(votable.rating)
      end
    end

    context "Unauthenticated user" do

      it 'tries vote for resource' do
        delete :vote_cancel, params: { id: votable }, format: :json
        
        expect(response.status).to eq 401 
        expect(response.body).to have_content "You need to sign in or sign up before continuing."
      end
    end
  end
end
