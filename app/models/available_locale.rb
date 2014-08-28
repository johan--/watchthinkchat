class AvailableLocale < ActiveRecord::Base
  # associations
  belongs_to :campaign
  belongs_to :locale

  # validations
  validates :campaign, presence: true
  validates :locale, presence: true
end
