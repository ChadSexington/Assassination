class PlayersController < ApplicationController

  def new
    @player = Player.new()
  end

  def create
    @player = Player.new(new_player_params)
    if @player.save
      flash[:success] = "New player created! Welcome to the game!"
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
    @player = Player.find_by_username(params[:id])
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

private
  
  def new_player_params
    params.require(:player).permit(:name, :email, :irc_nick, :notes, :photo)
  end

  def edit_player_params
    params.require(:player).permit(:name, :email, :irc_nick, :notes, :photo)
  end

end
