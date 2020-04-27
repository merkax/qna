require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe "Association" do
    it { should belong_to(:user) }
  end

  describe "Validation" do
    subject { create(:authorization) }

    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end
end
