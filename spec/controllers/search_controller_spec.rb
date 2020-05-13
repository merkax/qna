require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    
    let!(:questions) { create_list(:question, 2)}
    subject { SearchService }

    context "with valid attributes" do
      SearchService::SCOPES.each do |scope|

        before do
          expect(subject).to receive(:call).and_return(questions)
          get :index, params: { search: { query: questions.sample.title, scope: scope } }
        end

        it "#{scope} assigns the requested SearchService.call to @results" do
          expect(assigns(:results)).to eq questions
        end

        it 'populates an array of all questions' do
          expect(assigns(:results)).to match_array(questions)
        end

        it "#{scope } renders index view" do
          expect(response).to render_template :index
        end

        it "#{scope} return to successful status" do
          expect(response).to be_successful
        end
      end
    end

    context "with invalid attributes" do
      before do
        get :index, params: { search: { query: questions.sample.title, scope: 'blabla' } }
      end
      
      it "renders index view" do
        expect(response).to render_template :index
      end
    end
  end
end
