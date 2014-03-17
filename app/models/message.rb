class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  #attr_accessible :body

  def as_json(options = {})
    { time: created_at, name: name, user_id: user_id, message: body, message_type: message_type }
  end

  def transcript_line
    "[#{created_at}] #{user.fullname}: #{body}"
  end
end
