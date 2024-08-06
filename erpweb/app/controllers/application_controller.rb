class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def ensure_operational_user
    return if current_user&.operational_user?

    redirect_to root_path, alert: 'You do not have access to this section.'
  end

  def ensure_admin
    return if current_user.admin?

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end

  def ensure_manager_or_admin
    return if current_user.manager? || current_user.admin?

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation name phone])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email password password_confirmation current_password name phone])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
  end

  def after_sign_in_path_for(resource)
    if resource.operational_user?
      operational_root_path
    elsif resource.customer_user?
      customer_root_path
    else
      root_path # Redirect to the home page or any other default public page
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def customer_document(customer)
    {
      id: customer.id.to_s,
      name: customer.name,
      phone: customer.phone,
      street: customer.street,
      city: customer.city,
      state: customer.state,
      postal_code: customer.postal_code,
      discount: customer.discount.to_f
    }
  end

  # def upsert_document(collection_name, document)
  #   begin
  #     TYPESENSE_CLIENT.collections[collection_name].documents[document[:id]].delete
  #   rescue Typesense::Error::ObjectNotFound
  #     # Ignore if the document doesn't exist
  #   end
  #   TYPESENSE_CLIENT.collections[collection_name].documents.create(document)
  # end
end
