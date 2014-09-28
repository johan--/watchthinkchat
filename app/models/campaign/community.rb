class Campaign::Community < ActiveRecord::Base
  extend Translatable
  # associations
  belongs_to :campaign
  belongs_to :child_campaign, class_name: '::Campaign'
  has_many :translations, as: :resource, dependent: :destroy

  # validations
  validates :campaign, presence: true
  validates :url, presence: true, unless: :other_campaign?
  validates :description, presence: true, unless: :other_campaign?
  validates :child_campaign, presence: true, if: :other_campaign?

  # definitions
  translatable :url, :description
end
