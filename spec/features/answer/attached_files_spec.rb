require 'rails_helper'

feature 'User can attached files his answer' do
  
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:answer_with_file) { create(:answer, :with_files, question: question, user: author) }

  describe "Authenticated user", js: true do
    describe 'author answer' do
        
      background do
        sign_in(author)
      end 

      scenario 'asks a answer with attached multiple file' do
        visit question_path(question)
        fill_in "Body", with: 'Test answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        
        click_on 'New answer'

        within "div.attachments" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'edit a answer with attached multiple file' do
        visit question_path(question)
        within "div.answer_#{answer.id}" do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'can delete any file from answer' do
        visit question_path(answer_with_file.question)
        within "div.answer_#{answer_with_file.id}" do
          click_on 'Edit'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'

          within "div.attachment-file-#{answer_with_file.files[0].id}" do
            click_on "Delete file"
          end
          click_on 'Save'

          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
    
    describe 'not author answer' do
      scenario "tries delete files other user's answer" do
        sign_in(user)
        visit question_path(answer_with_file.question)
        
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to_not have_link "Delete file"
        end
      end
    end
  end

  describe "Unauthenticated user", js: true do
    background { visit question_path(answer_with_file.question) }

    scenario 'can delete files from answer' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to_not have_link "Delete file"
    end
  end
end
