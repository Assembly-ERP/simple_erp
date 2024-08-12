# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, portal)
    return if user.blank?

    operational_portal(user) if operation?(portal, user)
    customer_portal(user) if customer?(portal, user)
  end

  private

  def operational_portal(_user)
    can :read, :dashboard
    can :read, :catalog
    can :manage, Product
    can :manage, Part
    can :manage, Order
    can :manage, SupportTicket
  end

  def customer_portal(_user)
    can :manage, :all
  end

  # Conditions
  def operation?(portal, user)
    portal == 'operational_portal' && user.operational_user?
  end

  def customer?(portal, user)
    portal == 'customer_portal' && user.customer_user?
  end
end
