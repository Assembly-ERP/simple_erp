class InvitationMailer < ApplicationMailer
  def invite_user(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'You are invited to join our platform')
  end
end
