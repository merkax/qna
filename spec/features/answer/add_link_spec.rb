require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/zhengjia/428105' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in "Body", with: 'answer body'
    
    fill_in "Link name",	with: 'My gist'
    fill_in "Url",	with: gist_url
    
    click_on 'New answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
