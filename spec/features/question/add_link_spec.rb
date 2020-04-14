require 'rails_helper'

feature 'User can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/merkax/7888a37c76e5a69b0de1dda0ee5f326b' }
  given(:google_url) { 'https://www.google.com/' }
  given(:yandex_url) { 'https://yandex.ru/' }

  describe "Authenticated user", js: true do
    
    background do
      sign_in(user)
      visit new_question_path

      fill_in "Title", with: 'Test question'
      fill_in "Body", with: 'text text text'
    end

    scenario 'adds link when asks question' do
      fill_in "Link name",	with: 'google'
      fill_in "Url",	with: google_url

      click_on 'Ask'

      expect(page).to have_link 'google', href: google_url
    end

    scenario 'add multiple links' do
      fill_in "Link name",	with: 'yandex'
      fill_in "Url",	with: yandex_url

      click_on 'add link'
    
      page.all('.nested-fields').last.fill_in "Link name",	with: 'google'
      page.all('.nested-fields').last.fill_in "Url",	with: google_url
      
      click_on 'Ask'

      within '.question' do
        expect(page).to have_link 'yandex', href: yandex_url
        expect(page).to have_link 'google', href: google_url
      end
    end

    scenario 'add link invalid attributes' do
      fill_in "Link name",	with: 'My gist'
      fill_in "Url",	with: 'url'

      click_on 'Ask'

      expect(page).to_not have_link 'My gist'
      expect(page).to_not have_link 'url'
      expect(page).to have_content 'please enter the URL in the correct format'
    end

    scenario 'add link with gist url' do
      fill_in "Link name",	with: 'My gist'
      fill_in "Url",	with: gist_url
      
      click_on 'Ask'
      
      expect(page).to have_content 'Who is Matz?'
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

  describe "Unauthenticated user", js: true do
    before { visit new_question_path }

    scenario 'tries add link when asks answer' do
      expect(page).to_not have_link 'Link name'
      expect(page).to_not have_link 'Url'
    end
  end
end
