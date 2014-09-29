module Dashboard
  module Campaigns
    class InvitesController < Dashboard::BaseController
      layout 'dashboard/modal'
      def index
      end

      def new
        build_invite
      end

      def create
        build_invite
        if save_invite
          redirect_to action: :index
        else
          build_invite
          render action: :new
        end
      end

      protected

      def build_invite
        @invite = User::Translator::Invite.new
        @invite.campaign_id = Campaign.find(params[:campaign_id]).id
        @invite.attributes = invite_params
        authorize! :read, @invite.campaign
      end

      def save_invite
        authorize! :update, @invite.campaign
        @invite.save
      end

      def invite_params
        invite_params = params[:user_translator_invite]
        if invite_params
          invite_params.permit(:first_name, :last_name, :email, :locale_id)
        else
          {}
        end
      end
    end
  end
end
