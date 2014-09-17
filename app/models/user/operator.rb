class User::Operator < User::DashboardUser
  has_many :operator_chats, foreign_key: :operator_id, class_name: 'Chat'
  has_many :visitor_chats, foreign_key: :visitor_id, class_name: 'Chat'
  has_many :user_operators
  has_many :operating_campaigns,
           through: :user_operators,
           class_name: 'Campaign',
           source: :campaign

  scope :online, proc { where(status: 'online') }
  scope :has_operator_uid, proc { where('operator_uid is not null') }
  scope :operators, proc { where(operator: true) }

  def as_json(options = {})
    if options[:as] == :operator
      { uid: operator_uid,
        name: fullname,
        profile_pic: profile_pic }
    else
      { name: fullname,
        uid: visitor_uid }
    end
  end

  def count_operator_chats_for(campaign)
    @count_operator_chats_for ||=
      operator_chats.where(campaign: campaign).count
  end

  def count_operator_open_chats_for(campaign)
    @count_operator_open_chats_for ||=
      operator_chats.where(campaign: campaign, status: 'open').count
  end

  def online?
    status == 'online'
  end

  def mark_as_operator!(campaign)
    # puts 'in mark_as_operator!'
    self.operator = true
    unless operating_campaigns.include?(campaign)
      operating_campaigns << campaign
    end
    self.operator_uid = fb_uid
    save!
    sync_mh
    user_operator = user_operators.where(campaign: campaign).first
    user_operator.save!
    # this will ensure the short_url is set
    user_operator.url_fwd.short_url
  end

  def operating?(campaign)
    operator && operating_campaigns.include?(campaign)
  end

  def stats_row(campaign)
    # binding.remote_pry
    {
      'operator_id' => operator_uid,
      'fullname' => fullname,
      'email' => email,
      'missionhub_id' => missionhub_id,
      'status' => status,
      'live_chats' => operator_chats.where(campaign: campaign,
                                           status: 'open').map(&:uid),
      'alltime_chats' => count_operator_chats_for(campaign),
      'available_for_chat' => (
        if campaign.max_chats
          count_operator_open_chats_for(campaign) < campaign.max_chats
        else
          true
        end),
      'last_sign_in_at' => last_sign_in_at,
      'profile_pic' => profile_pic
    }
  end

  def campaign
    return @campaign if @campaign
    # try to guess which campaign this person is with
    # based on the latest chats or operator statuses
    guessables = operator_chats + visitor_chats + user_operators
    guessables.sort! { |a, b| a.created_at <=> b.created_at }
    @campaign = guessables.last.try(:campaign)
  end
end
