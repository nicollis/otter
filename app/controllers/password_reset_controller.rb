class PasswordResetController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_experation, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    @user.send_password_reset_email if @user
    flash[:info] = "Email sent with password reset instructions, if email exist in our accounts"
    redirect_to root_url
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      redirect_to root_url unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
    end

    def check_experation
      if @user.password_reset_expired?
        flash[:danager] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

end
