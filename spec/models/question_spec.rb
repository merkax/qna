require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Association" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to :user }
  end
  
  describe "Validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have one attached file' do
    expect(Question.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
