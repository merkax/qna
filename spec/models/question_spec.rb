require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe "Association" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }
    it { should belong_to :user }
  end

  describe "Validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe "Attached files" do
    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
