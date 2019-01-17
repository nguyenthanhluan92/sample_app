class PasswordResetsController < ApplicationController
  before_action :user_activated, only: [:edit, :update]
  before_action :get_user, only: [:edit, :update]
  before_action :valid_link, only: [:edit, :update]

  def new
  end

  def create
    user = User.find_by(email: params[:password_reset][:email])
    if user
      user.create_password_reset_digest
      user.update_attribute(:password_reset_sent_at, Time.zone.now)
      UserMailer.password_reset(user).deliver_now
      flash[:info] = "Vui long kiem tra email cua ban de nhan link dat lai mat khau!"
      redirect_to root_url
    else
      flash[:warning]= "User khong ton tai!"
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @user && @user.authenticated?(:password_reset, params[:id])
      if @user.update(user_params)
        @user.update_attribute(:password_reset_sent_at, nil)
        log_in @user
        flash[:success] = "Dat lai mat khau thanh cong!"
        redirect_to @user
      else
        flash[:warning] = "Dat lai mat khau khong thanh cong!"
        render :edit
      end
    else
      flash[:warning]= "Link dat lai mat khau khong kha dung!"
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def user_activated
    return if @user.activated?
    flash[:warning] = "Tai khoan chua duoc kich hoat"
    redirect_to root_url
  end

  def valid_link
    return unless @user.check_expiration
    flash[:warning]= "Link dat lai mat khau khong kha dung!"
    redirect_to root_url
  end

end
