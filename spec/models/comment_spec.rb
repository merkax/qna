require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "Association" do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe "Validation" do
    it { should validate_presence_of :body }
  end
end
