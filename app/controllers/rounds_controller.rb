class RoundsController < ApplicationController

  def new
    Round.all.each do |round|
      if round.active?
        flash[:error] = "There is already an active round with id: #{round.id}"
        redirect_to :back
      end
    end
    @round = Round.new
  end

end
