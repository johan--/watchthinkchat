module Api
  module V1
    module Invitees
      class Mailer < ActionMailer::Base
        def send_invitation(email)
          @message = email.message
          @campaign = email.campaign.decorate
          @invitee = email.invitee.decorate
          @inviter = email.inviter.decorate
          mail from: email.from,
               to: email.to,
               subject: email.subject
        end
      end
    end
  end
end
