class FollowupButton < ActiveRecord::Base
  belongs_to :engagement_player

  validates :btn_text, presence: true

  before_save do |record|
    record.btn_id ||= record
      .campaign
      .followup_buttons
      .reload
      .map(&:btn_id)
      .max.to_i + 1
  end

  def as_json(_options = {})
    {
      text: btn_text,
      id: btn_id,
      message_active_chat: message_active_chat,
      message_no_chat: message_no_chat
    }
  end
end
