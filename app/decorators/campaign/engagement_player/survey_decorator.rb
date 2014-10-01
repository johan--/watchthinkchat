class Campaign
  class EngagementPlayer
    class SurveyDecorator < Draper::Decorator
      decorates_association :option
      decorates_association :question
      delegate_all
    end
  end
end
