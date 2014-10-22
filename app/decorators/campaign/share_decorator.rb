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
  end
end
