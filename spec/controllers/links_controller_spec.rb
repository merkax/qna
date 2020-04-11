require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let!(:link) { create(:link, linkable: question ) }

    context "Authenticated user" do
      context "user creator question" do
        before { login(author) }
  
        it "deletes link from question" do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change(question.links, :count).by(-1)
        end
        
        it 'render destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user not creator link' do
        before { login(user) }

        it "tries deletes files from link" do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to_not change(question.links, :count)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context "Unauthenticated user" do
        it "tries deletes files from resource" do
          expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to_not change(question.links, :count)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: question.links.first.id }, format: :js
        
          expect(response.status).to eq 401
          expect(response.body).to eq 'You need to sign in or sign up before continuing.'
        end
    end
  end
end
