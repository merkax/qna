require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Association" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:awards).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'class FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
