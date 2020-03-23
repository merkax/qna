require 'rails_helper'

feature 'User can selects the best answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe "Authenticated user", js: true do
    describe 'Author question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'set best answer for question' do
        within ".answer_#{answer.id}" do
          expect(page).to_not have_content 'Best answer:'
          click_on 'Set best'
          expect(page).to have_content 'Best answer:'
        end
      end
      
      scenario 'set new best answer' do
        within ".answers" do
          
          within "div.answer_#{answers[2].id}" do
            click_on 'Set best'
          end

          within "div.answer_#{answers[0].id}" do
            click_on 'Set best'

            expect(page).to have_content 'Best answer:'
            expect(page).to_not have_content 'Set best'
          end

          answers[1, answers.size].each do |answer|
            within "div.answer_#{answer.id}"do
              expect(page).to have_content 'Set best'
            end
          end
        
          expect(page.find('.answers div:first-child')).to have_content answers[0].body
        end
      end
    end

    scenario "user tries set best answer(dont't author question)" do 
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_content 'Set best'
    end
  end

  describe "Unauthenticated user" do
    scenario 'tries set best answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Set best'
    end
  end
end
