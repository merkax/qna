require 'rails_helper'

feature 'User can vote for answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe "Authenticated user", js: true do
    describe 'author answer' do

      background do
        sign_in(author)
        visit question_path(answer.question)
      end 

      scenario 'vote up his answer' do
        within '.answers' do
          expect(page).to_not have_selector 'vote'
        end
      end

      scenario 'vote down his answer' do
        within '.answers' do
          expect(page).to_not have_selector 'vote'
        end
      end

      scenario 'cancel vote his answer' do
        within '.answers' do
          expect(page).to_not have_selector 'vote'
        end
      end
    end

    describe "not author answer" do

      background do
        sign_in(user)
        visit question_path(answer.question)
      end 

      scenario 'vote up another answer' do
        within '.answers' do

          click_on 'Like'

          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      scenario 'vote up twice  another answer' do
        within '.answers' do
          click_on 'Like'
          click_on 'Like'

          within '.rating' do
            expect(page).to have_content 1
          end
        end
      end

      scenario 'cancel vote another answer' do
        within '.answers' do
          click_on 'Like'
          click_on 'cancel vote'

          expect(page).to have_content 0
        end
      end

      scenario 'vote down another answer' do
        within '.answers' do

          click_on 'Dislike'

          within '.rating' do
            expect(page).to have_content -1
          end
        end
      end

      scenario 're-vote' do
        within '.answers' do
          click_on 'Like'
          click_on 'cancel vote'
          click_on 'Dislike'

          within '.rating' do
            expect(page).to have_content -1
          end
        end
      end
    end
  end

  describe "Unauthenticated user" do
    scenario "can't edit answer" do
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to_not have_selector 'vote'
      end
    end
  end
end
