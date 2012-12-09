class HomeController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    else
        redirect_to stickers_path
    end
    @users = User.all
  end
end
