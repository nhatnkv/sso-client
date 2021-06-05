class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :doorkeeper

  def doorkeeper
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Doorkeeper'
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.doorkeeper_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    success('Google')
  end

  def facebook
    success('Facebook')
  end

  def failure
    redirect_to root_path
  end

  def success(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: provider
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: provider, reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_registration_url
    end
  end
end
