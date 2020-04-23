require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe "Association" do
    it { should belong_to(:user) }
  end

  describe "Validation" do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
  end
end
