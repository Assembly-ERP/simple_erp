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
    can :index, :dashboard
    can :index, :catalog

    # product
    can :manage, Product
    can :search_part_results, :product

    # part
    can :manage, Part

    # Order
    can %i[index show new create], Order
    can %i[update destroy sync_price edit], Order, order_status: { locked: false }
    can :search_results, :order

    can :manage, SupportTicket
    can :manage, User
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
