class EngagementPlayer < ActiveRecord::Base
  belongs_to :campaign
  has_one :survey, dependent: :destroy
  has_many :followup_buttons
  accepts_nested_attributes_for :followup_buttons, allow_destroy: true
  validates :media_link, presence: true
  validates :campaign, presence: true
end
