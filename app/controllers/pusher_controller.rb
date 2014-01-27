class PusherController < ApplicationController
  protect_from_forgery :except => :presence # stop rails CSRF protection for this action
  def presence
    webhook = Pusher.webhook(request)
    logger.info "PusherController#presence #{webhook.inspect}"
    if webhook.valid?
      webhook.events.each do |event|
        case event["channel"]
        when "presence-call-center"
          case event[:name]
          when "member_added"
            User.find(event[:user_id]).set_status(User::STATE[:online])
          when "member_removed"
            User.find(event[:user_id]).set_status(User::STATE[:offline])
          end
        end
      end
      render text: 'ok'
    else
      render text: 'invalid', status: 401
    end
  end

  def existence
    webhook = Pusher.webhook(request)
    logger.info "PusherController#existence #{webhook.inspect}"
    if webhook.valid?
      logger.info "valid"
      webhook.events.each do |event|
        logger.info "event channel: #{event.inspect}"
        case event["channel"]
        when /chat_(.+)/
          chat = Chat.where(:uid => $1).first
          if chat
            case event["name"]
            when "channel_occupied"
              chat.update_attribute(:status, "open")
            when "channel_vacated"
              chat.update_attribute(:status, "closed")
            end
          end
        when /operator_(.+)/
          operator = User.where(:operator_uid => $1).first
          if operator
            case event["name"]
            when "channel_occupied"
              operator.set_status("online")
            when "channel_vacated"
              operator.set_status("offline")
            end
          end
        when /visitor_(.+)/
          visitor = User.where(:visitor_uid => $1).first
          logger.info("in existence visitor #{visitor.inspect}")
          if visitor
            case event["name"]
            when "channel_occupied"
            when "channel_vacated"
              logger.info("in existence channel_vacated #{visitor.chats.open.inspect}")
              # notify all their chats that the visitor has left
              visitor.chats.open.each do |chat|
                Pusher["chat_#{chat.uid}"].trigger('end', { })
              end
            end
          end
        end
      end
    end
    render text: 'ok'
  end
end
