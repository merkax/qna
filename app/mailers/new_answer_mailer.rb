class NewAnswerMailer < ApplicationMailer
  def send_notification(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email
  end
end
