# frozen_string_literal: true
# typed: true

class PolyAttributeComponent < ViewComponent::Base
  extend T::Sig

  attr_reader :nested_form

  sig { params(nested_form: ActionView::Helpers::FormBuilder).void }
  def initialize(nested_form:)
    @nested_form = nested_form
    super
  end
end
