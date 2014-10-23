object @invitee
attributes :id, :first_name, :last_name, :email, :notify_inviter
node(:url) do |invitee|
  invitee.invitations.find_by(inviter: current_visitor, campaign: @campaign).try(:decorate).try(:url)
end
