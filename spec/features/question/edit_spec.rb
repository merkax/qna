require 'rails_helper'

feature 'User can edit his question' do
  
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:google_url) { 'https://www.google.com/' }


  describe "Authenticated user", js: true do
    describe 'author question' do
        
      background do
        sign_in(author)
        visit question_path(question)
      end 

      scenario 'edits his question'do
        within '.question' do
          click_on 'Edit'
          fill_in "Title", with: "edited question title"
          fill_in "Body", with: "edited question body"
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content "edited question title"
        end
      end

      scenario 'edits his question with errors' do
        within '.question' do
          click_on 'Edit'
          fill_in 'Title', with: ' '
          fill_in 'Body', with: ' '
          click_on 'Save'

          expect(page).to have_content question.body
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end

      scenario 'edit a question with attached multiple file' do
        within '.question' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edits his question and add new link'do
        within '.question' do
          click_on 'Edit'
          
          click_on 'add link'

          fill_in "Link name",	with: 'google'
          fill_in "Url",	with: google_url

          click_on 'Save'

          expect(page).to_not have_link 'google', href: google_url
        end
      end
    end

    describe 'not author question' do
      scenario "tries to edit other user's question" do
        sign_in(user)
        visit question_path(question)
        
        within '.question' do
          expect(page).to have_content question.body
          expect(page).to_not have_link 'Edit'
        end
      end
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario "can't edit question" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
