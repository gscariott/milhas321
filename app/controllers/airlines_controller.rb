class AirlinesController < ApplicationController
  before_action :set_airline, only: %i[ show edit edit_batch update destroy new_batch create_batch]
  before_action :authorize_user

  # GET /airlines or /airlines.json
  def index
    @airlines = Airline.all
  end

  # GET /airlines/1 or /airlines/1.json
  def show
    @batches = @airline.tickets.distinct.pluck(:batch)
  end

  # GET /airlines/new
  def new
    @airline = Airline.new
  end

  # GET /airlines/1/edit
  def edit
  end

  def edit_batch
    batch_size =  Ticket.all.where(batch: params[:batch]).count
    new_size = params[:size].to_i
    if new_size > batch_size
      diff = new_size - batch_size
      ticket_params = Ticket.find_by(batch: params[:batch]).attributes
      diff.times do
        Ticket.create(ticket_params.except("id", "created_at", "updated_at"))
      end
    elsif batch_size > new_size
      diff = batch_size - new_size
      Ticket.all.where(batch: params[:batch]).last(diff).each do |t|
        t.destroy
      end
    end

    if params[:price].to_f != Ticket.find_by(batch: params[:batch]).value
      Ticket.all.where(batch: params[:batch]).update_all(value: params[:price].to_f)
    end
    
    flash[:notice] = "Lote editado com sucesso"
    redirect_to airline_path(@airline)
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

  def new_batch
  end

  def create_batch
    max_cancellation_date = DateTime.new(
      params["max_cancellation_date(1i)"].to_i,
      params["max_cancellation_date(2i)"].to_i,
      params["max_cancellation_date(3i)"].to_i,
      params["max_cancellation_date(4i)"].to_i,
      params["max_cancellation_date(5i)"].to_i
    )

    departure = DateTime.new(
      params["departure(1i)"].to_i,
      params["departure(2i)"].to_i,
      params["departure(3i)"].to_i,
      params["departure(4i)"].to_i,
      params["departure(5i)"].to_i
    )


    batch_params = {
      airline: @airline,
      flight: params[:flight],
      batch: SecureRandom.uuid,
      max_cancellation_date: max_cancellation_date,
      departure: departure,
      from: params[:from],
      to: params[:to],
      value: params[:value],
      airplane: params[:airplane]
    }

    params[:batch_size].to_i.times do
      Ticket.create(batch_params)
    end

    redirect_to @airline, notice: "Batch was successfully updated."
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
