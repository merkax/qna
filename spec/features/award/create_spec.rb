require 'rails_helper'

feature 'User can create question with award' do
  given(:user) { create(:user) }
  
  describe "Authenticated user" do
  
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question with award' do
      fill_in "Title", with: 'Test question'
      fill_in "Body", with: 'text text text'

      fill_in "Name", with: 'Award for best answer'
      attach_file "Image", "#{Rails.root}/app/assets/images/award.png"

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end
  end

  describe "Unauthenticated user" do
    scenario 'tries to ask a question' do
      visit questions_path

      expect(page).to_not have_content 'Ask question'
    end
  end
end
