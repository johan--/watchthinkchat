class Campaign
  class EngagementPlayer
    class OptionDecorator < Draper::Decorator
      delegate_all

      def permalink
        "#{campaign.decorate.permalink}/#/o/#{code}"
      end
    end
  end
end
