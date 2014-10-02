class Campaign
  class Survey
    class QuestionDecorator < Draper::Decorator
      decorates_association :option
      delegate_all

      def permalink
        "#{campaign.decorate.permalink}/#/q/#{code}"
      end
    end
  end
end
