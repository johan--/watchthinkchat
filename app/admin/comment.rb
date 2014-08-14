ActiveAdmin.register ActiveAdmin::Comment, as: 'Comment' do
  menu if: Proc.new { current_user && current_user.superadmin? }
end
