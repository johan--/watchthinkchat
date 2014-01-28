class User < ActiveRecord::Base
  before_create :generate_visitor_uid

  devise :registerable, :trackable
  devise :omniauthable, :omniauth_providers => [:facebook]

  #has_and_belongs_to_many :languages
  has_many :operator_chats, :foreign_key => :operator_id, :class_name => "Chat"
  has_many :visitor_chats, :foreign_key => :visitor_id, :class_name => "Chat"

  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true

  scope :online, Proc.new { where(:status => "online") }

  def as_json(options = {})
    if options[:as] == :operator
      { uid: self.operator_uid, name: self.fullname, profile_pic: self.profile_pic }
    else
      { :name => self.fullname, :uid => self.visitor_uid }
    end
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
    first_name + " " + last_name
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
end
