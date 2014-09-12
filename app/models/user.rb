class User < ActiveRecord::Base
  include RoleModel

  devise :invitable, :registerable,
         :trackable,
         :database_authenticatable,
         :rememberable,
         :recoverable
  devise :omniauthable, omniauth_providers: [:facebook]

  validates :first_name, presence: true
  validates :email, uniqueness: true, email: true

  roles_attribute :roles_mask
  roles :nobody, :manager, :translator, :operator, :visitor

  has_many :permissions, dependent: :destroy

  def name
    "#{first_name} #{last_name}".strip
  end

  alias_method :fullname, :name

  def self.find_for_facebook_oauth(auth, _signed_in_resource = nil)
    user = User.where(provider: auth.provider, fb_uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first
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
      data = session['devise.facebook_data']
      if data && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def extra_omniauth_info(omniauth_info)
    update_attributes(
      profile_pic: omniauth_info['image'],
      email: omniauth_info['email'],
      first_name: omniauth_info['first_name'],
      last_name: omniauth_info['last_name']
    )
  end

  def esc(s)
    ERB::Util.url_encode(s)
  end

  def as(role)
    return becomes "User::#{role.to_s.camelize}".constantize if self.is? role
    raise ActiveRecordError
  end
end
