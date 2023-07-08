class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :manage, Trade, user_id: user.id
      can :manage, Group, user_id: user.id
      can :manage, GroupTrade, user_id: user.id
      can :read, :all
    end
  end
end
