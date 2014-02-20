class Campaign < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :followup_buttons
  belongs_to :user
  belongs_to :admin1, :class_name => "User"
  belongs_to :admin2, :class_name => "User"
  belongs_to :admin3, :class_name => "User"

  validates :name, :missionhub_token, presence: true

  before_create :generate_uid
  before_create :set_status

  accepts_nested_attributes_for :followup_buttons, :allow_destroy => true

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { 
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
      :followup_buttons => followup_buttons
    }
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

  protected

  def generate_uid
    begin
      self.uid = SecureRandom.hex(3)
    end while Campaign.exists?(uid: uid)
  end

  def set_status
    status = "closed"
  end
end
