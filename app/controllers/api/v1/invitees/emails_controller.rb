module Api
  module V1
    module Invitees
      class EmailsController < Api::V1Controller
        def create
          build_email
          save_email
          @email = @email.decorate
          render 'show', status: :created
        end

        protected

        def build_email
          @email ||= Visitor::Invitee::Email.new
          @email.attributes = email_params
        end

        def save_email
          @email.save!
        end

        def load_invitation
          @inviter ||= current_visitor.as(:inviter)
          @invitation ||= @inviter.invitations.find_by(campaign: @campaign,
                                                       inviter: @inviter,
                                                       invitee: @inviter.invitees.find(params[:invitee_id]))
        end

        def email_params
          EmailParams.permit(params).merge(invitation_id: load_invitation.id)
        end

        class EmailParams
          def self.permit(params)
            params.require(:email).permit(:subject, :message)
          end
        end
      end
    end
  end
end
