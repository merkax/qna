require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  describe "Unregistered user" do
    
    given(:user_attribute) { attributes_for(:user) }
    
    scenario 'tries sign up' do
      fill_in 'Email', with: user_attribute[:email]
      fill_in "Password", with: user_attribute[:password]
      fill_in "Password confirmation", with: user_attribute[:password_confirmation]
      click_on 'Sign up'
      
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      open_email(user_attribute[:email])
      current_email.click_link('Confirm my account')
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'tries sign up with errors attribute' do
      fill_in 'Email', with: user_attribute[:email]
      fill_in "Password", with: user_attribute[:password]
      fill_in "Password confirmation", with: ' '
      click_on 'Sign up'
      
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  describe "Registered user" do

    given(:user) { create(:user) }

    scenario 'tries to sign up' do
      fill_in 'Email', with: user.email
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password_confirmation
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
