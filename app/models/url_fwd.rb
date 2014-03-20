class UrlFwd < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  before_create :generate_visitor_uid
  before_create :set_short_url

  protected

  def generate_visitor_uid
    generate_one_visitor_uid
    while UrlFwd.where(:uid => self.uid).count > 0
      generate_one_visitor_uid
    end
  end

  def generate_one_visitor_uid
    # 0-9 stay
    # 10-35 a-z
    # 36-61 A-Z
    r = ""
    (1..4).each do |digit|
      i = SecureRandom.random_number(62)
      if i >= 0 && i <= 9
        v = i.to_s
      elsif i >= 10 && i <= 35
        v = ('a'.ord + (i - 10)).chr
      elsif i >= 36 && i <= 61
        v = ('A'.ord + (i - 36)).chr
      end
      r += v
    end
    self.uid = r
  end

  def set_short_url
    # https://github.com/rails/rails/issues/12178 causing missing required keys: [:uid]
    #url_fwd_path(:uid => self.uid)
    #self.short_url = "http://#{ENV['visitor_app_url']}/s/#{self.uid}"
    self.short_url = "/s/#{self.uid}"
  end
end
