class EngagementPlayer < ActiveRecord::Base
  belongs_to :campaign

  validates_presence_of :media_link
end
