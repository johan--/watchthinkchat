# rubocop:disable Style/ClassAndModuleChildren
class Campaign::CommunityDecorator < Draper::Decorator
  decorates Campaign::Community
  delegate_all

  def permalink
    return child_campaign.decorate.permalink if other_campaign?
    url
  end

  def display_title
    return child_campaign.name if other_campaign?
    title
  end
end
# rubocop:enable Style/ClassAndModuleChildren
