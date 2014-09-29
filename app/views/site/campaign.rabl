attribute :name
child(:engagement_player, unless: lambda { |campaign| campaign.engagement_player.nil? }) {
  attributes :media_link, :media_start, :media_stop
  child(:questions, root: 'questions', object_root: false) {
    attributes :id, :title, :help_text
    child(:options, root: 'options', object_root: false) {
      attributes :id, :title, :code, :conditional
    }
  }
}
child(:community, unless: lambda { |campaign| campaign.community.nil? }) {
  attributes :enabled
  if @campaign.community.enabled?
    attributes :other_campaign
    if @campaign.community.other_campaign?
      attributes :permalink
    else
      attributes :title, :description, :url
    end
  end
}
