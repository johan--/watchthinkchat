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
  end
end
