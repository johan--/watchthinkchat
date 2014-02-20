class User < ActiveRecord::Base
  VISITOR_PERMISSION = 2
  LEADER_PERMISSION  = 4

  before_create :generate_visitor_uid

  devise :registerable, :trackable
  devise :omniauthable, :omniauth_providers => [:facebook]

  #has_and_belongs_to_many :languages
  has_many :operator_chats, :foreign_key => :operator_id, :class_name => "Chat"
  has_many :visitor_chats, :foreign_key => :visitor_id, :class_name => "Chat"
  has_many :user_operators
  has_many :operating_campaigns, :through => :user_operators, :class_name => "Campaign", :source => :campaign

  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true

  scope :online, Proc.new { where(:status => "online") }
  scope :has_operator_uid, Proc.new { where("operator_uid is not null") }

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

    # make sure this person is in missionhub and in leader role and label
    # it will search for him by email first and add the permission if it doesn't already exist
    p = Rest.post("https://www.missionhub.com/apis/v3/people?secret=#{campaign.missionhub_token}&permissions=#{User::LEADER_PERMISSION}&person[fb_uid]=#{self.fb_uid}&person[first_name]=#{self.first_name}&person[last_name]=#{self.last_name}&person[email]=#{self.email}")["person"]
    self.update_attribute :missionhub_id, p["id"]
    @@leader_label_id ||= Rest.get("https://www.missionhub.com/apis/v3/labels?secret=#{campaign.missionhub_token}")["labels"].detect{ |l| l["name"] == "Leader" }["id"]
    label = Rest.post("https://www.missionhub.com/apis/v3/organizational_labels?secret=#{campaign.missionhub_token}&organizational_label[person_id]=#{self.missionhub_id}&organizational_label[label_id]=#{@@leader_label_id}")
    #puts label.inspect
  end
end
