class UsersController < ApplicationController
  before_action :authenticate, only: [:edit, :update]
  before_action :check_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,                 :password_confirmation)
  end

  def authenticate
    current_user = User.find_by(id: session[:user_id])
    return if (current_user == User.find(params[:id]))
    flash[:warning]= "Ban khong co quyen chinh sua trang ca nhan nguoi khac!"
    redirect_to current_user
  end

  def check_login
    return unless logged_in?
    flash[:warning] = "Ban khong co quyen truy cap trang nay!"
    redirect_to current_user
  end

end
