class Campaign < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :followup_buttons
  has_many :user_operators
  has_many :operators, :through => :user_operators, :source => :user
  has_many :users
  belongs_to :user
  belongs_to :admin1, :class_name => "User"
  belongs_to :admin2, :class_name => "User"
  belongs_to :admin3, :class_name => "User"

  validates :name, presence: true
  validates :growth_challenge, allow_blank: true, format: { with: /operator|auto/ }
  validates :permalink, presence: true, uniqueness: true

  before_create :generate_uid
  before_create :set_status_closed

  accepts_nested_attributes_for :followup_buttons, :allow_destroy => true

  def display_name
    "#{name} (#{permalink})"
  end

  def opened?
    status == "opened"
  end

  def closed?
    status == "" || status == nil || status == "closed"
  end

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { 
      :chat_start => self.chat_start,
      :title => self.name, 
      :type => self.campaign_type, 
      :permalink => self.permalink, 
      :video_id => self.video_id, 
      :uid => self.uid,
      :max_chats => self.max_chats,
      :owner => self.owner,
      :description => self.description,
      :language => self.language,
      :status => self.status,
      :followup_buttons => followup_buttons,
      :preemptive_chat => preemptive_chat,
      :growth_challenge => growth_challenge
    }
  end

  def get_available_operator
    if self.max_chats
      operators = self.operators.online.find_all{ |o| 
        o.count_operator_open_chats_for(self) < self.max_chats
      }
    else
      operators = self.operators.online
    end
    operators.sort { |o1, o2|
      open1 = o1.count_operator_open_chats_for(self)
      open2 = o2.count_operator_open_chats_for(self)
      if open1 == open2
        o1.count_operator_chats_for(self) <=> o2.count_operator_chats_for(self)
      else
        open1 <=> open2
      end
    }.first
  end

  def password
    return nil unless password_hash
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    return unless new_password.present?
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def is_admin?(user)
    user.is_superadmin? || [ admin1, admin2, admin3 ].compact.include?(user)
  end

  protected

  def generate_uid
    begin
      self.uid = SecureRandom.hex(3)
    end while Campaign.exists?(uid: uid)
  end

  def set_status_closed
    status = "closed"
  end
end
