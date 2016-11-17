class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, ChatRoom do |room|
      user.admin? || room.owner == user
    end
  end
end
