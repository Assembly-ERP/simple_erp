# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, portal)
    return if user.blank?

    operational_portal(user) if operation?(portal, user)
    customer_portal(user) if customer?(portal, user)
    api_v1(user) if api_operation?(portal, user)
  end

  private

  def operational_portal(user)
    can :index, :dashboard
    can %i[index search], :catalog
    can :manage, :profile

    # Product
    can %i[read new create], Product
    can %i[update destroy edit], Product, voided_at: nil
    can :search_part_results, :product

    # Part
    can %i[read new create], Part
    can %i[update destroy edit], Part, voided_at: nil

    # Order
    can %i[read new create search make_ticket qoute_or_invoice update_summary], Order
    can %i[update destroy edit cancel], Order, voided_at: nil, order_status: { allow_change: true }
    can :search_results, :order

    # Support Ticket
    can :manage, SupportTicket

    # Imports
    can :manage, CustomerImport

    # Manage Pages
    can :manage, User, advance: false
    can :manage, User if user.advance?

    can :manage, Customer, voided_at: nil
    can :manage, Setting
    can :manage, OrderPriceScheduler

    # Branding
    can :manage, Branding if user.role == 'admin'
  end

  def customer_portal(user)
    can :manage, :dashboard
    can :manage, :profile
    can :manage, :catalog
    can :manage, Cart, customer: user.customer
    can :manage, Order, customer: user.customer
    can :manage, SupportTicket, customer: user.customer

    can :create, SupportTicketMessage
    can :read, SupportTicketMessage, support_ticket: { customer: user.customer }
    can %i[update destroy], SupportTicketMessage, user:
  end

  def api_v1(_user)
    can :me, :auth
  end

  # Conditions
  def operation?(portal, user)
    portal == 'operational_portal' && user.operational_user?
  end

  def customer?(portal, user)
    portal == 'customer_portal' && user.customer_user?
  end

  def api_operation?(portal, user)
    portal == 'api_v1' && user.operational_user? && user.advance
  end
end
