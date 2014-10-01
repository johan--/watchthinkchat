class Campaign
  class GuidedPairDecorator < Draper::Decorator
    delegate_all

    def title
      object.title ||
        I18n.t(:title, scope: [:models, :campaign, :guided_pair])
    end

    def description
      object.description ||
        I18n.t(:description, scope: [:models, :campaign, :guided_pair])
    end
  end
end
