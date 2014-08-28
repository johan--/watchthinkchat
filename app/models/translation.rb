class Translation < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :campaign
  belongs_to :locale
  validates :resource, presence: true
  validates :locale, presence: true, unless: :base?
  after_create :add_campaign

  protected

  def add_campaign
    update_attributes(campaign: resource.campaign)
  end
end
