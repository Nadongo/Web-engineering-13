class SessionsController < ApplicationController
  def new
  end

  def create
  end

  def destroy
  end
end
class SessionsController < ApplicationController
  # Prevent logged-in users from seeing the login page
  before_action :forbid_login_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # Verify user exists AND password is correct
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが間違っています'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: 'ログアウトしました'
  end

  private

  def forbid_login_user
    if logged_in?
      redirect_to tasks_path, notice: 'ログアウトしてください'
    end
  end
end