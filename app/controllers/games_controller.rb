class GamesController < ApplicationController
  def create
    session[:user] = params[:games][:nick]
  end

  def index
  end
end
