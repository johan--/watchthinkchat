class Campaign < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :followup_buttons
  has_many :user_operators
  has_many :operators, through: :user_operators, source: :user
  has_many :users

  has_one :engagement_player
  has_one :god_chat
  has_one :growth_space

  accepts_nested_attributes_for :engagement_player

  belongs_to :user
  belongs_to :admin1, class_name: 'User'
  belongs_to :admin2, class_name: 'User'
  belongs_to :admin3, class_name: 'User'

  validates :name, presence: true
  validates :growth_challenge,
            allow_blank: true,
            format: { with: /operator|auto/ }
  validates :name, presence: true, unless: :setup?
  validates :permalink, presence: true, uniqueness: true

  before_create :generate_uid
  before_create :set_status_closed

  accepts_nested_attributes_for :followup_buttons, allow_destroy: true

  def display_name
    "#{name} (#{permalink})"
  end

  def opened?
    status == 'opened'
  end

  def closed?
    status == '' || status == nil || status == 'closed'
  end

  def as_json(_options = {})
    # super({ only: [ :title, :type, :permalink ] }.merge(options))
    {
      chat_start: chat_start,
      title: name,
      type: campaign_type,
      permalink: permalink,
      video_id: video_id,
      uid: uid,
      max_chats: max_chats,
      owner: owner,
      description: description,
      language: language,
      status: status,
      followup_buttons: followup_buttons,
      preemptive_chat: preemptive_chat,
      growth_challenge: growth_challenge
    }
  end

  def get_available_operator
    if max_chats
      operators = operators.online.select do |o|
        o.count_operator_open_chats_for(self) < max_chats
      end
    else
      operators = self.operators.online
    end
    operators.sort do |o1, o2|
      open1 = o1.count_operator_open_chats_for(self)
      open2 = o2.count_operator_open_chats_for(self)
      if open1 == open2
        o1.count_operator_chats_for(self) <=> o2.count_operator_chats_for(self)
      else
        open1 <=> open2
      end
    end
    operators.first
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

  def admin?(user)
    user.superadmin? || [admin1, admin2, admin3].compact.include?(user)
  end

  protected

  def generate_uid
    begin
      self.uid = SecureRandom.hex(3)
    end while Campaign.exists?(uid: uid)
  end

  def set_status_closed
    self.status = 'closed' if status.blank?
  end
end
