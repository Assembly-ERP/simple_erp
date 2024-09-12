# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
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
      else
        format.html { respond_with(resource) }
      end

      format.turbo_stream { render :create, status: resource_invited ? :ok : :unprocessable_entity }
    end
  end

  private

  def invite_params
    params.require(:user).permit(:email, :phone, :first_name, :last_name, :customer_id,
                                 :role, :skip_invitation, :invitation_token)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
