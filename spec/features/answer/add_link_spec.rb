require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/merkax/7888a37c76e5a69b0de1dda0ee5f326b' }
  given(:google_url) { 'https://www.google.com/' }

  describe "Authenticated user", js: true do
    
    background do
      sign_in(user)
      visit question_path(question)
      
      fill_in "Body", with: 'answer body'
    end
    
    scenario 'add link when asks answer' do
      fill_in "Link name",	with: 'google'
      fill_in "Url",	with: google_url

      click_on 'New answer'

      within '.answers' do
        expect(page).to have_link 'google', href: google_url
      end
    end

    scenario 'add multiple links when asks answer' do
      fill_in "Link name",	with: 'google'
      fill_in "Url",	with: google_url

      page.find('a.add_fields').click

      page.all('.nested-fields').last.fill_in "Link name",	with: 'My gist'
      page.all('.nested-fields').last.fill_in "Url",	with: gist_url

      click_on 'New answer'

      within '.answers' do
        expect(page).to have_link 'google', href: google_url
        expect(page).to have_content 'Who is Matz?'
      end
    end

    scenario 'add link invalid attributes' do
      fill_in "Link name",	with: 'My gist'
      fill_in "Url",	with: 'url'

      click_on 'New answer'

      expect(page).to_not have_link 'My gist'
      expect(page).to_not have_link 'url'
      expect(page).to have_content 'please enter the URL in the correct format'
    end

    scenario 'add link with gist url' do
      fill_in "Link name",	with: 'My gist'
      fill_in "Url",	with: gist_url

      click_on 'New answer'

      expect(page).to have_content 'Who is Matz?'
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  describe "Unauthenticated user", js: true do
    before { visit question_path(question) }

    scenario 'tries add link when asks answer' do
      expect(page).to_not have_link 'Link name'
      expect(page).to_not have_link 'Url'
    end
  end
end
