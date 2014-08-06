class Api::CampaignsController < ApplicationController
  #before_filter :ensure_operator_json, :only => :password
  before_filter :authenticate_user!, :only => :password

  def show
    @campaign = Campaign.where(:uid => params[:uid]).first
    if !@campaign
      render :json => { error: "No campaign found with that uid" }, status: 404
    elsif !@campaign.valid?
      render json: { error: @campaign.errors.to_a, status: 406 }
    else
      render json: @campaign, status: 201
    end
  end

  def index
    @campaigns = current_user.admin_campaigns
    render json: @campaigns, status: 201
  end

  def update
    @campaign = Campaign.where(:uid => params[:uid]).first

    unless @campaign.is_admin?(current_user)
      render :json => { error: "User is not admin" }, status: 403
      return
    end

    if @campaign
      create_or_update_campaign
    else
      render :json => { error: "No campaign found with that uid" }, status: 404
    end
  end

  def create
    @campaign = Campaign::AsCreate.new
    create_or_update_campaign
  end

  def password
    @campaign = Campaign.where(:uid => params[:uid]).first
    unless @campaign.opened?
      render :json => { error: "Sorry, campaign is closed" }, status: 403
      return
    end
    if params[:password].present? && @campaign.try(:password) == params[:password]
      #puts "Api::CampaignsController#password"
      # this is the most secure spot to mark them as an operator
      begin
        short_url = current_user.mark_as_operator!(@campaign)
        render :json => { :valid => true, :share_url => short_url }, status: 201
      rescue RestClient::Unauthorized => e
        render :json => { error: "Invalid missionhub token" }, status: 500
        return
      end
    elsif @campaign
      render :json => { error: "Password not valid" }, status: 401
    else
      render :json => { error: "No campaign found with that uid" }, status: 404
    end
  end

  def stats
    @campaign = Campaign.where(:uid => params[:uid]).first
    total_live_chats = 0
    total_alltime_chats = 0
    total_challenge_subscribe_self = 0
    total_challenge_subscribe_friend = 0
    total_challenge_friend_accepted = 0
    rows = @campaign.operators.collect { |o|
      live_chats = o.operator_chats.where(campaign: @campaign, status: "open").collect(&:uid)
      # count chats
      live_chats_count = live_chats.count
      alltime_chats_count = o.count_operator_chats_for(@campaign)
      # totals
      total_live_chats += live_chats_count
      total_alltime_chats += alltime_chats_count

      # build row for the collect
      o.stats_row(@campaign)
    }
    @campaign.users.each do |u|
      total_challenge_subscribe_self += 1 if u.challenge_subscribe_self
      total_challenge_subscribe_friend += 1 if u.challenge_subscribe_friend
      total_challenge_friend_accepted += 1 if u.challenge_friend_accepted
    end

    totals = {
      "total_live_chats" => total_live_chats,
      "total_alltime_chats" => total_alltime_chats,
      "total_challenge_subscribe_self" => total_challenge_subscribe_self,
      "total_challenge_subscribe_friend" => total_challenge_subscribe_friend,
      "total_challenge_friend_accepted" => total_challenge_friend_accepted
    }

    render :json => { "operators" => rows, "totals" => totals }
  end

  private

  def create_or_update_campaign
    params[:name] = params.delete(:title)
    params[:campaign_type] = params.delete(:type)
    params[:followup_buttons] ||= []
    campaign_params = params.permit(:uid, :followup_buttons, :name, :cname, :created_at, :updated_at, :missionhub_token, :permalink, :video_id, :campaign_type, :uid, :max_chats, :chat_start, :owner, :user_id, :description, :language, :status, :password, :admin1_id, :admin2_id, :admin3_id, :preemptive_chat, :growth_challenge)
    params.delete(:password) unless params[:password].present?

    # handle new buttons
    if params[:followup_buttons].present?
      new_buttons = []
      errors = []
      params.require(:followup_buttons).each_with_index do |fb, i|
        new_button = FollowupButton.new fb.permit(:message_active_chat, :message_no_chat, :btn_id, :btn_text).slice(:message_active_chat, :message_no_chat).merge(:btn_text => fb[:text], :btn_id => fb[:id])
        new_button.campaign = @campaign
        new_buttons << new_button
        unless new_button.valid?
          errors += new_button.errors.to_a.collect{ |err| "Followup button #{i+1}: #{err}" }
        end
      end
      # don't save anything unless all buttons passed in are valid
      if errors.present?
        render json: { error: errors }, status: 406
        return
      end
    end

    @campaign.update(campaign_params)
    unless @campaign.valid?
      render json: { error: @campaign.errors.to_a }, status: 406
    else
      # At this point, the campaign update is valid and all new followup buttons are valid.  Delete all old buttons and make new ones.
      @campaign.followup_buttons.delete_all
      if new_buttons.present?
        new_buttons.collect{ |b| b.campaign = @campaign; b.save! }
      end
      @campaign.reload
      render json: @campaign, status: 201
    end
  end
end
