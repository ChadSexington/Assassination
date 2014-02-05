class PlayersController < ApplicationController

  def new
    @player = Player.new()
    #TODO delete this flash when the game goes live
    flash[:success] = "The game is not live. Registration will not carry over when the game starts."
  end

  def create
    @player = Player.new(new_player_params)
    if @player.save
      flash[:success] = "New player created, confirm your account to log in."
      PlayerMailer.confirmation_email(@player).deliver
      redirect_to "/players/#{@player.username}/confirmation"
    else
      render 'new'
    end
  end

  def edit
    @player = Player.find_by_username(params[:id])
  end

  def update
    @player = Player.find_by_username(params[:id])
    if @player.update_attributes(edit_player_params)
      flash[:success] = "Updated #{@player.name} successfully!"
      redirect_to @player
    else
      Rails.logger.info(@player.errors.messages.inspect)
      flash[:error] = "Unable to update player"
      redirect_to edit_player_path(@player)
    end
  end

  def index
    if admin?
      @players = Player.all
    else
      redirect_to '/welcome/about'
    end
  end

  def show
    if session[:player]
      if @player = Player.find_by_username(params[:id])
        if not @player.username == session[:player].username || admin?
          flash[:error] = "You do not have access to this player's profile"
          redirect_to '/welcome/index'
        end
      else
        flash[:error] = "The player #{params[:id]} does not exist"
        redirect_to '/welcome/index'  
      end
    else
      flash[:error] = "You are not logged in!"
      redirect_to '/welcome/index'
    end
  end

  def destroy
    @player = Player.find_by_username(params[:id])
    player = @player.name
    if @player.destroy
      flash[:success] = player + " successfully deleted"
      redirect_to players_path
    else
      flash[:error] = player + " could not be deleted"
      redirect_to :back
    end
  end

  def change_password
    @player = Player.find_by_username(params[:id])
  end

  def login
    if session[:player] = Player.authenticate(login_params[:email], login_params[:password])
      if session[:player].confirmed == true
        if session[:player].banned == false
          flash[:success] = "Login successful"
          redirect_to :back
        else
          flash[:error] = "You have been banned. Check your email for reasoning and length of the ban"
          redirect_to "/welcome/index"
        end
      else
        reset_session
        flash[:error] = "Account has not yet been confirmed."
        redirect_to :back 
      end
    else
      flash[:error] = "Incorrect credentials, please try again"
      redirect_to :back
    end
  end

  def logout
    if session[:player]
      reset_session
      flash[:success] = "Logged out"
      redirect_to '/welcome/index'
    else
      flash[:error] = "Not currently logged in"
      redirect_to :back
    end
  end
  
  def confirmation
    @player = Player.find_by_username(params[:id])
  end

  def confirm
    if @player = Player.find_by_confirmation_code(params[:confirmation_code])
      if @player.confirmed == false
        @player.confirmed = true
        @player.save
        flash[:success] = "Account for " + @player.name + " confirmed! Welcome to the game!"
        PlayerMailer.welcome_email(@player)
        redirect_to '/welcome/index'
      else
        flash[:error] = "Account for " + @player.name + " has already been confirmed." 
        redirect_to '/welcome/index'
      end
    else
      flash[:error] = "Confirmation code \"" + params[:confirmation_code] + "\" not associated with any player"
      redirect_to '/welcome/index'
    end
  end

private
  
  def new_player_params
    params.require(:player).permit!
    # temp allowing all while authentication is worked out.
    #params.require(:player).permit(:name, :email, :irc_nick, :notes, :photo)
  end

  def edit_player_params
    if admin?
      params.require(:player).permit(:name, :email, :password, :password_confirm, :irc_nick, :notes, :photo, :admin)
    else
      params.require(:player).permit(:name, :email, :password, :password_confirm, :irc_nick, :notes, :photo)
    end
  end
  
  def login_params
    params.require(:player).permit(:email, :password)
  end
end
