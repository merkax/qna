require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) } 
  let(:answer) { create(:answer, question: question) } 
  #let!(:subscriber_last) { create(:subscription, question: question, user: users.last) } #стоит указывать для первого теста или хватит одного?

  it 'sends notifications to question subscribers' do
    answer.question.subscriptions.each do |subscription|
      expect(NewAnswerMailer).to receive(:send_notification).with(subscription.user, answer).and_call_original
    end

    NewAnswerNotificationService.call(answer)
  end

  it 'does not send notifications to unsubscribed users' do
    #NewAnswerNotificationService.call(answer)
    expect(NewAnswerMailer).to_not receive(:send_notification).with(users.last, answer).and_call_original
  end
end

