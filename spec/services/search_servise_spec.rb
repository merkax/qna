require 'rails_helper'

RSpec.describe SearchService do
  context "with valid scope" do
    SearchService::SCOPES.each do |scope|

      it "search from #{scope}" do
        search_params = { query: 'question', scope: scope }
        klass_search = scope.classify.constantize
        
        expect(klass_search).to receive(:search).with(search_params[:query]).and_call_original
        SearchService.call(search_params)
      end
    end
  end

  context "with invalid scope" do
    it 'scope does not exists' do
      search_params = { query: 'question', scope: 'blabla' }
      expect(SearchService.call(search_params)).to be_nil
    end
  end
end
