require 'rails_helper'

feature 'User can sign in with oauth', %q{

} do

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

    xscenario 'provider does not return email' do
      #todo
    end
  end

  describe 'Sign in with Vkontakte' do
    scenario "can sign in user with Vkontakte account" do
      mock_auth_hash('vkontakte', email: 'new@user.com')
      click_on "Sign in with Vkontakte"
    
      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    scenario "failure sign in user" do
      failure_mock_auth('vkontakte')
      click_on "Sign in with Vkontakte"
    
      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials".'
    end

    xscenario 'provider does not return email' do
      #todo
    end
  end
end
