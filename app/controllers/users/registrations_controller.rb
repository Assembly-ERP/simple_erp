# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  # GET /users/sign_up
  def new
    build_resource({})
    resource.build_customer
    respond_with resource
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer
      .permit(
        :sign_up, keys: [:email, :phone, :password, :password_confirmation, :first_name, :last_name,
                         { customer_attributes: }]
      )
  end

  def sign_up_params
    params.require(resource_name).permit(
      :email, :phone, :password, :password_confirmation, :first_name, :last_name, { customer_attributes: }
    )
  end

  def customer_attributes
    %i[name street phone city state postal_code discount]
  end
end
