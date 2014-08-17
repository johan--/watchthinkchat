class EngagementPlayer < ActiveRecord::Base
  belongs_to :campaign
  has_many :followup_buttons
  accepts_nested_attributes_for :followup_buttons, allow_destroy: true
  validates_presence_of :media_link, :campaign
end
