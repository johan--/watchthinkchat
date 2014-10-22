class CampaignDecorator < Draper::Decorator
  decorates_association :engagement_player
  decorates_association :survey
  decorates_association :community
  decorates_association :share
  delegate_all

  def permalink
    return "http://#{url}.#{ENV['base_url']}" if subdomain?
    "http://#{url}"
  end
end
