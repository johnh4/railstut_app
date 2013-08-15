class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	if user && user.authenticate(params[:password])
  		flash[:success] = "You have signed in!"
  		sign_in(user)
  		redirect_to user
  	else
  		flash[:error] = "Incorrect email/password combination"
  		render 'new'
  	end
  end

  def destroy
  	sign_out
  	flash[:success] = "You have signed out!"
  	redirect_to root_path
  end

  private

  	def session_params
  		params.require(:session).permit(:email,:password)
  	end
end
