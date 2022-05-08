class Admin::LootContainersController < ApplicationController
  before_action :admin_required
  before_action :set_container, only: [:show, :edit, :update, :destroy]

  def index
    @containers = LootContainer.all.order(:id)
  end

  def new
    @container = LootContainer.new
  end

  def create
    @container = LootContainer.new(container_params)

    if @container.save
      redirect_to admin_Loot_containers_path(@container), notice: "「#{@container.name}」を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @container.update(container_params)
      redirect_to admin_loot_container_path(@container), notice: "「#{@container.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    redirect_to admin_loot_containers_path, status: :see_other, notice: "「#{@container.name}」を削除しました。" if @container.destroy
  end

  private
    def set_container
      @container = LootContainer.find(params[:id])
    end

    def container_params
      params.require(:loot_container).permit(:name, :container_image)
    end
end
