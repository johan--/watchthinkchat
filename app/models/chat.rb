class Chat < ActiveRecord::Base
  belongs_to :operator, :class_name => "User"
  belongs_to :visitor, :class_name => "User"
  belongs_to :campaign
  belongs_to :operator_whose_link, :class_name => "User"
  has_many :messages, lambda { order("created_at asc") }

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
    params.delete(:visitor_email) unless params[:visitor_email].present?
    visitor.update_attributes :first_name => name_words.shift, :last_name => name_words.join(" "), :email => params[:visitor_email], :assigned_operator1_id => operator_id, :assigned_operator2_id => operator_whose_link_id
    visitor.sync_mh
    r = Rest.post("https://www.missionhub.com/apis/v3/followup_comments?secret=#{campaign.missionhub_token}&followup_comment[contact_id]=#{visitor.missionhub_id}&followup_comment[commenter_id]=#{self.operator.missionhub_id}&followup_comment[comment]=#{build_comment(params)}")
    self.update_attribute(:mh_comment, build_comment(params.merge(:dont_escape => true)))
    return true
  end

  def transcript
    messages.collect(&:transcript_line).join("\n")
  end

  def build_comment(params)
    lines = []
    lines << "Chat initiated through a link to #{operator_whose_link.fullname} (#{operator_whose_link.missionhub_url})"
    lines << ""
    lines << "They chatted with #{visitor.fullname} (#{visitor.missionhub_url})"
    lines << ""
    lines << "Their response: #{params[:visitor_response]}"
    lines << ""
    lines << "Call to action: #{params[:calltoaction]}"
    lines << ""
    
    if params[:notes].present?
      lines << "Operator recorded these notes: #{params[:notes]}"
      lines << ""
    end

    lines << "Chat transcript:"
    lines << ""
    lines << transcript

    if params[:dont_escape]
      return lines.join("\n")
    else
      return ERB::Util.url_encode(lines.join("\n"))
    end
  end
end
