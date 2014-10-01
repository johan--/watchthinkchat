class Campaign < ActiveRecord::Base
  extend Translatable
  SUBDOMAIN = /\A((?!app)[a-z0-9][a-z0-9\-]*[a-z0-9]|[a-z0-9])\z/i
  CNAME = /\A^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?\z/i
  # associations
  has_many :permissions, as: :resource, dependent: :destroy
  has_many :users, through: :permissions
  has_many :translation_groups, class_name: 'Translation', dependent: :destroy
  has_many :translations, as: :resource, dependent: :destroy
  has_many :available_locales, dependent: :destroy
  has_many :locales, through: :available_locales
  belongs_to :locale
  has_one :engagement_player,
          dependent: :destroy,
          class_name: 'Campaign::EngagementPlayer'
  has_one :survey,
          dependent: :destroy,
          class_name: 'Campaign::Survey'
  has_one :community,
          dependent: :destroy,
          class_name: 'Campaign::Community'
  has_one :guided_pair,
          dependent: :destroy,
          class_name: 'Campaign::GuidedPair'
  accepts_nested_attributes_for :engagement_player, update_only: true
  accepts_nested_attributes_for :survey, update_only: true
  accepts_nested_attributes_for :community, update_only: true
  accepts_nested_attributes_for :guided_pair, update_only: true

  # validations
  validates_associated :engagement_player
  validates_associated :survey
  validates_associated :community
  validates_associated :guided_pair
  validates :name, presence: true, unless: :basic?
  validates :locale, presence: true, unless: :basic?
  validates :url, presence: true, uniqueness: true, unless: :basic?
  validates :url, length: { maximum: 63 }, if: :subdomain?
  validates :url, length: { maximum: 255 }, unless: :subdomain?
  validates :url,
            format: { with: SUBDOMAIN,
                      if: :subdomain? },
            allow_blank: true
  validates :url,
            format: { with: CNAME,
                      unless: :subdomain? },
            allow_blank: true
  # callbacks
  after_create do
    campaign.create_survey
  end

  # definitions
  enum status: [:basic,
                :closed,
                :opened,
                :engagement_player,
                :survey,
                :guided_pair,
                :community]
  translatable :name
  scope :owner, (lambda do
    where('permissions.state = ?', Permission.states[:owner].to_i)
  end)
  scope :translator, (lambda do
    where('permissions.state = ?', Permission.states[:translator].to_i)
  end)

  def campaign
    self
  end
end
