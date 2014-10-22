object @invitee
attributes :id, :first_name, :last_name, :email
node(:invite_token) do |invitee|
  invitee.invitations.find_by(inviter: current_visitor, campaign: @campaign).try(:token)
end