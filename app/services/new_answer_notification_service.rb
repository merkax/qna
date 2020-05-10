class NewAnswerNotificationService
  def self.call(answer)
    answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.send_notification(subscription.user, answer).deliver_later
    end
  end
end
