class Campaign::Community < ActiveRecord::Base
  extend Translatable
  # associations
  belongs_to :campaign
  belongs_to :child_campaign, class_name: '::Campaign'
  has_many :translations, as: :resource, dependent: :destroy

  delegate :permalink, to: :child_campaign

  # validations
  validates :campaign, presence: true
  validates :enabled, inclusion: [true, false]
  validates :other_campaign,
            inclusion: [true, false],
            if: -> { enabled? }
  validates :child_campaign,
            presence: true,
            if: -> { enabled? && other_campaign? }
  validates :title,
            presence: true,
            if: -> { enabled? && !other_campaign? }
  validates :description,
            presence: true,
            if: -> { enabled? && !other_campaign? }
  validates :url,
            presence: true,
            if: -> { enabled? && !other_campaign? }
  validates :url,
            length: { maximum: 255 },
            if: -> { enabled? && !other_campaign? }
  validates :url, format: URI.regexp(%w(http https)), allow_blank: true

  # definitions
  translatable :url, :description, :title
end
