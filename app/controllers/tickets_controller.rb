class TicketsController < ApplicationController
  before_action :set_ticket, except: %i[ index new create ]
  before_action :authorize_user

  # GET /tickets or /tickets.json
  def index
    @searchable_tickets   ||= Ticket.not_sold
    @searchable_from      ||= @searchable_tickets.pluck(:from).uniq
    @searchable_to        ||= @searchable_tickets.pluck(:to).uniq

    search_params = {from: params[:from], to: params[:to]}.reject {|p, v| v.blank? }
    @filtered_tickets = @searchable_tickets.where(search_params)
    unless params['departure(1i)'].blank?
      date = Date.parse("#{params['departure(1i)']}-#{params['departure(2i)']}-#{params['departure(3i)']}")
      @filtered_tickets = @filtered_tickets.where('departure > ? AND departure < ?', date.beginning_of_day, date.end_of_day)
    end

    @batches_with_tickets = @filtered_tickets.order(:created_at).group_by{ |t| t.batch }
  end

  # GET /tickets/1 or /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets or /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to tickets_path, notice: "Ticket was successfully created." }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1 or /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: "Ticket was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1 or /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: "Ticket was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def buy
    @needed_miles = (@ticket.value / site_configs.mile_price).to_i
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:airline_id, :flight, :batch, :max_cancellation_date, :departure, :from, :to, :value, :airplane)
    end
end
