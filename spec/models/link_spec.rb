require 'rails_helper'

RSpec.describe Link, type: :model do
  describe "Association" do
    it { should belong_to :linkable }
  end
  
  describe "Validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_value('http://foo.com').for(:url) }
    it { should_not allow_value('foo.com').for(:url) }
  end

  describe "#gist?" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) } 
    let(:valid_gist) { create(:link, :gist_valid_url, linkable: question) }
    let(:invalid_gist) { create(:link, :gist_invalid_url, linkable: question) }

    it 'url is gist' do
      expect(valid_gist).to be_gist
    end

    it 'url is not gist' do
      expect(invalid_gist).to_not be_gist
    end
  end
end
