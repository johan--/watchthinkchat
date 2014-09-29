class User
  class Omniauth < ActiveType::Record[User]
    before_validation :generate_password, on: :create

    def self.find(auth, url)
      user = where(provider: auth.provider, fb_uid: auth.uid).first
      user ||= where(email: auth.info.email).first
      unless user
        user = new
        user.roles << :manager if url == "app.#{ENV['base_url']}"
      end
      update_omniauth_attributes(user, auth)
      user
    end

    protected

    def self.update_omniauth_attributes(user, auth)
      user.update(
        fb_uid: auth.uid,
        profile_pic: auth['info']['image'],
        email: auth['info']['email'],
        first_name: auth['info']['first_name'],
        last_name: auth['info']['last_name'],
        provider: auth['provider']
      )
    end

    def generate_password
      self.password = SecureRandom.hex(5)
    end
  end
end
