# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `OrderMailer`.
# Please instead update this file by running `bin/tapioca dsl OrderMailer`.


class OrderMailer
  class << self
    sig { returns(::ActionMailer::MessageDelivery) }
    def quote?; end

    sig { params(order: T.untyped).returns(::ActionMailer::MessageDelivery) }
    def send_quote_or_invoice(order); end
  end
end
