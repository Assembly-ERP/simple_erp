# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, portal)
    public_facing if public?(portal)

    return if user.blank?

    operational_portal(user) if operation?(portal, user)
    customer_portal(user) if customer?(portal, user)
    api_v1_portal(user) if api_v1?(portal, user)
  end

  private

  def operational_portal(user)
    can :read, :dashboard
    can %i[read search category_filter], :catalog
    can :manage, :profile

    # Product
    can :manage, Product, voided_at: nil
    can :search_part_results, :product

    # Part
    can :manage, Part, voided_at: nil

    # Order
    can %i[new create], Order
    can %i[read make_ticket quote_or_invoice update_summary], Order, voided_at: nil
    can %i[update destroy edit cancel], Order, voided_at: nil, order_status: { allow_change: true }
    can :search_catalog, :order

    # Support ticket
    can :manage, SupportTicket

    # Manage
    can :manage, User, advance: false
    can :manage, Customer, voided_at: nil

    can :manage, Setting
    can :manage, Billing
    can :manage, CustomerImport
    can :manage, OrderPriceScheduler
    can :manage, Branding if user.role == 'admin'
  end

  def customer_portal(user)
    # can :manage, :dashboard
    can :manage, :catalog
    can :manage, :profile
    can :manage, :cart

    can :show, Part
    can :show, Product

    can(:manage, Cart, user:)
    can(:manage, Order, customer: user.customer)

    can :manage, SupportTicket, customer: user.customer if user.role == 'customer_user_admin'
    can :manage, SupportTicket, customer: user.customer, user:
  end

  def api_v1_portal(_user)
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
    portal == Portal::OPERATION && user.operational_user?
  end

  def customer?(portal, user)
    portal == Portal::CUSTOMER && user.customer_user?
  end

  def api_v1?(portal, user)
    portal == Portal::API_V1 && user.operational_user? && user.advance?
  end

  def public?(portal)
    portal == Portal::PUBLIC
  end
end
