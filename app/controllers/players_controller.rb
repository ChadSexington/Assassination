class PlayersController < ApplicationController

  def new
    @player = Player.new()
    #TODO delete this flash when the game goes live
    flash[:success] = "The game is not live. Registration will not carry over when the game starts."
  end

  def create
    @player = Player.new(new_player_params)
    if @player.save
      flash[:success] = "New player created! Welcome to the game!"
      session[:player] = Player.authenticate(new_player_params[:email], new_player_params[:password])
      redirect_to @player
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
      @player.save
      flash[:success] = "Updated #{@player.name} successfully!"
      redirect_to @player
    else
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
        if not @player.username == session[:player].username
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

  def login
    if session[:player] = Player.authenticate(login_params[:email], login_params[:password])
      flash[:success] = "Login successful"
      redirect_to :back
    else
      flash[:error] = "Incorrect credentials, please try again"
      redirect_to :back
    end
  end

  def logout
    if session[:player]
      reset_session
      flash[:success] = "Logged out"
      redirect_to :back
    else
      flash[:error] = "Not currently logged in"
      redirect_to :back
    end
  end

private
  
  def new_player_params
    params.require(:player).permit!
    # temp allowing all while authentication is worked out.
    #params.require(:player).permit(:name, :email, :irc_nick, :notes, :photo)
  end

  def edit_player_params
    params.require(:player).permit(:name, :email, :irc_nick, :notes, :photo)
  end
  
  def login_params
    params.require(:player).permit(:email, :password)
  end
end
