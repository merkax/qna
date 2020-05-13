require 'sphinx_helper'

feature 'Search' do
  given!(:user) { create(:user) }
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question) }
  given!(:questions) { create_list(:question, 2) }
  given!(:answer) { create(:answer) }
  given!(:answers) { create_list(:answer, 2, question: question) }
  given!(:comment) { create(:comment, body: 'comment body', commentable: question, user: user) }
  given!(:comments) { create_list(:comment, 2, commentable: question, user: user) }

  describe 'Search by', sphinx: true, js: true do
    before { visit root_path }

    scenario 'question' do
      ThinkingSphinx::Test.run do
        fill_in 'search[query]', with: question.title
        select Question, from: 'search[scope]'
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'answer' do
      ThinkingSphinx::Test.run do
        fill_in 'search[query]', with: answer.body
        select Answer, from: 'search[scope]'
        click_on 'Search'

        expect(page).to have_content answer.body

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'comment' do
      ThinkingSphinx::Test.run do
        fill_in 'search[query]', with: comment.body
        select Comment, from: 'search[scope]'
        click_on 'Search'

        expect(page).to have_content comment.body

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'user' do
      ThinkingSphinx::Test.run do
        fill_in 'search[query]', with: user.email
        select User, from: 'search[scope]'
        click_on 'Search'

        expect(page).to have_content user.email

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'all' do
      ThinkingSphinx::Test.run do
        fill_in 'search[query]', with: question.title
        select 'All', from: 'search[scope]'
        click_on 'Search'

        expect(page).to have_content question.title

        questions.each do |question|
          expect(page).to_not have_content question.title
        end

        answers.each do |answer|
          expect(page).to_not have_content answer.body
        end

        comments.each do |comment|
          expect(page).to_not have_content comment.body
        end

        users.each do |user|
          expect(page).to_not have_content user.email
        end
      end
    end
  end
end
