class Campaign::EngagementPlayer::Survey < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  belongs_to :engagement_player
  validates :engagement_player, presence: true

  delegate :campaign, to: :engagement_player
end
