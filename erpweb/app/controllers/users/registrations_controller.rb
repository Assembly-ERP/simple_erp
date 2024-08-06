# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]

  def create
    if params[:invite_token].present?
      handle_invitation
    else
      super do |user|
        if user.persisted?
          customer = Customer.create!(
            name: user.customer_name,
            phone: user.customer_phone,
            street: user.street,
            city: user.city,
            state: user.state,
            postal_code: user.postal_code,
            discount: user.discount.to_f
          )
          user.update!(customer:, role: 'customer_user_admin')
        end
      end
    end
  end

  # Remove the ability to destroy an account
  def destroy
    redirect_to root_path, alert: 'Account cancellation is not allowed.'
  end

  protected

  def handle_invitation
    invitation = Invitation.find_by(token: params[:invite_token], email: params[:user][:email])
    if invitation
      build_resource(sign_up_params)
      resource.customer = invitation.customer
      resource.save
      yield resource if block_given?
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      flash[:alert] = 'Invalid invitation token or email.'
      redirect_to new_user_registration_path
    end
  end

  # def create_or_associate_customer(user)
  #   customer = Customer.find_or_create_by(name: sign_up_params[:customer_name].presence || user.name) do |customer|
  #     customer.phone = sign_up_params[:customer_phone]
  #     customer.tax_id = sign_up_params[:customer_tax_id]
  #   end
  #   user.update(customer: customer)
  # end

  # Override the update resource to prevent password requirement on profile update
  def update_resource(resource, params)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[
                                        invite_token name role customer_name customer_phone customer_tax_id
                                        email street city state postal_code discount
                                      ])
  end
end
