class Campaign
  class GuidedPair < ActiveRecord::Base
    extend Translatable
    # associations
    belongs_to :campaign
    has_many :translations, as: :resource, dependent: :destroy

    # validations
    validates :campaign, presence: true
    validates :enabled, inclusion: [true, false]

    # definitions
    translatable :title, :description
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