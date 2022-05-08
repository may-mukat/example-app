class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
  end

  def create
    user = User.where(delete_flag: false).find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      flash.now[:error] = "メールアドレスまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
      reset_session
      redirect_to login_path, notice: 'ログアウトしました。'
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def redirect_to_root
      redirect_to login_path, notice: 'ログアウトしました。'
    end
end
