class SessionsController < ApplicationController
  def new
    redirect_to current_user unless current_user == nil
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to current_user 
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destory
    log_out
    redirect_to root_url
  end

end
