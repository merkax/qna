require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the answer
} do
  
  given(:question) { create(:question) }
  
  describe "Authenticated user" do

    given(:user) { create(:user) }
  
    background do
      sign_in(user)

      visit question_path(question)
    end
    
    scenario 'create answer' do
      fill_in "Body", with: 'answer body'
      click_on 'New answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer body'
    end

    scenario 'create answer with errors' do
     click_on 'New answer'

     expect(page).to have_content "Body can't be blank"
    end
  end

  describe "Unauthenticated user" do
    scenario 'tries to ask a answer' do
      visit question_path(question)
      click_on 'New answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
