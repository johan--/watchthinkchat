class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  #attr_accessible :body

  def transcript_line
    "[#{created_at}] #{user.fullname}: #{body}"
  end
end
