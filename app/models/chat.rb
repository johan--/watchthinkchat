class Chat < ActiveRecord::Base
  belongs_to :operator, :class_name => "User"
  belongs_to :visitor, :class_name => "User"
  belongs_to :campaign
  has_many :messages

  before_validation :set_uid

  validates :uid, :visitor_id, presence: true

  scope :open, lambda { where(:status => "open") }

  def set_uid
    return uid if uid

    loop do
      self.uid = SecureRandom.hex(10)
      break uid unless Chat.find_by(uid: uid)
    end
  end
end
