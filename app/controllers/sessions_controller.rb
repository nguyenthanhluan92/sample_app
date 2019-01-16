class SessionsController < ApplicationController
  before_action :log_in_user, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      session[:id] = @user.id
      log_in @user
      flash[:success] = "Dang nhap thanh cong!"
      redirect_to @user
    else
      flash[:warning] = "Dang nhap khong thanh cong!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Ban vua dang xuat thanh cong!"
    redirect_to root_url
  end

  private

  def log_in_user
    return unless logged_in?
    flash[:warning] = "Ban khong co quyen truy cap!"
    redirect_to current_user
  end


end
