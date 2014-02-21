ActiveAdmin.register Chat do
  filter :uid
  filter :status, :as => :select, :collection => [ "open", "closed" ]

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
