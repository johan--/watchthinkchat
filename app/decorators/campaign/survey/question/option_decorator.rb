require 'campaign'
require 'campaign/survey'
require 'campaign/survey/question'
class Campaign
  class Survey
    class Question
      class OptionDecorator < Draper::Decorator
        decorates Campaign::Survey::Question::Option
        delegate_all

        def permalink
          "#{campaign.decorate.permalink}/#/o/#{code}"
        end
      end
    end
  end
end
