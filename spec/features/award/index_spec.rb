require 'rails_helper'

feature 'User can view a list of awards' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_awards) { create_list(:award, 2, :with_image, question: question, user: user) }
  
  describe "Authenticated user" do

    background  do
      sign_in(user)

      visit awards_path
    end

    scenario 'view a list of awards' do
      user_awards.each do |award|
        expect(page).to have_content(award.question.title )
        expect(page).to have_content(award.name )
      end
    end
  end

  describe "Unauthenticated user" do

    scenario 'does not see links to awards' do
      expect(page).to_not have_link 'Your awards'
    end

    scenario 'attempt to go to page' do
      visit awards_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
