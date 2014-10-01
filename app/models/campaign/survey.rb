class Campaign
  class Survey < ActiveRecord::Base
    has_many :questions, dependent: :destroy
    belongs_to :campaign
    validates :campaign, presence: true
    validates :enabled, inclusion: [true, false]
  end
end
