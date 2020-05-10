require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { NewAnswerMailer.send_notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Send notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Answer for question")
    end
  end
end
