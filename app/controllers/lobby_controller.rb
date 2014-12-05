class LobbyController < ApplicationController
  def index
    if user.nil?
      redirect_to :name
    end
  end
end
