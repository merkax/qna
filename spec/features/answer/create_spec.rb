require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the answer
} do
  
  given(:question) { create(:question) }
  
  describe "Authenticated user", js: true do
    
    given(:user) { create(:user) }
  
    background do
      sign_in(user)

      visit question_path(question)
    end
    
    scenario 'create answer' do
      fill_in "Body", with: 'answer body'
      click_on 'New answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer body'
      end
    end

    scenario 'create answer with errors' do
     click_on 'New answer'

     expect(page).to have_content "Body can't be blank"
    end

    scenario 'asks a answer with attached multiple file' do
      fill_in "Body", with: 'answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'New answer'
      
      expect(page).to have_content 'rails_helper.rb'
      expect(page).to have_content 'spec_helper.rb'
    end

    context 'multiple sessions' do
      scenario 'answer appears on another user', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in "Body", with: 'answer body'
          click_on 'New answer'

          expect(page).to have_content 'answer body'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'answer body'
        end
      end
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
