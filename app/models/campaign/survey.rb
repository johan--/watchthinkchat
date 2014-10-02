class Campaign
  class Survey < Component
    has_many :questions, dependent: :destroy
  end
end
