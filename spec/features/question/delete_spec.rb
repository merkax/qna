require 'rails_helper'

feature 'Author can delete question' do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe "Authenticated user" do
    scenario "delete own question" do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content question.title
      click_on "Delete question"
      expect(page).to_not have_content question.title
    end
      
    scenario "user can not delete don't own question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link 'Delete question'
    end
  end

  describe "Unauthenticated user" do
    scenario "can delete question" do
      visit question_path(question)

      expect(page).to have_content question.title
      expect(page).to_not have_link "Delete question"
    end
  end
end
