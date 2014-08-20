class Survey < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  belongs_to :engagement_player
  validates_presence_of :engagement_player
end
