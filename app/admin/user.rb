ActiveAdmin.register User do
  filter :first_name
  filter :last_name

  menu :if => Proc.new { current_user && current_user.is_superadmin? }

  index do
    selectable_column
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :status, :as => :select, :collection => [ "online", "offline" ]
      if user.admin?
        f.input :admin
      end
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
