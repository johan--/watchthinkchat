class Campaign < ActiveRecord::Base
  validates :name, :missionhub_secret, presence: true
	before_create :generate_uid

  def as_json
    super(:only => [:title, :type, :permalink])
  end

	private

	def generate_uid
		begin
			self.uid = SecureRandom.hex(3)
		end while Campaign.exists?(uid: uid)
	end
end
