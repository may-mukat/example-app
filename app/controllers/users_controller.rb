class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, :auth_user,
    only: [
      :show, :edit_email, :edit_password, :deactive,
      :update_email, :update_password, :destroy
    ]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "「#{@user.email}」を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit_email
  end

  def edit_password
  end

  def deactive
  end

  def update_email
    if @user&.authenticate(user_params[:password])
      # バリデーションへ変更?
      if @user.email == user_params[:email]
        flash.now[:alert] = "現在メールアドレスと異なるメールアドレスを入力してください。"
        render :edit_email, status: :unprocessable_entity
      else
        @user.email = user_params[:email]
        if @user.save
          redirect_to user_path(@user), notice: "メールアドレスを更新しました。"
        else
          flash.now[:alert] = "メールアドレスが正しく変更されませんでした。"
          render :edit_email, status: :unprocessable_entity
      end
      end
    else
      flash.now[:alert] = "パスワードが正しくありません。"
      render :edit_email, status: :unprocessable_entity
    end
  end

  def update_password
    if @user&.authenticate(current_password[:current_password])
      if user_params[:password] != user_params[:password_confirmation]
        flash.now[:alert] = "新しいパスワードとパスワード確認が一致していません。"
        render :edit_password, status: :unprocessable_entity
      elsif @user&.authenticate(user_params[:password])
        flash.now[:alert] = "現在のパスワードと異なるパスワードを入力してください。"
        render :edit_password, status: :unprocessable_entity
      else
        @user.password = user_params[:password]
        if @user.save
          redirect_to user_path(@user), notice: "パスワードを更新しました。"
        else
          flash.now[:alert] = "パスワードが正しく変更されませんでした。"
          render :edit_password, status: :unprocessable_entity
        end
      end
    else
      flash.now[:alert] = "パスワードが正しくありません。"
      render :edit_password, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.update_attribute(:delete_flag, true)
      reset_session
      redirect_to new_user_path, status: :see_other, notice: "「#{@user.email}」のアカウントを削除しました。"
    else
      render :deactive, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation)
    end

    def current_password
      params.require(:user).permit(:current_password)
    end

    def set_user
      @user = User.where(delete_flag: false).find(params[:id])
    end

    def auth_user
      redirect_to root_path unless set_user == current_user
    end
end
