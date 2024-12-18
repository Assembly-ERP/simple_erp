# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :operational_user?, only: %i[new create]

  def new
    self.resource = resource_class.new
    render :new
  end

  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    respond_to do |format|
      if resource_invited
        format.html do
          if is_flashing_format? && resource.invitation_sent_at
            set_flash_message :notice, :send_instructions, email: resource.email
          end
          if method(:after_invite_path_for).arity == 1
            respond_with resource, location: after_invite_path_for(current_inviter)
          else
            respond_with resource, location: after_invite_path_for(current_inviter, resource)
          end
        end
        format.turbo_stream
      else
        format.html { respond_with(resource) }
        format.turbo_stream { render status: :unprocessable_entity }
      end
    end
  end

  private

  def operational_user?
    redirect_to root_path, alert: 'You are not allowed to access page.' unless current_user.operational_user?
  end

  # will invite customer user when customer portal is ready
  def invite_resource
    super { |user| user.skip_invitation = true if user.customer_user? }
  end

  def invite_params
    params.require(:user).permit(
      :email, :phone, :first_name, :last_name, :customer_id,
      :role, :skip_invitation, :invitation_token
    )
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
