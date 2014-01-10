class Campaign < ActiveRecord::Base
  validates :name, :missionhub_secret, presence: true
	before_create :generate_uid

  def as_json(options = {})
    #super({ :only => [ :title, :type, :permalink ] }.merge(options))
    { :title => self.name, :type => "", :permalink => self.permalink }
  end

	private

	def generate_uid
		begin
			self.uid = SecureRandom.hex(3)
		end while Campaign.exists?(uid: uid)
	end
end
