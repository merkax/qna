require 'rails_helper'

feature 'User can subscribe to question', js: true do
  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users.first) }

  describe "Authenticated user" do
    describe 'Another user' do
      background do
        sign_in(users.last)

        visit question_path(question)
      end

      scenario 'subscribe to the question' do
        expect(page).to have_content 'Subscribe'

        click_on 'Subscribe'

        expect(page).to have_content 'Unsubscribe'
        expect(page).to_not have_content 'Subscribe'
      end
    end
  
    describe "Author" do
      background do
        sign_in(users.first)

        visit question_path(question)
      end

      scenario 'unsubscribe to the question' do
        expect(page).to have_content 'Unsubscribe'

        click_on 'Unsubscribe'

        expect(page).to have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  describe "Unauthenticated user" do
    scenario 'can not subscribe to the question' do
      visit question_path(question)

      expect(page).to_not have_content 'Unsubscribe'
      expect(page).to_not have_content 'Subscribe'
    end
  end
end
