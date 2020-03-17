require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries sign out' do
    expect(page).to_not have_link 'Log out'
  end
end

