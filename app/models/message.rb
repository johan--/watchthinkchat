class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  belongs_to :chat
  #attr_accessible :body
  after_create :update_chat_visitor_active
  after_create :update_user_messages_count

  def as_json(options = {})
    { time: created_at, name: name, user_id: user_id, message: body, message_type: message_type }
  end

  def transcript_line
    "[#{created_at}] #{user.fullname}: #{body}"
  end

  def update_chat_visitor_active
    chat.update_visitor_active!
  end

  def update_user_messages_count
    chat.update_user_messages_count!
  end
end
