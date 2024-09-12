# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  private

  def invite_params
    params.require(:user).permit(:email, :phone, :first_name, :last_name, :customer_id,
                                 :role, :skip_invitation, :invitation_token)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end
end
