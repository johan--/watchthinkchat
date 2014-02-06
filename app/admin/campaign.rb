ActiveAdmin.register Campaign do
  index do
    column :name
    column :created_at
    column :permalink
    column :campaign_type
    column :status
    default_actions
  end

  filter :name
  filter :permalink
  filter :status, :as => :select, :collection => [ "opened", "closed" ]

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :password
      f.input :cname
      f.input :missionhub_secret
      f.input :permalink
      f.input :campaign_type
      f.input :max_chats
      f.input :admin1, :as => :select, :collection => User.has_operator_uid
      f.input :admin2, :as => :select, :collection => User.has_operator_uid
      f.input :admin3, :as => :select, :collection => User.has_operator_uid
      f.input :description, :as => :text
      f.input :language
      f.input :status, :as => :select, :collection => [ "opened", "closed" ]
    end
    f.actions
  end

  permit_params :name, :cname, :missionhub_secret, :permalink, :campaign_type, :max_chats, :user_id, :admin1_id, :admin2_id, :admin3_id, :description, :language, :status, :password, :password_hash

  before_create do |campaign|
    campaign.user_id = current_user.id
  end
end
