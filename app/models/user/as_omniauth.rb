class User::AsOmniauth < ActiveType::Record[User]
  def self.find_omniauth_user(auth, url)
    user = where(provider: auth.provider, fb_uid: auth.uid).first
    user ||= where(email: auth.info.email).first
    unless user
      user = new(first_name: auth.extra.raw_info.first_name,
                 last_name: auth.extra.raw_info.last_name,
                 provider: auth.provider,
                 fb_uid: auth.uid,
                 email: auth.info.email
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
      operator_uid: auth.uid,
      profile_pic: auth['info']['image'],
      email: auth['info']['email'],
      first_name: auth['info']['first_name'],
      last_name: auth['info']['last_name']
    )
  end
end
