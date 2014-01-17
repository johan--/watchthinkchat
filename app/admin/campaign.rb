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

=begin
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit user: [:email, :password, :password_confirmation]
    end
  end
=end
end
