class User::AsOmniauth < ActiveType::Record[User]
  before_validation :generate_password, on: :create

  def self.find_omniauth_user(auth, url)
    user = where(provider: auth.provider, fb_uid: auth.uid).first
    user ||= where(email: auth.info.email).first
    unless user
      user = new(first_name: auth.info.first_name,
                 last_name: auth.info.last_name,
                 email: auth.info.email,
                 provider: auth.provider,
                 fb_uid: auth.uid
                )
      user.roles << :manager if url == ENV['dashboard_url']
      user.save!
    end
    update_omniauth_attributes(user, auth)
    user
  end

  def self.update_omniauth_attributes(user, auth)
    user.update(
      fb_uid: auth.uid,
      profile_pic: auth['info']['image'],
      email: auth['info']['email'],
      first_name: auth['info']['first_name'],
      last_name: auth['info']['last_name']
    )
  end

  protected

  def generate_password
    self.password = SecureRandom.hex(5)
  end
end
