class Ability
	include CanCan::Ability

	def initialize(user)
		can :manage, :all if user.is_superadmin?
    can :create, Campaign, :user_id => user.id
    can :manage, Campaign, :user_id => user.id
    can :manage, Campaign, :admin1_id => user.id
    can :manage, Campaign, :admin2_id => user.id
    can :manage, Campaign, :admin3_id => user.id
	end
end
