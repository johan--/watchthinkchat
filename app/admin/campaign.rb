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
      f.input :cname
      f.input :missionhub_secret
      f.input :permalink
      f.input :campaign_type
      f.input :max_chats
      f.input :user
      f.input :description, :as => :text
      f.input :language
      f.input :status, :as => :select, :collection => [ "opened", "closed" ]
    end
    f.actions
  end

=begin
  controller do
    def permitted_params
      params.permit user: [:email, :password, :password_confirmation]
    end
  end
=end
end
