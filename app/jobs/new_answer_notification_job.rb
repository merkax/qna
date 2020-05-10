class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotificationService.call(answer)
  end
end
