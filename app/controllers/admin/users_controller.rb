class Admin::UsersController < ApplicationController
  before_action :admin_required
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.where(delete_flag: false).order(:id)
  end

  def show
  end

  def edit
  end

  def update
    if @user.admin_flag
      @user.update_attribute(:admin_flag, false)
    else
      @user.update_attribute(:admin_flag, true)
    end
    redirect_to edit_admin_user_path(@user), notice: "「#{@user.email}」の権限を変更しました。"
  end

  def destroy
    if @user.update_attribute(:delete_flag, true)
      redirect_to admin_users_path, status: :see_other, notice: "「#{@user.email}」を削除しました。"
    end
  end

  private
    def set_user
      @user = User.where(delete_flag: false).find(params[:id])
    end
end
