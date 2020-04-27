require 'rails_helper'

feature 'User can sign in with providers' do
  given!(:user) { create(:user) }
  background { visit new_user_session_path }

  describe 'Sign in with Github' do
    scenario "can sign in user" do
      mock_auth_hash('github', email:'new@user.com')
      click_on "Sign in with GitHub"

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "failure sign in user" do
      failure_mock_auth('github')
      click_on "Sign in with GitHub"

      expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
    end

    scenario 'provider does not return email' do
      clean_mock_auth('github')
      mock_auth_hash('github', email: nil)
      click_on "Sign in with GitHub"
      
      fill_in "Email", with: 'new@user.com'
      click_on 'send'

      open_email('new@user.com')
      current_email.click_link('Confirm my account')
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario "can sign in user" do
      mock_auth_hash('vkontakte', email: 'new@user.com')
      click_on "Sign in with Vkontakte"
    
      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "failure sign in user" do
      failure_mock_auth('vkontakte')
      click_on "Sign in with Vkontakte"
    
      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials".'
    end

    scenario 'provider does not return email' do
      clean_mock_auth('vkontakte')
      mock_auth_hash('vkontakte', email: nil)
      click_on "Sign in with Vkontakte"
      
      fill_in "Email", with: 'new@user.com' 
      click_on 'send'

      open_email('new@user.com')
      current_email.click_link('Confirm my account')
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end
end
