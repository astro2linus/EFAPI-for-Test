class UsersController < ApplicationController
  def index
  end

  def show
  	@username = params[:username]
  end

  private
	def user_params
		params.require(:uesr).permit(:username)
	end
end
