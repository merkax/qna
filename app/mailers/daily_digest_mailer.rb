class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"

    mail to: user.email
  end
end
