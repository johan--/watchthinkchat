class Campaign::GrowthSpace < ActiveRecord::Base
  validates :growth_challenge,
            allow_blank: true,
            format: { with: /operator|auto/ }
end
