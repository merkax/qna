require 'rails_helper'

feature 'User can view a list of question' do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) } #, user: user обязательно?
  
  background { visit questions_path }

  scenario 'view a list of question' do
    questions.each { |question| expect(page).to have_content(question.title) }
  end
end
