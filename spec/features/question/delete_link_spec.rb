require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user ) }
  given!(:google_url) { create(:link, linkable: question) }

  describe "Authenticated user", js: true do
    
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'delete link from question' do
      expect(page).to have_link google_url.name, href: google_url.url
      
      click_on 'Delete link'

      within '.question' do
        expect(page).to_not have_link google_url.name, href: google_url.url
      end
    end

  end

  describe "Unauthenticated user", js: true do
    before { visit question_path(question) }

    scenario 'tries delete link from question' do
      expect(page).to have_content question.links.name
      expect(page).to_not have_link "delete link"
    end
  end
end
