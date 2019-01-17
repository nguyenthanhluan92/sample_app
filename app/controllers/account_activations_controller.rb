class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Kich hoat tai khoan thanh cong!"
      redirect_to user
    else
      flash[:warning] = "Link kich hoat tai khoan bi loi"
      redirect_to root_url
    end
  end

end
