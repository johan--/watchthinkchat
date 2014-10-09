require_dependency(Rails.root.join 'app', 'models', 'campaign', 'survey')
require_dependency(Rails.root.join 'app', 'models', 'campaign', 'survey', 'question')
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
