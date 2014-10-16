object @invitee
attributes :id, :first_name, :last_name, :email
node(:invite_token) do |invitee|
  invitee.invitations.where(inviter: current_visitor, campaign: @campaign).first.token
end
