class ManageController < ApplicationController
  before_action :set_site
  before_action :authorize_support
  
  def dashboard
    @users = User.all
    @airlines = Airline.all
    @tickets = Ticket.all
  end

  def site_show
  end
  
  def site_update
    @site.update(mile_price: params[:mile_price])
    flash[:notice] = 'Valor da milha atualizado com sucesso'
    redirect_to dashboard_path
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.first
  end

  def authorize_support
    if current_user && current_user.is_support?
      true
    else
      flash[:alert] = "Você não tem permissão para ver essa página"
      redirect_to root_path
    end
  end

  # Only allow a list of trusted parameters through.
  def site_params
    params.require(:site_params).permit(:mile_price)
  end
end