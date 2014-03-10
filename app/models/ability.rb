class Ability
	include CanCan::Ability

	def initialize(user)
    can :read, ActiveAdmin::Page, :name => "Dashboard"
		can :manage, :all if user && user.is_superadmin?
    can :create, Campaign
    if user
      can :manage, Campaign, :user_id => user.id
      can :manage, Campaign, :admin1_id => user.id
      can :manage, Campaign, :admin2_id => user.id
      can :manage, Campaign, :admin3_id => user.id
    end
	end
end
