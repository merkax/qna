require 'rails_helper'

feature 'User can edit his answer' do
  
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }


  describe "Authenticated user", js: true do
    describe 'author answer' do
        
      background do
        sign_in(author)
        visit question_path(question)
      end 

      scenario 'edits his answer'do
        within '.answers' do
          click_on 'Edit'
          fill_in "Your answer", with: "edited answer"
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content "edited answer"
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors' do
        within '.answers' do
          click_on 'Edit'
          fill_in 'Your answer', with: ' '
          click_on 'Save'

          expect(page).to have_content answer.body
        end
        expect(page).to have_content "Body can't be blank"
      end

      scenario 'edit a question with attached multiple file' do
        within '.answers' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    describe 'not author answer', js: true do
      scenario "tries to edit other user's answer" do
        sign_in(user)
        visit question_path(question)
        
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to_not have_link 'Edit'
        end
      end
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario 'can ton edit answer' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
