class Campaign < ActiveRecord::Base
  extend Translatable

  # associations
  has_many :permissions, as: :resource, dependent: :destroy
  has_many :users, through: :permissions
  has_many :translation_groups, class_name: 'Translation', dependent: :destroy
  has_many :translations, as: :resource, dependent: :destroy
  has_many :available_locales, dependent: :destroy
  has_many :locales, through: :available_locales
  has_one :engagement_player
  belongs_to :locale
  accepts_nested_attributes_for :engagement_player, update_only: true

  # validations
  validates_associated :engagement_player
  validates :name, presence: true, unless: :setup?
  validates :locale, presence: true, unless: :setup?
  validates :cname, presence: true, uniqueness: true, unless: :setup?

  # callbacks
  before_create do
    self.status ||= :setup
  end

  # definitions
  enum status: [:setup,
                :closed,
                :opened,
                :basic,
                :engagement_player,
                :engagement_player_survey]
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
