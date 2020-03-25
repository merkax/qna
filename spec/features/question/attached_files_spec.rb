require 'rails_helper'

feature 'User can attached files his question' do
  
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:question_with_file) { create(:question, :with_files, user: author) }

  describe "Authenticated user", js: true do
    describe 'author question' do
        
      background do
        sign_in(author)
      end 

      scenario 'asks a question with attached multiple file' do
        visit questions_path
        click_on 'Ask question'
        fill_in "Title", with: 'Test question'
        fill_in "Body", with: 'text text text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edit a question with attached multiple file' do
        visit question_path(question)
        within '.question' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'can delete any file from question' do
        visit question_path(question_with_file)
        within '.question' do
          click_on 'Edit'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'

          within "div.attachment-file-#{question_with_file.files[0].id}" do
            click_on "Delete file"
          end
          click_on 'Save'
          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
    
    describe 'not author question' do
      scenario "tries delete files other user's question" do
        sign_in(user)
        visit question_path(question_with_file)
        
        within '.question' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to_not have_link "Delete file"
        end
      end
    end
  end

  describe "Unauthenticated user", js: true do
    background { visit question_path(question_with_file) }

    scenario 'can delete files from question' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to_not have_link "Delete file"
    end
  end
end
