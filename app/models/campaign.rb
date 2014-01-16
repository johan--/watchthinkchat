class Campaign < ActiveRecord::Base
  validates :name, :missionhub_secret, presence: true
  before_create :generate_uid

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { :title => self.name, :type => self.campaign_type, :permalink => self.permalink, :video_id => self.video_id, :uid => self.uid }
  end

  protected

  def generate_uid
    begin
      self.uid = SecureRandom.hex(3)
    end while User.exists?(uid: uid)
  end

end
