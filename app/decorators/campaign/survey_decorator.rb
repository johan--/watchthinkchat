class Campaign
  class SurveyDecorator < Draper::Decorator
    decorates_association :question
    delegate_all
  end
end
