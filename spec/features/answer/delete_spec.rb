require 'rails_helper'

feature 'Author can delete answer' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  describe "Authenticated user", js: true do
    scenario "delete own answer" do
      sign_in(author)
      visit question_path(answer.question)
      
      expect(page).to have_content answer.body
      click_on "Delete answer"
      expect(page).to_not have_content answer.body
    end

    scenario "delete don't own answer" do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe "Unauthenticated user" do
    scenario "can delete answer" do
      visit question_path(answer.question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link "Delete answer"
    end
  end
end
