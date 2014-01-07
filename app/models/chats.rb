class Chat < ActiveRecord::Base
  belongs_to :operator, :class_name => "User"
  belongs_to :visitor, :class_name => "User"
  belongs_to :campaign
  has_many :messages

  before_validation :set_channel

  validates :operator_id, :channel, :visitor_id, :topic, presence: true

  def set_channel
    return channel if channel

    loop do
      self.channel = SecureRandom.hex(10)
      break channel unless Conversation.find_by(channel: channel)
    end
  end
end
