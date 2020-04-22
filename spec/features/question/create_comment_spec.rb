require 'rails_helper'

feature 'User can create comment' do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe "Authenticated user", js: true do
  
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'user can create comment'do
      fill_in "comment", with: "test question comment"
      click_on 'add comment'
        
      expect(page).to have_content "test question comment"
    end

    scenario 'can create a comment with errors' do
      click_on 'add comment'

      expect(page).to have_content "Body can't be blank"
    end

    context 'Multiple sessions' do
      scenario 'comments appears on another users page', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in "comment", with: "test question comment"
          click_on 'add comment'

          expect(page).to have_content 'test question comment'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'test question comment'
        end
      end
    end
  end

  describe "Unauthenticated user" do
    scenario 'tries to comment a question' do
      visit question_path(question)

      expect(page).to_not have_selector '.new-comment'
    end
  end
end
