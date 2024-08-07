# frozen_string_literal: true
# typed: true

class ErrorCardComponent < ViewComponent::Base
  extend T::Sig

  attr_reader :errors, :label

  sig { params(errors: T::Array[String], label: T.nilable(String)).void }
  def initialize(errors: [], label: 'errors')
    @errors = errors
    @label = label
    super
  end
end
