class PusherController < ApplicationController
  protect_from_forgery except: :presence
  # stop rails CSRF protection for this action
  def presence
    webhook = Pusher.webhook(request)
    logger.info "PusherController#presence #{webhook.inspect}"
    if webhook.valid?
      webhook.events.each do |event|
        case event['channel']
        when 'presence-call-center'
          case event[:name]
          when 'member_added'
            User.find(event[:user_id]).status(User::STATE[:online])
          when 'member_removed'
            User.find(event[:user_id]).status(User::STATE[:offline])
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
    logger.info 'PusherController#existence'
    if webhook.valid?
      logger.info 'valid'
      webhook.events.each do |event|
        logger.info "event channel: #{event.inspect}"
        case event['channel']
        when /chat_(.+)/
          chat = Chat.where(uid: Regexp.last_match[1]).first
          break unless chat
          case event['name']
          when 'channel_occupied'
            chat.update_attribute(:status, 'open')
          when 'channel_vacated'
            chat.update_attribute(:status, 'closed')
          end
        when /operator_(.+)/
          operator = User.where(operator_uid: Regexp.last_match[1]).first
          break unless operator
          case event['name']
          when 'channel_occupied'
            operator.status('online')
            logger.info('in existence channel_vacated; opened chats:'\
                        " #{operator.operator_chats.open.inspect}")
            # send any live chats again
            operator.operator_chats.open.each do |operator_chat|
              Pusher["operator_#{operator.operator_uid}"]
                .trigger('newchat',
                         chat_uid: operator_chat.uid,
                         visitor_uid: operator_chat.visitor.visitor_uid,
                         visitor_name: operator_chat.visitor.fullname,
                         visitor_profile: '',
                         requested_operator: operator_chat
                           .operator_whose_link.try(:uid)
                )
            end
          when 'channel_vacated'
            operator.status('offline')
          end
        when /visitor_(.+)/
          visitor = User.where(visitor_uid: Regexp.last_match[1]).first
          logger.info("in existence visitor #{visitor.inspect}")
          break unless visitor
          case event['name']
          when 'channel_occupied'
          when 'channel_vacated'
            logger.info('in existence channel_vacated '\
                        "#{visitor.visitor_chats.open.inspect}")
            # notify all their chats that the visitor has left
            visitor.visitor_chats.open.each do |visitor_chat|
              logger.info("Sending end trigger on chat_#{visitor_chat.uid}")
              visitor_chat.close!
            end
          end
        end
      end
    end
    render text: 'ok'
  end
end
