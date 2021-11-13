class MilesOffersController < ApplicationController
  before_action :set_miles_offer, only: %i[ show edit update destroy ]

  # GET /miles_offers or /miles_offers.json
  def index
    @miles_offers = MilesOffer.all
  end

  # GET /miles_offers/1 or /miles_offers/1.json
  def show
  end

  # GET /miles_offers/new
  def new
    @miles_offer = MilesOffer.new
  end

  # GET /miles_offers/1/edit
  def edit
  end

  # POST /miles_offers or /miles_offers.json
  def create
    @miles_offer = MilesOffer.new(miles_offer_params)

    respond_to do |format|
      if @miles_offer.save
        format.html { redirect_to @miles_offer, notice: "Miles offer was successfully created." }
        format.json { render :show, status: :created, location: @miles_offer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @miles_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /miles_offers/1 or /miles_offers/1.json
  def update
    respond_to do |format|
      if @miles_offer.update(miles_offer_params)
        format.html { redirect_to @miles_offer, notice: "Miles offer was successfully updated." }
        format.json { render :show, status: :ok, location: @miles_offer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @miles_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /miles_offers/1 or /miles_offers/1.json
  def destroy
    qty = @miles_offer.quantity
    @user = @miles_offer.user
    @miles_offer.destroy
    respond_to do |format|
      format.html { redirect_to miles_user_path(@user), notice: "Venda cancelada. #{qty} milhas restauradas" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_miles_offer
      @miles_offer = MilesOffer.find(params[:id])
    end

    def restore_user_miles

    end

    # Only allow a list of trusted parameters through.
    def miles_offer_params
      params.require(:miles_offer).permit(:quantity, :available, :user_id)
    end
end
