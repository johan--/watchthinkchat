class VisitorDecorator < Draper::Decorator
  delegate_all

  def name
    "#{first_name} #{last_name}".strip
  end

  def url(campaign)
    "#{campaign.try(:decorate).try(:permalink)}/i/#{share_token}"
  end
end
