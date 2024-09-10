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

    # Product
    can :manage, Product
    can :search_part_results, :product

    # Part
    can :manage, Part

    # Order
    can %i[read new create], Order
    can %i[update destroy edit], Order, voided_at: nil, order_status: { operation_locked: false }
    can :search_results, :order

    # Support Ticket
    can :manage, SupportTicket

    # Manage Pages
    can :manage, User
    can :manage, Customer
    can :manage, Setting
    can :manage, OrderPriceScheduler
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
