class LocationsController < ApplicationController
  skip_before_action :login_required, only: [:index, :show]
  before_action :set_location, only: [:edit, :update, :destroy]

  def index
    @maps = Map.all.order(:id)
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user_id = current_user.id

    if @location.save
      map_name = Map.find(@location.map_id)
      redirect_to location_path(map_name)
    else
      render :new, status: :unprocessable_entity
    end

  end

  def show
    @map = Map.find_by(name: params[:id])

    # 受け取ったハッシュをJSONへ変換し、HTMLのInputタグを通してJSへ渡す
    @location_data_json = create_location_data(@map).to_json.html_safe
  end

  def edit
  end

  def update
    if @location.update(location_params)
      location_image_purge(@location.near_view, location_image_params[:near_view_isdelete])
      location_image_purge(@location.distant_view, location_image_params[:distant_view_isdelete])
      location_image_purge(@location.animation_gif, location_image_params[:animation_gif_isdelete])
      redirect_to location_path(@location.map)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @location.destroy
      redirect_to location_path(@location.map), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(
        :map_id, :x_coordinate, :y_coordinate, :loot_container_id,
        :near_view, :distant_view, :animation_gif
      )
    end

    def location_image_params
      params.require(:location).permit(
        :near_view_isdelete, :distant_view_isdelete, :animation_gif_isdelete
      )
    end

    def location_image_purge(image, isDelete)
      image.purge if "1" == isDelete && image.attached?
    end

    # 受け取ったMap情報をもとに、関連する画像URLや座標地点を格納したハッシュを作成
    def create_location_data(map_data)
      location_data = {
        map_image: nil,
        locations: {},
        containers: {},
        logged_in: current_user ? true : false,
      }

      if map_data.map_image.attached?
        location_data[:map_image] = url_for(map_data.map_image)
      end

      locations = map_data.location.all.order(:id)
      if locations
        locations.each do |location|
          location_data[:locations][location.id] = {
            x_coordinate: location.x_coordinate,
            y_coordinate: location.y_coordinate,
            container_id: location.loot_container_id,
            near_view:    location.near_view.attached? ?
              url_for(location.near_view) : "#",
            distant_view: location.distant_view.attached? ?
              url_for(location.distant_view) : "#",
            animation_gif: location.animation_gif.attached? ?
              url_for(location.animation_gif) : "#"
          }
        end
      end

      loot_containers = LootContainer.all.order(:id)
      if loot_containers
        loot_containers.each do |container|
          location_data[:containers][container.id] = {
            name: container.name,
            image: container.container_image.attached? ?
              url_for(container.container_image) : "#"
          }
        end
      end

      return location_data
    end
end
