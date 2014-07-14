class Api::CampaignsController < ApplicationController
  #before_filter :ensure_operator_json, :only => :password
  before_filter :authenticate_user!, :only => :password

  def show
    @campaign = Campaign.where(:uid => params[:uid]).first
    if @campaign
      render json: @campaign, status: 201
    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end

  def index
    @campaigns = current_user.admin_campaigns
    render json: @campaigns, status: 201
  end

  def update
    @campaign = Campaign.where(:uid => params[:uid]).first

    unless @campaign.is_admin?(current_user)
      render :json => { :error => "User is not admin" }, :status => 404
      return
    end

    params[:name] = params.delete(:title)
    params[:campaign_type] = params.delete(:type)
    campaign_params = params.permit(:uid, :followup_buttons, :name, :cname, :created_at, :updated_at, :missionhub_token, :permalink, :video_id, :campaign_type, :uid, :max_chats, :chat_start, :owner, :user_id, :description, :language, :status, :password_hash, :admin1_id, :admin2_id, :admin3_id, :preemptive_chat, :growth_challenge)
    if @campaign
      # handle new buttons
      if params[:followup_buttons].present?
        new_buttons = []
        errors = []
        params.require(:followup_buttons).each_with_index do |fb, i|
          new_button = FollowupButton.new fb.permit(:message_active_chat, :message_no_chat, :btn_id, :btn_text).slice(:message_active_chat, :message_no_chat).merge(:btn_text => fb[:text], :btn_id => fb[:id])
          new_button.campaign = @campaign
          new_buttons << new_button
          unless new_button.valid?
            errors << { "followup_buttons_#{i}" => new_button.errors.messages }
          end
        end
        # don't save anything unless all buttons passed in are valid
        if errors.present?
          render json: { :error => errors }, status: 201
          return
        end

        # At this point, all new followup buttons are valid.  Delete all old buttons and make new ones
        @campaign.followup_buttons.delete_all
        new_buttons.collect(&:save!)
      end

      @campaign.update(campaign_params)
      unless @campaign.valid?
        render json: { :error => @campaign.errors.messages }, status: 201
      else
        @campaign.reload
        render json: @campaign, status: 201
      end

    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end

  def password
    @campaign = Campaign.where(:uid => params[:uid]).first
    unless @campaign.opened?
      render :json => { :error => "Sorry, campaign is closed" }, :status => 403
      return
    end
    if params[:password].present? && @campaign.try(:password) == params[:password]
      #puts "Api::CampaignsController#password"
      # this is the most secure spot to mark them as an operator
      begin
        short_url = current_user.mark_as_operator!(@campaign)
        render :json => { :valid => true, :share_url => short_url }, status: 201
      rescue RestClient::Unauthorized => e
        render :json => { :error => "Invalid missionhub token" }, :status => 500
        return
      end
    elsif @campaign
      render :json => { :error => "Password not valid" }, :status => 401
    else
      render :json => { :error => "No campaign found with that uid" }, :status => 404
    end
  end
end
