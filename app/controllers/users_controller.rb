class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :authorized_user, only: [:edit, :update]
  before_action :check_user_exist, only: :show
  before_action :admin_user, only: :destroy
  skip_before_action :verify_authenticity_token, only: :query

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show 
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activte your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Changes saved!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find params[:id]
    @users = @user.following.paginate page: params[:page]
    render 'show_follow'
  end 

  def followers
    @title = "Followers"
    @user = User.find params[:id]
    @users = @user.followers.paginate page: params[:page]
    render 'show_follow'
  end

  def query
    result = Schema.execute params[:query]
    render json: result
  end

  private

    def check_user_exist
      @user = User.find(params[:id])
      if @user == nil
        flash[:info] = "User not found"
        redirect_to root_url
      end
    end

    def authorized_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
