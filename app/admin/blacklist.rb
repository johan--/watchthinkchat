ActiveAdmin.register Blacklist do
  menu label: "Blacklist"

  index do
    column :id
    column :ip
    column :blocked_count
    column :created_at
    column :updated_at
    default_actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
