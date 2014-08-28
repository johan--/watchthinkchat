class Translation < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  belongs_to :campaign
  belongs_to :locale
  validates :resource, presence: true
  validates :campaign, presence: true
  validates :locale, presence: true
  validates :content, presence: true
end
