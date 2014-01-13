class Campaign < ActiveRecord::Base
  validates :name, :missionhub_secret, presence: true

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { :title => self.name, :type => self.campaign_type, :permalink => self.permalink, :video_id => self.video_id }
  end

end
