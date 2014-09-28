class Campaign::EngagementPlayer::Question < ActiveRecord::Base
  extend Translatable
  # associations
  belongs_to :survey
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
  has_many :translations, as: :resource, dependent: :destroy

  # callbacks
  after_save :generate_code, on: :create
  before_destroy :destroy_translations

  # validations
  validates :survey, presence: true
  validates :title, presence: true
  validates :code, presence: true, on: :update

  # definitions
  acts_as_list scope: :survey
  default_scope { order('position ASC') }
  translatable :title, :help_text

  def options_attributes
    options
  end

  delegate :campaign, to: :survey

  def permalink
    "#{campaign.permalink}/#/q/#{code}"
  end

  protected

  def generate_code
    update_column(:code, Base62.encode(id))
  end

  def destroy_translations
    Translation.where(resource_id: id).destroy_all
  end
end
