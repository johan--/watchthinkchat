class Campaign
  class ShareDecorator < Draper::Decorator
    delegate_all

    def title
      return object.title unless object.title.blank?
      I18n.t(:title, scope: [:models, :campaign, :share])
    end

    def description
      return object.description unless object.description.blank?
      I18n.t(:description, scope: [:models, :campaign, :share])
    end

    def subject
      return object.title unless object.title.blank?
      I18n.t(:subject, scope: [:models, :campaign, :share])
    end

    def message
      return object.description unless object.description.blank?
      I18n.t(:message, scope: [:models, :campaign, :share])
    end
  end
end
