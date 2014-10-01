class Campaign
  class EngagementPlayer
    class QuestionDecorator < Draper::Decorator
      delegate_all

      def permalink
        "#{campaign.decorate.permalink}/#/q/#{code}"
      end
    end
  end
end
