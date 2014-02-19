class FollowupButton < ActiveRecord::Base
  belongs_to :campaign

  def as_json(options = {})
    {
      :text => btn_text,
      :action => btn_action,
      :value => btn_value,
      :message_active_chat => message_active_chat,
      :message_no_chat => message_no_chat
    }
  end
end
