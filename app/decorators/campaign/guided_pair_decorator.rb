class Campaign
  class GuidedPairDecorator < Draper::Decorator
    delegate_all

    def title
      return object.title unless object.title.blank?
      I18n.t(:title, scope: [:models, :campaign, :guided_pair])
    end

    def description
      return object.description unless object.description.blank?
      I18n.t(:description, scope: [:models, :campaign, :guided_pair])
    end
  end
end
