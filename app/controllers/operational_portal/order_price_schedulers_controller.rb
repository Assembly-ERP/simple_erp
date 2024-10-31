# frozen_string_literal: true

module OperationalPortal
  class OrderPriceSchedulersController < OperationalPortal::ManageBaseController
    load_and_authorize_resource

    def index
      @order_price_schedulers = OrderPriceScheduler.accessible_by(current_ability)
    end
  end
end
