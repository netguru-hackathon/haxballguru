class NameController < ApplicationController
  def new
    session.destroy
  end

  def create
    session[:user] = params[:name][:name]
    redirect_to :root
  end
end
