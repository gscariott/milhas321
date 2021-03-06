class UsersController < ApplicationController
  before_action :set_user, except: %i[ new create index bank_account ]
  before_action :authorize_user, except: %i[ new create ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: "Usuário criado com sucesso!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = "Usuário atualizado!"
      redirect_to @user
    else
      flash[:alert] = "Erro ao atualizar usuário! #{@user.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.ticket_purchases.each { |tp| tp.ticket.update(sold: false) }
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "Usuário destruido com sucesso!" }
      format.json { head :no_content }
    end
  end

  def miles
    @miles_offers = MilesOffer.where(user_id: @user.id, available: true)
    @miles_total = MilesOffer.pluck(:quantity).sum
  end

  def redeem_miles
    result = @user.redeem_miles(params[:code])
    if result >= 0
      flash[:notice] = "#{result} milhas resgatadas com sucesso!"
    else
      flash[:alert] = "Esse código é inválido!"
    end
    redirect_to miles_user_path(@user)
  end

  def sell_miles  
    qty = params[:quantity].to_i 
    user_miles = @user.miles
    begin
      if qty > user_miles
        flash[:alert] = "Milhas insuficientes - Tentativa: #{qty}, Disponíveis: #{user_miles}"
      elsif qty == 0 # TO-DO: Better presence validation
        raise
      else
        MilesOffer.create(
        quantity: params[:quantity],
        available: true, # TO-DO: Set true as the default value
        user: @user
        )
        @user.update(miles: user_miles - qty)
        flash[:notice] = "Milhas colocadas à venda com sucesso!"
      end
    rescue
      flash[:alert] = "Erro ao colocar as milhas à venda"
    end

    redirect_to miles_user_path(@user)
  end

  def buy_miles
    offers = MilesOffer.where(available: true).order(:created_at)
    qty = params[:quantity].to_i
    miles_total = MilesOffer.pluck(:quantity).sum
    if miles_total >= qty
      if @user.validate_payment(qty * site_configs.mile_price)
        @user.update(miles: @user.miles + qty)
        offers.each do |o|
          if o.quantity >= qty
            o.user.refund(qty * site_configs.mile_price)
            o.update(available: false) if o.quantity == qty
            o.update(quantity: o.quantity - qty)
            break
          else
            o.user.refund(o.quantity * site_configs.mile_price)
            qty = qty - o.quantity
            o.update(quantity: 0, available: false)
          end
        end
      else
        flash[:alert] = "O pagamento foi recusado pelo banco"
      end
    else
      flash[:alert] = "Quantidade de milhas disponíveis é menor do que o solicitado"
    end

    redirect_to miles_user_path(@user)
  end

  def bank_account
    @account = current_user.bank_account
    render :bank_account, layout: nil
  end

  def my_tickets
    @ticket_purchases = @user.ticket_purchases
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :cpf_cnpj, :user_type, :password, :password_confirmation, :miles)
    end
end
