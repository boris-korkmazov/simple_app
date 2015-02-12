class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user and user.authenticate(params[:session][:password])
      #Sign the user
      sign_in user
      redirect_to user
    else
      #Create an error message
      flash.now[:error] = 'Invalid email/password combination'
      render :new
    end  
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
