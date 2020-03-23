require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "Association" do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe "Validation" do
    it { should validate_presence_of :body }
  end

  describe '#set_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }
    let!(:another_answer) { create(:answer, question: question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    
    it 'set best answer' do
      answer.set_best!

      expect(answer).to be_best
    end
    
    it 'another answer is best' do
      answer.set_best!
      another_answer.set_best!

      expect(question.answers.where(best: true).count).to eq 1
    end

    it 'best answer first on the list' do
      answers[1].set_best!

      expect(question.answers.first).to be_best
    end
  end
end
