class Campaign
  class Community < Component
    # associations
    belongs_to :child_campaign, class_name: '::Campaign'

    # validations
    validates :other_campaign,
              inclusion: [true, false],
              if: -> { enabled? }
    validates :child_campaign,
              presence: true,
              if: -> { enabled? && other_campaign? }
    validates :title,
              presence: true,
              if: -> { enabled? && !other_campaign? }
    validates :description,
              presence: true,
              if: -> { enabled? && !other_campaign? }
    validates :url,
              presence: true,
              if: -> { enabled? && !other_campaign? }
    validates :url,
              length: { maximum: 255 },
              if: -> { enabled? && !other_campaign? }
    validates :url, format: URI.regexp(%w(http https)), allow_blank: true

    # definitions
    translatable :url, :description, :title
  end
end
