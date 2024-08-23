# frozen_string_literal: true
# typed: true

class NavbarLinkComponent < ViewComponent::Base
  extend T::Sig

  sig { params(label: String, path: String).void }
  def initialize(label:, path:)
    @label = label
    @path = path
    super
  end
end
