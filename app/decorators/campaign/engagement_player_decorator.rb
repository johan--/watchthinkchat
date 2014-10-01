class Campaign
  class EngagementPlayerDecorator < Draper::Decorator
    decorates_association :survey
    decorates_association :questions
    decorates_association :options
    delegate_all

    def youtube_video_id
      if media_link[/youtu\.be\/([^\?]*)/]
        return Regexp.last_match[1]
      elsif media_link[/^.*((v%r)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
        return Regexp.last_match[5]
      end
    end
  end
end
