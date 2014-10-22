class Visitor
  class InvitationDecorator < Draper::Decorator
    delegate_all
    decorates_association :campaign

    def url
      "#{campaign.permalink}/i/#{token}"
    end
  end
end
