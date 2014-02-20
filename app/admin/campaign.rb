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

  show do
    panel "Campaign" do
      attributes_table_for campaign do
        [ :name, :uid, :permalink, :max_chats, :status ].each do |column|
          row column
        end
      end
    end
    panel "Buttons" do
      table_for campaign.followup_buttons do
        column :btn_text
        column :btn_action
        column :btn_value
      end
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :password
      f.input :cname
      f.input :missionhub_token
      f.input :permalink
      f.input :campaign_type
      f.input :max_chats
      f.input :description, :as => :text
      f.input :language
      f.input :status, :as => :select, :collection => [ "opened", "closed" ]
    end
    f.inputs "Admins" do
      f.input :admin1, :as => :select, :collection => User.has_operator_uid
      f.input :admin2, :as => :select, :collection => User.has_operator_uid
      f.input :admin3, :as => :select, :collection => User.has_operator_uid
    end
    f.inputs do
      f.has_many :followup_buttons, :allow_destroy => true, :allow_create => true do |fb|
        fb.input :btn_text
        fb.input :btn_action, :as => :select, :collection => options_for_select([ "chat", "url" ], "chat"), :include_blank => false
        fb.input :btn_value
        fb.input :message_active_chat
        fb.input :message_no_chat
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

  before_create do |campaign|
    campaign.user_id = current_user.id
  end
end
