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
child(:guided_pair, unless: lambda { |campaign| campaign.guided_pair.nil? }) {
child(:guided_pair) {
  attributes :enabled
  attributes :title, :description if root_object.enabled?
}
child(:community, unless: lambda { |campaign| campaign.community.nil? }) {
child(:community) {
  attributes :enabled
  if root_object.enabled?
    attributes :other_campaign, :permalink
    unless root_object.other_campaign?
      attributes :title, :description
    end
  end
}
