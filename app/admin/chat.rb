ActiveAdmin.register Chat do
  filter :uid
  filter :status, :as => :select, :collection => [ "open", "closed" ]
  filter :campaign, :collection => proc { Campaign.all.order("name asc, permalink asc") }
  filter :operator, :collection => proc { User.operators.order("first_name asc, last_name asc") }
  filter :operator_whose_link, :collection => proc { User.operators }, :label => "Link Sharer"
  filter :messages_body_contains, :as => :string

  index do
    selectable_column
    column :id
    column :operator
    column "Link Sharer", :operator_whose_link
    column :campaign
    column "Header" do |chat|
      chat.messages.first(3).collect(&:body).join("<br/>").html_safe
    end
    actions
  end

  show do
    panel "Details" do
      attributes_table_for chat do
        [ :operator, :visitor, :created_at, :updated_at, :campaign, :status, :uid ].each do |column|
          row column
        end
      end
    end
    panel "Transcript" do
      table_for chat.messages do
        column :created_at
        column :name
        column :body
      end
    end
  end

  form do |f|
    f.inputs "Status" do
      f.input :status, :as => :select, :collection => [ "open", "closed" ]
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end

end
