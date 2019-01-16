class UsersController < ApplicationController
  before_action :authenticate, only: [:index, :show, :edit, :update, :delete]
  before_action :check_login, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :verify_admin, only: [:destroy]

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
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Cap nhat thong tin ca nhan thanh cong!"
      redirect_to @user
    else
      flash[:warning] = "Cap nhat khong thanh cong!"
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "Xoa tai khoan thanh cong!"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def authenticate
    return if logged_in?
    flash[:warning] = "Ban khong co quyen truy cap!"
    redirect_to root_url
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    return if @user && (@current_user == @user)
    flash[:warning]= "Ban khong co quyen chinh sua trang ca nhan nguoi khac!"
    redirect_to @current_user
  end

  def check_login
    return unless logged_in?
    flash[:warning] = "Ban khong co quyen truy cap trang nay!"
    redirect_to current_user
  end

  def verify_admin
    return if current_user.admin?
    redirect_to root_url
  end

end
