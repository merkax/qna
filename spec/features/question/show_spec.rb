require 'rails_helper'

feature 'User can watch question and answers to it' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user ) }
  given!(:answer1) { create(:answer, question: question, user: user ) }
  
  describe "User" do
    background { visit question_path(question) }

    scenario 'show a of question' do
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'view a of answers' do
      expect(page).to have_content answer.body
      expect(page).to have_content answer1.body
    end
  end
end

