class ManageController < ApplicationController
  before_action :set_site
  
  def dashboard
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

  # Only allow a list of trusted parameters through.
  def site_params
    params.require(:site_params).permit(:mile_price)
  end
end