class Campaign < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  validates :name, :missionhub_secret, presence: true
  before_create :generate_uid
  before_create :set_status
  belongs_to :user

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
      :status => self.status
    }
  end


  def password
    return nil unless password_hash
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
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
