class FollowupButton < ActiveRecord::Base
  belongs_to :campaign

  def as_json(options = {})
    {
      :text => btn_text,
      :id => btn_id,
      :message_active_chat => message_active_chat,
      :message_no_chat => message_no_chat
    }
  end
end
