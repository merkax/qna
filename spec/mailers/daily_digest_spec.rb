require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) } 
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:questions_yesterday) { create_list(:question, 2, :yesterday_question) }
    let(:questions_two_days_ago) { create_list(:question, 2, :two_day_ago_question) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mishabigr@yandex.ru"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New questions for the last day")
    end

    it 'render only last day questions' do
      questions_yesterday.each do |question|
        expect(mail.body.encoded).to match question.title
      end
    end

    it 'does not render two days ago questions' do
      questions_two_days_ago.each do |question|
        expect(mail.body.encoded).to_not match question.title
      end
    end
  end
end
