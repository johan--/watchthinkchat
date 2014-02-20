class Chat < ActiveRecord::Base
  belongs_to :operator, :class_name => "User"
  belongs_to :visitor, :class_name => "User"
  belongs_to :campaign
  has_many :messages

  before_validation :set_uid

  validates :uid, :visitor_id, presence: true

  scope :open, lambda { where(:status => "open") }

  def set_uid
    return uid if uid

    loop do
      self.uid = SecureRandom.hex(10)
      break uid unless Chat.find_by(uid: uid)
    end
  end

  def close!
    Pusher["chat_#{self.uid}"].trigger('end', { })
    self.update_attribute(:status, "closed")
  end

  def collect_stats(params)
    name_words = params[:visitor_name].split(' ')
    #people = MissionHub::Person.find(:all, :params => { :filters => { :email_exact => params[:visitor_email] }})
    people = Rest.get("https://www.missionhub.com/apis/v3/people?secret=#{campaign.missionhub_token}&filters[email_exact]=#{params[:visitor_email]}")["people"]
    #puts "people.length: #{people.length}"
    if people.length == 0
      #visitor = MissionHub::Person.create(:permission => User::VISITOR_PERMISSION, :person => { first_name: name_words.shift, last_name: name_words.join(' '), email: params[:visitor_email] })
      visitor = Rest.post("https://www.missionhub.com/apis/v3/people?secret=#{campaign.missionhub_token}&permissions=#{User::VISITOR_PERMISSION}&person[first_name]=#{name_words.shift}&person[last_name]=#{name_words.join(' ')}&person[email]=#{params[:visitor_email]}")["person"]
    else
      visitor = people.first
    end
    #MissionHub::FollowupComment.create(a: "b", followup_comment: { contact_id: visitor.id, commenter_id: self.operator.missionhub_id, comment: params[:notes] })
    Rest.post("https://www.missionhub.com/apis/v3/followup_comments?secret=#{campaign.missionhub_token}&followup_comment[contact_id]=#{visitor["id"]}&followup_comment[commenter_id]=#{self.operator.missionhub_id}&followup_comment[comment]=#{params[:notes]}")
  end
end
