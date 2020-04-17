require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Association" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:awards).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe "Validation" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
  
  describe "#owner?" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) } 
    let(:question1) { create(:question) }

    it 'current user is author' do
      expect(user).to be_owner(question)
    end

    it 'current user is not author' do
      expect(user).to_not be_owner(question1)
    end
  end
end
