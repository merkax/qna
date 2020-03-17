require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "Association" do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe "Validation" do
    it { should validate_presence_of :body }
  end
end
