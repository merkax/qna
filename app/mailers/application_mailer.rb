class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[Rails.env.to_sym][:email][:sender]
  
  layout 'mailer'
end
