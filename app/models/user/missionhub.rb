class User::Missionhub < User::DashboardUser
  def missionhub_url
    "https://www.missionhub.com/people/#{missionhub_id}"
  end

  def sync_mh(_params = {})
    return unless campaign
    p = Rest.post('https://www.missionhub.com/apis/v3/people'\
      "?secret=#{campaign.missionhub_token}&permissions="\
      "#{operator ? User::LEADER_PERMISSION : User::VISITOR_PERMISSION}"\
      "#{"&person[fb_uid]=#{fb_uid}" if fb_uid.present?}"\
      "#{"&person[first_name]=#{esc(first_name)}" if first_name.present?}"\
      "#{"&person[last_name]=#{esc(last_name)}" if last_name.present?}"\
      "#{"&person[email]=#{email}" if email.present?}")['person']
    update_attribute :missionhub_id, p['id']
    # add labels
    add_label('Leader') if operator
    add_label('Challenge Subscribe Self') if challenge_subscribe_self
    add_label('Challenge Subscribe Friend') if challenge_subscribe_friend
    # add assignments if necessary
    add_assignment(assigned_operator1) if assigned_operator1
    return unless assigned_operator2 && assigned_operator1 != assigned_operator2
    add_assignment(assigned_operator2)
  end

  def existing_mh_label_ids
    return [] unless campaign
    Rest.get("https://www.missionhub.com/apis/v3/people/#{missionhub_id}"\
      "?secret=#{campaign.missionhub_token}"\
      '&include=organizational_labels')\
      ['person']['organizational_labels'].map { |l| l['label_id'] }
  end

  def add_label(name)
    label_mh = Rest.get('https://www.missionhub.com/apis/v3/labels'\
      "?secret=#{campaign.missionhub_token}")\
      ['labels'].detect { |l| l['name'] == name }
    label_id =
      (label_mh && label_mh['id']) ||
      Rest.post('https://www.missionhub.com/apis/v3/labels'\
        "?secret=#{campaign.missionhub_token}"\
        "&label[name]=#{name}")['label']['id']
    return if existing_mh_label_ids.include?(label_id)
    Rest.post('https://www.missionhub.com/apis/v3/organizational_labels'\
      "?secret=#{campaign.missionhub_token}"\
      "&organizational_label[person_id]=#{missionhub_id}"\
      "&organizational_label[label_id]=#{label_id}")
  end

  def remove_label(_name)
    # TODO
  end

  def add_assignment(user)
    Rest.post('https://www.missionhub.com/apis/v3/contact_assignments'\
      "?secret=#{campaign.missionhub_token}"\
      "&contact_assignment[person_id]=#{missionhub_id}"\
      "&contact_assignment[assigned_to_id]=#{user.missionhub_id}")
  end
end
