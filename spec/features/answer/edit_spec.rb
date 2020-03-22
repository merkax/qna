require 'rails_helper'

feature 'User can edit his answer' do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }


  describe "Authenticated user", js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end 

    scenario 'edits his answer'do
    click_on 'Edit'
    
    within '.answers' do
        # save_and_open_page
        fill_in "Your answer", with: "edited answer"
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content "edited answer"
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors' do
      
    end
    scenario "tries to edit other user's answer" do
      
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario 'can ton edit answer' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
