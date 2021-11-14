class TicketPurchasesController < ApplicationController
  before_action :set_ticket_purchase, only: %i[ show edit update destroy ]

  # GET /ticket_purchases or /ticket_purchases.json
  def index
    @ticket_purchases = TicketPurchase.all
  end

  # GET /ticket_purchases/1 or /ticket_purchases/1.json
  def show
  end

  # GET /ticket_purchases/new
  def new
    @ticket_purchase = TicketPurchase.new
  end

  # GET /ticket_purchases/1/edit
  def edit
  end

  # POST /ticket_purchases or /ticket_purchases.json
  def create
    @user = User.find(ticket_purchase_params[:user_id])
    @ticket = Ticket.find(ticket_purchase_params[:ticket_id])

    if ticket_purchase_params[:payment_method] == 'Milhas'
      if !@user&.validate_payment(@ticket.value, use_miles: true)
        flash[:alert] = 'Milhas insuficientes, não foi possível efetuar a compra!'
        redirect_to buy_ticket_path(@ticket) and return
      end
    elsif ticket_purchase_params[:payment_method] == 'Cartão de crédito'
      if !@user&.validate_payment(@ticket.value)
        flash[:alert] = 'O pagamento foi recusado, não foi possível efetuar a compra!'
        redirect_to buy_ticket_path(@ticket)
      end
    end

    @ticket_purchase = TicketPurchase.create(ticket_purchase_params)
    @ticket.update(sold: true)
    flash[:notice] = 'Compra efetuada com sucesso!'
    redirect_to my_tickets_user_path(@user)
  end

  # PATCH/PUT /ticket_purchases/1 or /ticket_purchases/1.json
  def update
    respond_to do |format|
      if @ticket_purchase.update(ticket_purchase_params)
        format.html { redirect_to @ticket_purchase, notice: "Ticket purchase was successfully updated." }
        format.json { render :show, status: :ok, location: @ticket_purchase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ticket_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_purchases/1 or /ticket_purchases/1.json
  def destroy
    @ticket_purchase.update(cancelled_at: Time.now)
    @ticket_purchase.ticket.update(sold: false)
    flash[:notice] = "Passagem cancelada com sucesso!"
    redirect_to my_tickets_user_path(@ticket_purchase.user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_purchase
      @ticket_purchase = TicketPurchase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_purchase_params
      params.require(:ticket_purchase).permit(:user_id, :airline_id, :ticket_id, :payment_method, :cancelled_at)
    end

end
