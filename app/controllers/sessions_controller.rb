class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logado!"
      redirect_to root_url
    else
      flash[:alert] = "E-mail ou senha inválidos"
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "Deslogado!"
    redirect_to root_url
  end
end