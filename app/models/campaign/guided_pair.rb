class Campaign
  class GuidedPair < ActiveRecord::Base
    # associations
    belongs_to :campaign

    # validations
    validates :campaign, presence: true
    validates :enabled, inclusion: [true, false]

    def title
      self[:title] ||
        I18n.t(:title, scope: [:models, :campaign, :guided_pair])
    end

    def description
      self[:description] ||
        I18n.t(:description, scope: [:models, :campaign, :guided_pair])
    end
  end
end
