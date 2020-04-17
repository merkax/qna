require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe "Association" do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe "Validation" do
    it { should validate_presence_of :value }
    it { should validate_inclusion_of(:value).in_array([-1, 1]) }
    it { should validate_presence_of :user }
  end
end
