class GamesController < ApplicationController
  def create
  end

  def index
  end

  def game
    @host = params[:name]
  end
end
