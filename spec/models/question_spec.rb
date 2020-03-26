require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "Association" do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to :user }
  end
  
  it { should accept_nested_attributes_for :links }

  describe "Validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
