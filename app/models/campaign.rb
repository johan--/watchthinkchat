class Campaign < ActiveRecord::Base
  validates :name, :missionhub_secret, presence: true

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { :title => self.name, :type => "", :permalink => self.permalink }
  end

end
