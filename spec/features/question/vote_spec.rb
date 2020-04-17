require 'rails_helper'

feature 'User can vote for question' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe "Authenticated user", js: true do
    describe 'author question' do

      background do
        sign_in(author)
        visit question_path(question)
      end 

      scenario 'vote up his question' do
        expect(page).to_not have_selector 'vote'
      end

      scenario 'vote down his question' do
        expect(page).to_not have_selector 'vote'
      end

      scenario 'cancel vote his question' do 
        expect(page).to_not have_selector 'vote'
      end
    end

    describe "not author question" do

      background do
        sign_in(user)
        visit question_path(question)
      end 

      scenario 'vote up another question' do
        click_on 'Like'

        within '.rating' do
          expect(page).to have_content 1
        end
      end

      scenario 'vote up twice for question' do
        within '.question' do
          click_on 'Like'
          click_on 'Like'

          within '.rating' do
          expect(page).to have_content 1
         end
        end
      end

      scenario 'cancel vote for question' do
        click_on 'Like'
        click_on 'cancel vote'

        expect(page).to have_content 0
      end

      scenario 'vote down for question' do
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content -1
        end
      end

      scenario 're-vote' do
        click_on 'Like'
        click_on 'cancel vote'
        click_on 'Dislike'

        within '.rating' do
          expect(page).to have_content -1
        end
      end
    end
  end

  describe "Unauthenticated user" do
    scenario "can't edit question" do
      visit question_path(question)
      expect(page).to_not have_selector 'vote'
    end
  end
end
