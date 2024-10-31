# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, portal)
    public_facing if public?(portal)

    return if user.blank?

    operational_portal(user) if operation?(portal, user)
    customer_portal(user) if customer?(portal, user)
    api_v1(user) if api_operation?(portal, user)
  end

  private

  def operational_portal(user)
    can :read, :dashboard
    can %i[read search category_filter], :catalog
    can :manage, :profile

    # Product
    can %i[read new create], Product
    can %i[update destroy edit], Product, voided_at: nil
    can :search_part_results, :product

    # Part
    can %i[read new create], Part
    can %i[update destroy edit], Part, voided_at: nil

    # Order
    can %i[read new create], Order
    can %i[make_ticket quote_or_invoice update_summary], Order
    can %i[update destroy edit cancel], Order, voided_at: nil, order_status: { allow_change: true }
    can :search_catalog, :order

    can :manage, SupportTicket
    can :manage, SupportTicketMessage
    can :manage, CustomerImport
    can :manage, User, advance: false
    can :manage, Customer, voided_at: nil
    can :manage, Setting
    can :manage, OrderPriceScheduler
    can :manage, Branding if user.role == 'admin'
  end

  def customer_portal(user)
    # can :manage, :dashboard
    can :manage, :catalog
    can :manage, :profile
    can :manage, :cart
    can :manage, Order, customer: user.customer
    can :manage, SupportTicket, customer: user.customer
    can(:manage, Cart, user:)
    can :show, Part
    can :show, Product

    can :create, SupportTicketMessage
    can :read, SupportTicketMessage, support_ticket: { customer: user.customer }
    can %i[update destroy], SupportTicketMessage, user:
  end

  def api_v1(_user)
    can :me, :auth
    can :manage, User
    can :manage, Part
  end

  def public_facing
    can :show, Part, voided_at: nil
    can :show, Product, voided_at: nil
  end

  # Conditions
  def operation?(portal, user)
    portal == 'operational_portal' && user.operational_user?
  end

  def customer?(portal, user)
    portal == 'customer_portal' && user.customer_user?
  end

  def api_operation?(portal, user)
    portal == 'api_v1' && user.operational_user? && user.advance?
  end

  def public?(portal)
    portal == 'public'
  end
end
