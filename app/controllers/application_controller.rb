class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def site_configs
    Site.first
  end

  def authorize_user
    if current_user.present?
      true
    else
      flash[:alert] = "Você precisa estar logado para ver essa página"
      redirect_to login_path
    end
  end

end
