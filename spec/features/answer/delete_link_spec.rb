require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question ) }
  given!(:answer) { create(:answer, user: user, question: question ) }
  given!(:google_url) { create(:link, linkable: answer) }

  describe "Authenticated user", js: true do
    
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'delete link from answer' do
      expect(page).to have_link google_url.name, href: google_url.url

      click_on 'Delete link'

      within '.answers' do
        expect(page).to_not have_link google_url.name, href: google_url.url
      end
    end
  end

  describe "Unauthenticated user", js: true do
    before { visit question_path(question) }

    scenario 'tries delete link from question' do
      expect(page).to have_content answer.links.name
      expect(page).to_not have_link "Delete link"
    end
  end
end
