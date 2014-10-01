class Campaign
  class Survey
    class Question
      class OptionDecorator < Draper::Decorator
        delegate_all

        def permalink
          "#{campaign.decorate.permalink}/#/o/#{code}"
        end
      end
    end
  end
end
