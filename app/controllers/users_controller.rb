class UsersController < ApplicationController
  before_action :set_user, except: %i[ new create ]
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
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def miles
  end

  def redeem_miles
    result = @user.redeem_miles(params[:code])
    if result
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :name, :cpf_cnpj, :user_type, :password, :password_confirmation)
    end
end
