class Campaign::AsCreate < Campaign

  after_create :create_missionhub_org

  private

  def create_missionhub_org
    r = Rest.post("https://www.missionhub.com/apis/v3/organizations.json?secret=#{ENV['missionhub_token']}&organization[name]=#{name}&organization[terminology]=Organization&organization[show_sub_orgs]=true&organization[status]=active&organization[parent_id]=#{ENV['missionhub_parent']}&include=token")
    # example return: {"organization":{"id":9747,"name":"New Org","terminology":"Organization","ancestry":"8349","show_sub_orgs":true,"status":"active","created_at":"2014-08-06T10:53:21-05:00","updated_at":"2014-08-06T10:53:21-05:00","token":"12345"}}
    update_column(:missionhub_token, r["organization"]["token"])
  end
end
