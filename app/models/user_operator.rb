class UserOperator < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  belongs_to :url_fwd 

  before_save :create_url_fwd

  protected

  def create_url_fwd
    unless self.url_fwd
      self.url_fwd = UrlFwd.create! :full_url => "http://#{ENV['visitor_app_url']}/c/#{campaign.uid}?o=#{user.operator_uid}"
      self.url_fwd.save!
    end
  end
end
