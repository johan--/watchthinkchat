attribute :id, :name
node(:resource_type) { Campaign }
child(:engagement_player, if: lambda { |campaign| campaign.engagement_player }) {
  attributes :id, :enabled
  node(:resource_type) { Campaign::EngagementPlayer }
  if root_object.enabled?
    attributes :media_link, :media_start, :media_stop, :enabled
  end
}
child(:survey, if: lambda { |campaign| campaign.survey }) {
  attributes :id, :enabled
  node(:resource_type) { Campaign::Survey }
  if root_object.enabled?
    child(:questions, root: 'questions', object_root: false) {
      attributes :id, :title, :code, :help_text
      node(:resource_type) { Campaign::Survey::Question }
      child(:options, root: 'options', object_root: false) {
        attributes :id, :title, :code, :conditional
        node(:resource_type) { Campaign::Survey::Question::Option }
      }
    }
  end
}
child(:guided_pair, if: lambda { |campaign| campaign.guided_pair }) {
  attributes :id, :enabled
  node(:resource_type) { Campaign::GuidedPair }
  if root_object.enabled?
    attributes :title, :description
  end
}
child(:community, if: lambda { |campaign| campaign.community }) {
  attributes :id, :enabled
  node(:resource_type) { Campaign::Community }
  if root_object.enabled?
    attributes :other_campaign, :permalink
    unless root_object.other_campaign?
      attributes :title, :description
    end
  end
}