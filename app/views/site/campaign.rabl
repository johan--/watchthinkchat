attribute :name
child(:engagement_player, unless: lambda { |campaign| campaign.engagement_player.nil? }) {
  if root_object.enabled?
    attributes :media_link, :media_start, :media_stop, :enabled
  end
}
child(:survey, unless: lambda { |campaign| campaign.survey.nil? }) {
  attributes :enabled
  if root_object.enabled?
    child(:questions, root: 'questions', object_root: false) {
      attributes :id, :title, :code, :help_text
      child(:options, root: 'options', object_root: false) {
        attributes :id, :title, :code, :conditional
      }
    }
  end
}
child(:guided_pair, unless: lambda { |campaign| campaign.guided_pair.nil? }) {
  attributes :enabled
  if root_object.enabled?
    attributes :title, :description
  end
}
child(:community, unless: lambda { |campaign| campaign.community.nil? }) {
  attributes :enabled
  if root_object.enabled?
    attributes :other_campaign, :permalink
    unless root_object.other_campaign?
      attributes :title, :description
    end
  end
}