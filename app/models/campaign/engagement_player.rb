class Campaign::EngagementPlayer < ActiveRecord::Base
  extend Translatable
  # associations
  belongs_to :campaign
  has_one :survey,
          dependent: :destroy
  has_many :followup_buttons
  has_many :translations, as: :resource, dependent: :destroy
  accepts_nested_attributes_for :followup_buttons, allow_destroy: true

  # callbacks
  after_save :generate_survey, on: :create
  before_destroy :destroy_associations

  # validations
  validates :media_link, presence: true
  validates :campaign, presence: true
  validates :survey,
            presence: true,
            on: :update,
            unless: proc { created_at.nil? }

  # definitions
  translatable :media_link

  def youtube_video_id
    if media_link[/youtu\.be\/([^\?]*)/]
      return Regexp.last_match[1]
    elsif media_link[/^.*((v%r)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      return Regexp.last_match[5]
    end
  end

  protected

  def generate_survey
    self.survey ||= create_survey
  end

  def destroy_associations
    Translation.where(resource_id: id).destroy_all
  end
end
