# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :configure_permitted_parameters, only: [:create]

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?

    token = JsonWebToken.encode(user_id: resource.id)
    
    # Set HTTP-only cookie
    cookies.signed[:jwt] = { value: token, httponly: true, secure: Rails.env.production? }
    
    redirect_to after_sign_in_path_for(resource)
  end

  def destroy
    cookies.delete(:jwt)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    redirect_to after_sign_out_path_for(resource_name)
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.operational_user?
      operational_root_path
    elsif resource.customer_user?
      customer_root_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end
end
