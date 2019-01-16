class SessionsController < ApplicationController
  before_action :log_in_user, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:success] = "Dang nhap thanh cong!"
      redirect_to @user
    else
      flash[:warning] = "Dang nhap khong thanh cong!"
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end

  private

  def log_in_user
    return unless logged_in?
    flash[:warning] = "Ban khong co quyen truy cap!"
    redirect_to current_user
  end


end
