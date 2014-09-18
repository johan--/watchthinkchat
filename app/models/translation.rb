class Translation < ActiveRecord::Base
  # associations
  belongs_to :campaign
  belongs_to :resource, polymorphic: true
  belongs_to :locale

  # validations
  validates :resource, presence: true
  validates :locale, presence: true, unless: :base?

  # callbacks
  after_create :add_campaign

  # definitions
  scope :base, -> { where(base: true) }

  protected

  def add_campaign
    update(campaign: resource.campaign)
  end
end
