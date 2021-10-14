class AirlinesController < ApplicationController
  before_action :set_airline, only: %i[ show edit update destroy ]

  # GET /airlines or /airlines.json
  def index
    @airlines = Airline.all
  end

  # GET /airlines/1 or /airlines/1.json
  def show
  end

  # GET /airlines/new
  def new
    @airline = Airline.new
  end

  # GET /airlines/1/edit
  def edit
  end

  # POST /airlines or /airlines.json
  def create
    @airline = Airline.new(airline_params)

    respond_to do |format|
      if @airline.save
        format.html { redirect_to @airline, notice: "Airline was successfully created." }
        format.json { render :show, status: :created, location: @airline }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @airline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airlines/1 or /airlines/1.json
  def update
    respond_to do |format|
      if @airline.update(airline_params)
        format.html { redirect_to @airline, notice: "Airline was successfully updated." }
        format.json { render :show, status: :ok, location: @airline }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @airline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airlines/1 or /airlines/1.json
  def destroy
    @airline.destroy
    respond_to do |format|
      format.html { redirect_to airlines_url, notice: "Airline was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_airline
      @airline = Airline.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def airline_params
      params.require(:airline).permit(:name, :cnpj, :user_id)
    end
end
