class Campaign < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :permissions, as: :resource, dependent: :destroy
  has_many :users, through: :permissions

  has_one :engagement_player
  has_one :god_chat
  has_one :growth_space

  accepts_nested_attributes_for :engagement_player, update_only: true
  validates_associated :engagement_player

  belongs_to :user

  validates :name, presence: true, unless: :setup?
  validates :permalink, presence: true, uniqueness: true

  before_validation :generate_uid

  before_create do
    self.status = :setup
  end

  enum status: [:setup,
                :closed,
                :opened,
                :basic,
                :engagement_player,
                :engagement_player_survey]

  def display_name
    "#{name} (#{permalink.blank?})"
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
      preemptive_chat: preemptive_chat,
      growth_challenge: growth_challenge
    }
  end

  protected

  def generate_uid
    loop do
      self.uid = SecureRandom.hex(3)
      break unless Campaign.exists?(uid: uid)
    end
    return unless permalink.blank?
    self.permalink = uid
  end
end
