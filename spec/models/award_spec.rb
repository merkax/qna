require 'rails_helper'

RSpec.describe Award, type: :model do
  describe "Association" do
    it { should belong_to :question }
    it { should belong_to(:user).optional }
  end

  describe "Validation" do
    it { should validate_presence_of :name }
  end

  describe "Attached files" do
    it 'have many attached files' do
      expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end
end
