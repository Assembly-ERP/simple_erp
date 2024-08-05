class CustomerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "customer"
  end

  # Broadcast existing customers to the newly connected client
  customers = Customer.all
  customers.each do |customer|
    ActionCable.server.broadcast "customers", { id: customer.id, name: customer.name }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
