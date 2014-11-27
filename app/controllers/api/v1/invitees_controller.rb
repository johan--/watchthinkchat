module Api
  module V1
    class InviteesController < Api::V1Controller
      def index
        load_invitees
      end

      def show
        load_invitee
      end

      def create
        build_invitee
        save_invitee
        render 'show', status: :created
      end

      def update
        load_invitee
        build_invitee
        save_invitee
        render 'show', status: :ok
      end

      protected

      def load_invitees
        @invitees ||= invitee_scope.joins(:invitations).where('visitor_invitations.campaign_id = ?', @campaign.id)
      end

      def load_invitee
        @invitee ||= invitee_scope.find(params[:id])
        @invitee
      end

      def build_invitee
        @invitee ||= invitee_scope.build
        @invitee.attributes = invitee_params
      end

      def save_invitee
        return @invitee.save! if @invitee.persisted?
        @invitee.save!
        current_visitor.as(:inviter).invitations.create(invitee: @invitee,
                                                        campaign: @campaign)
      end

      def invitee_scope
        current_visitor.as(:inviter).invitees
      end

      def invitee_params
        InviteeParams.permit(params)
      end

      class InviteeParams
        def self.permit(params)
          params.require(:invitee).permit(:first_name, :last_name, :email, :notify_inviter)
        end
      end
    end
  end
end
