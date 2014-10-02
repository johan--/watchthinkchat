class Campaign
  class EngagementPlayer < Component
    # validations
    validates :media_link, presence: true

    # definitions
    translatable :media_link
  end
end
