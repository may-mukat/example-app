class Admin::MapsController < ApplicationController
  before_action :admin_required
  before_action :set_map, only: [:show, :edit, :update, :destroy]

  def index
    @maps = Map.all.order(:id)
  end

  def new
    @map = Map.new
  end

  def create
    @map = Map.new(map_params)

    if @map.save
      redirect_to admin_maps_path(@map), notice: "「#{@map.name}」を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @map.update(map_params)
      redirect_to admin_map_path(@map), notice: "「#{@map.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    redirect_to admin_maps_path, status: :see_other, notice: "「#{@map.name}」を削除しました。" if @map.destroy
  end

  private
    def set_map
      @map = Map.find_by(name: params[:id])
    end

    def map_params
      params.require(:map).permit(:name, :map_image)
    end
end
