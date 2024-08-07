# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  # GET /users/sign_up
  def new
    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.build_customer
    respond_with resource
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer
      .permit(:sign_up, keys: [:email, :password, :password_confirmation, :name,
                               { customer_attributes: }])
  end

  def sign_up_params
    params.require(resource_name).permit(:email, :password, :password_confirmation, :name,
                                         { customer_attributes: })
  end

  def customer_attributes
    %i[name street phone city state postal_code discount]
  end
end
