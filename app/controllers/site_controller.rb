class SiteController < ApplicationController
  before_action :load_campaign
  before_action :sign_in_visitor
  decorates_assigned :campaign

  def index
    return render 'no_campaign' if @campaign.nil?
  end

  protected

  def load_campaign
    url = request.host
    url.slice! ".#{ENV['base_url']}"
    url.slice! '.lvh.me' if Rails.env.test? # capybara-webkit bug
    @campaign = Campaign.opened.find_by(url: url)
  end

  def sign_in_visitor
    unless user_signed_in?
      visitor = User::Visitor.create
      visitor.save
      sign_in visitor
    end
    current_user.roles << :visitor
    Permission.find_or_create_by(resource: @campaign,
                                 user: current_visitor,
                                 state: Permission.states[:visitor])
  end
end
