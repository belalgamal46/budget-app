class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    if user.admin?
      can :manage, :all
    else
      can :manage, Trade
      can :manage, Group
      can :manage, GroupTrade
      can :read, :all
    end
  end
end
