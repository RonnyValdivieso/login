class UsersController < ApplicationController
	def destroy
		@user = User.find(params[:id])
	    @user.destroy

	    if @user.destroy
	        redirect_to root_url, notice: "Usuario eliminado."
	    end
	end
end