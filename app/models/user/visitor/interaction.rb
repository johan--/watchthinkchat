class User
  class Visitor
    class Interaction < ActiveRecord::Base
      # associations
      belongs_to :campaign
      belongs_to :resource, polymorphic: true
      belongs_to :visitor

      # validations
      validates :campaign, presence: true
      validates :resource, presence: true
      validates :visitor, presence: true
      validates :action,
                presence: true,
                uniqueness: { scope: [:campaign_id, :resource_id, :visitor_id] }

      # definitions
      serialize :data, JSON
      enum action: [:start, :finish]
    end
  end
end
