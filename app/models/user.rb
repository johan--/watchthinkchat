class User < ActiveRecord::Base
  VISITOR_PERMISSION = 2
  LEADER_PERMISSION  = 4

  before_create :generate_visitor_uid

  devise :registerable, :trackable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :operator_chats, :foreign_key => :operator_id, :class_name => "Chat"
  has_many :visitor_chats, :foreign_key => :visitor_id, :class_name => "Chat"
  has_many :user_operators
  has_many :operating_campaigns, :through => :user_operators, :class_name => "Campaign", :source => :campaign
  belongs_to :assigned_operator1, :class_name => "User"
  belongs_to :assigned_operator2, :class_name => "User"

  scope :online, Proc.new { where(:status => "online") }
  scope :has_operator_uid, Proc.new { where("operator_uid is not null") }
  scope :operators, Proc.new { where(operator: true) }

  def stats_row(campaign)
    #binding.remote_pry
    {
      "operator_id" => operator_uid,
      "fullname" => fullname,
      "email" => email,
      "missionhub_id" => missionhub_id,
      "status" => status,
      "live_chats" => operator_chats.where(campaign: campaign, status: "open").collect(&:uid),
      "alltime_chats" => count_operator_chats_for(campaign),  
      "available_for_chat" => (campaign.max_chats ? count_operator_open_chats_for(campaign) < campaign.max_chats : true),
      "last_sign_in_at" => last_sign_in_at,
      "profile_pic" => profile_pic
    } 
  end

  def admin_campaigns
    if is_superadmin?
      Campaign.all
    else
      Campaign.where("admin1_id = ? OR admin2_id = ? OR admin3_id = ?", id, id, id)
    end
  end

  def is_superadmin?
    self.admin ||
      %w(aandrewroth@gmail.com).include?(email) ||
      %w(100000523830165 682423688 122607328 1615307648 835310561).include?(fb_uid)
  end

  def as_json(options = {})
    if options[:as] == :operator
      { uid: self.operator_uid, name: self.fullname, profile_pic: self.profile_pic }
    else
      { :name => self.fullname, :uid => self.visitor_uid }
    end
  end

  def missionhub_url
    "https://www.missionhub.com/people/#{self.missionhub_id}"
  end

  def count_operator_chats_for(campaign)
    @count_operator_chats_for ||= operator_chats.where(:campaign => campaign).count
  end

  def count_operator_open_chats_for(campaign)
    @count_operator_open_chats_for ||= operator_chats.where(:campaign => campaign, :status => "open").count
  end

  def fullname
    "#{self.first_name} #{self.last_name}".strip
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :fb_uid => auth.uid).first
    user ||= User.where(:email => auth.info.email).first
    unless user
      user = User.create(first_name: auth.extra.raw_info.first_name,
                          last_name: auth.extra.raw_info.last_name,
                          provider: auth.provider,
                          fb_uid: auth.uid,
                          email: auth.info.email
                        )
    end
    user.update_attributes(fb_uid: auth.uid, operator_uid: auth.uid)
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def online?
    self.status == "online"
  end

  def set_status(status)
    self.status = status
    self.save
  end

  def generate_visitor_uid
    begin
      self.visitor_uid = SecureRandom.hex(3)
    end while User.exists?(visitor_uid: visitor_uid)
  end

  def extra_omniauth_info(omniauth_info)
    self.update_attributes(
      :profile_pic => omniauth_info["image"],
      :email => omniauth_info["email"],
      :first_name => omniauth_info["first_name"],
      :last_name => omniauth_info["last_name"]
    )
  end

  def operating?(campaign)
    self.operator && self.operating_campaigns.include?(campaign)
  end

  def mark_as_operator!(campaign)
    #puts "in mark_as_operator!"
    self.operator = true
    self.operating_campaigns << campaign unless self.operating_campaigns.include?(campaign)
    self.operator_uid = self.fb_uid
    self.save!
    self.sync_mh
    user_operator = self.user_operators.where(:campaign => campaign).first
    user_operator.save! # this will ensure the short_url is set
    return user_operator.url_fwd.short_url
  end

  def campaign
    return @campaign if @campaign
    # try to guess which campaign this person is with, based on the latest chats or operator statuses
    guessables = operator_chats + visitor_chats + user_operators
    guessables.sort!{ |a,b| a.created_at <=> b.created_at }
    @campaign = guessables.last.try(:campaign)
  end

  def sync_mh(params = {})
    return unless campaign
    p = Rest.post("https://www.missionhub.com/apis/v3/people?secret=#{campaign.missionhub_token}&permissions=#{operator ? User::LEADER_PERMISSION : User::VISITOR_PERMISSION}#{"&person[fb_uid]=#{fb_uid}" if fb_uid.present?}#{"&person[first_name]=#{esc(first_name)}" if first_name.present?}#{"&person[last_name]=#{esc(last_name)}" if last_name.present?}#{"&person[email]=#{email}" if email.present?}")["person"]
    self.update_attribute :missionhub_id, p["id"]
    # add labels
    add_label("Leader") if self.operator
    add_label("Challenge Subscribe Self") if self.challenge_subscribe_self
    add_label("Challenge Subscribe Friend") if self.challenge_subscribe_friend
    # add assignments if necessary
    add_assignment(assigned_operator1) if assigned_operator1
    add_assignment(assigned_operator2) if assigned_operator2 && assigned_operator1 != assigned_operator2
  end

  def existing_mh_label_ids
    return [] unless campaign
    Rest.get("https://www.missionhub.com/apis/v3/people/#{missionhub_id}?secret=#{campaign.missionhub_token}&include=organizational_labels")["person"]["organizational_labels"].collect{ |l| l["label_id"] }
  end

  def add_label(name)
    label_mh = Rest.get("https://www.missionhub.com/apis/v3/labels?secret=#{campaign.missionhub_token}")["labels"].detect{ |l| l["name"] == name }
    label_id = (label_mh && label_mh["id"]) || Rest.post("https://www.missionhub.com/apis/v3/labels?secret=#{campaign.missionhub_token}&label[name]=#{name}")["label"]["id"]
    unless existing_mh_label_ids.include?(label_id)
      Rest.post("https://www.missionhub.com/apis/v3/organizational_labels?secret=#{campaign.missionhub_token}&organizational_label[person_id]=#{self.missionhub_id}&organizational_label[label_id]=#{label_id}")
    end
  end

  def remove_label(name)
    # TODO
  end

  def add_assignment(user)
    Rest.post("https://www.missionhub.com/apis/v3/contact_assignments?secret=#{campaign.missionhub_token}&contact_assignment[person_id]=#{self.missionhub_id}&contact_assignment[assigned_to_id]=#{user.missionhub_id}")
  end

  def esc(s)
    ERB::Util.url_encode(s)
  end
end
