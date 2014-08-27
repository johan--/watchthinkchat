ActiveAdmin.register ActiveAdmin::Comment, as: 'Comment' do
  menu if: proc { current_user && current_user.superadmin? }
end
