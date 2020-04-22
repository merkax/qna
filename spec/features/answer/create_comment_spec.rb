require 'rails_helper'

feature 'User can create comment' do
  
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe "Authenticated user", js: true do
  
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'user can create comment'do
      within ".answer_#{answer.id}" do
        fill_in "comment", with: "test answer comment"
        click_on 'add comment'

        expect(page).to_not have_content "test answer comment"
      end
    end

    scenario 'can create comment with errors' do
      within ".answer_#{answer.id}" do
        click_on 'add comment'

        expect(page).to have_content "Body can't be blank"
      end
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
          within ".answer_#{answer.id}" do
            fill_in "comment", with: "test answer comment"

            click_on 'add comment'

            expect(page).to have_content 'test answer comment'
          end
        end

        Capybara.using_session('guest') do
          within ".answer_#{answer.id}" do
            expect(page).to have_content 'test answer comment'
          end
        end
      end
    end
  end

  describe "Unauthenticated user" do
    scenario 'tries to comment a answer' do
      visit question_path(question)

      expect(page).to_not have_selector '.new-comment'
    end
  end
end
