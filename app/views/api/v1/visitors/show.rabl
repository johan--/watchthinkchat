object @visitor
attributes :first_name, :last_name, :email, :notify_me_on_share
node(:url) do |visitor|
  visitor.decorate.url @campaign
end