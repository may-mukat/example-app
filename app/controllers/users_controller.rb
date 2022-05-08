class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_user, :auth_user, only: [:show, :edit, :update, :destroy]

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

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "「#{@user.email}」を更新しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.update_attribute(:delete_flag, true)
      redirect_to new_user_url, status: :see_other, notice: "「#{@user.email}」のアカウントを削除しました。"
    end
  end

  private

    def user_params
      params.require(:user).permit(:id, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.where(delete_flag: false).find(params[:id])
    end

    def auth_user
      redirect_to root_path unless set_user == current_user
    end
end
