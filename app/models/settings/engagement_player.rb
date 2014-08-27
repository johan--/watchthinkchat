class EngagementPlayer < ActiveRecord::Base
  belongs_to :campaign
  has_one :survey, dependent: :destroy
  after_save :generate_survey, on: :create
  has_many :followup_buttons
  accepts_nested_attributes_for :followup_buttons, allow_destroy: true
  validates :media_link, presence: true
  validates :campaign, presence: true
  validates :survey, presence: true, on: :update, unless: proc { created_at.nil? }

  protected

  def generate_survey
    create_survey
  end
end
