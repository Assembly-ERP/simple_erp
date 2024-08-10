# frozen_string_literal: true

class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin_or_manager, only: %i[new create]

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.customer = current_user.customer

    if @invitation.save
      InvitationMailer.invite_user(@invitation).deliver_now
      redirect_to root_path, notice: 'Invitation sent successfully.'
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def ensure_admin_or_manager
    return if current_user.admin? || current_user.manager?

    redirect_to root_path, alert: 'You are not authorized to send invitations.'
  end
end
