class ApplicationController < ActionController::Base
  include SessionsHelper

  def authenticate
    return if logged_in?
    flash[:warning] = "Ban khong co quyen truy cap!"
    redirect_to root_url
  end

end
