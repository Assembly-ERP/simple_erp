# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, portal)
    return if user.blank?

    operational_portal(user) if portal == 'operational_portal'
    customer_portal(user) if portal == 'customer_portal'
  end

  private

  def operational_portal(_user)
    can :read, :dashboard
    can :manage, Order
    can :manage, Part
  end

  def customer_portal(_user)
    can :manage, :all
  end
end
