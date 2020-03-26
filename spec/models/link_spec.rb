require 'rails_helper'

RSpec.describe Link, type: :model do
  describe "Association" do
    it { should belong_to :linkable }
  end
  
  describe "Validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end
end
