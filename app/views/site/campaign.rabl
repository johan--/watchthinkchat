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
