class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # calls this method to check if the user is logged in before performing the actions
  before_action :correct_user, only: [:edit, :update] # calls this method to check if the user is the correct one before performing the actions
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) # Not the final implementation
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
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
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User has been successfully deleted."
    redirect_to users_url
  end

  # checks to see if the user is logged in before performing an action. if not the user is redirected to the root url
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # confirms an admin user
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  # checks to see if the logged in user is the one the action is supposed to handle. if not, the user is redirected to the root url
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  private :user_params, :logged_in_user, :correct_user, :admin_user

end
