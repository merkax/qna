require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let!(:resource) { create(:question, :with_files, user: author) }

    context "Authenticated user" do
      context "user creator resource" do
        before { login(author) }
  
        it "deletes files from resource" do
          expect { delete :destroy, params: { id: resource.files.first.id }, format: :js }.to change(resource.files, :count).by(-1)
        end
        
        it 'render destroy view' do
          delete :destroy, params: { id: resource.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user not creator resource' do
        before { login(user) }

        it "tries deletes files from resource" do
          expect { delete :destroy, params: { id: resource.files.first.id }, format: :js }.to_not change(resource.files, :count)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: resource.files.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context "Unauthenticated user" do
        it "tries deletes files from resource" do
          expect { delete :destroy, params: { id: resource.files.first.id }, format: :js }.to_not change(resource.files, :count)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: resource.files.first.id }, format: :js
        
          expect(response.status).to eq 401
          expect(response.body).to eq 'You need to sign in or sign up before continuing.'
        end
    end
  end
end
