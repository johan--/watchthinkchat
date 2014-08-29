class Campaign::AsCreate < Campaign
  after_create :create_missionhub_org

  private

  def create_missionhub_org
    r = Rest.post('https://www.missionhub.com/apis/v3/organizations.json'\
                  "?secret=#{ENV['missionhub_token']}"\
                  "&organization[name]=#{name}"\
                  '&organization[terminology]=Organization'\
                  '&organization[show_sub_orgs]=true'\
                  '&organization[status]=active'\
                  "&organization[parent_id]=#{ENV['missionhub_parent']}"\
                  '&include=token')
    update_column(:missionhub_token, r['organization']['token'])
  end
end
