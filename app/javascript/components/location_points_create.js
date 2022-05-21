import h from "./htm_create_element"

export const locationPointsCreate = (...props) => {
  const [containers, locations, zoomLevel, srcCoord, setViewData, setShowFlag] = props
  const headerHeight = document.getElementById("header").clientHeight
  let chgLocations   = {}

  const correctionValX = 3585
  const correctionValY = 2252
  const correctionMag  = 2.89
  const icon_width  = 30
  const icon_height = 30

  // drawImageのsx,sy,sw,shおよびアイコンのサイズをもとに、描画対象の連想配列を作成する
  Object.keys(locations).map(key => {
    const location_x = (locations[key]["x_coordinate"] * correctionMag) + correctionValX
    const location_y = (-locations[key]["y_coordinate"] * correctionMag) + correctionValY
    if (
      srcCoord["x"] <= location_x - (icon_width / 2) &&
      srcCoord["y"] <= location_y - (icon_height / 2) &&
      srcCoord["x"] + srcCoord["width"]  >= location_x + (icon_width / 2) &&
      srcCoord["y"] + srcCoord["height"] >= location_y + (icon_height / 2)
    ) {
      chgLocations[key] = { ...locations[key] }
      chgLocations[key]["x_coordinate"] = location_x
      chgLocations[key]["y_coordinate"] = location_y
    }
  })

  const changeViewData = (e) => {
    setViewData(e),
    setShowFlag(true)
  }

  return h`
    <style>
      ${Object.keys(chgLocations).map(key => `
        .location_point_${key} {
          top:  ${(chgLocations[key]["y_coordinate"] - srcCoord["y"]) * zoomLevel - icon_height / 2 + headerHeight}px;
          left: ${(chgLocations[key]["x_coordinate"] - srcCoord["x"]) * zoomLevel - icon_width / 2}px;
        }
      `)}
    </style>
    <div>
      ${Object.keys(chgLocations).map(key => h`
        <button
          type="button"
          class="location_point_${key} location_icon btn_reset"
          onClick=${() =>
            changeViewData({
              "locationId": key ,
              "locationImage": {
                "containerName": containers[locations[key]["container_id"]]["name"],
                "nearView":     chgLocations[key]["near_view"],
                "distantView":  chgLocations[key]["distant_view"],
                "animationGif": chgLocations[key]["animation_gif"]
              }
            })
          }
        >
          <img
            src=${containers[locations[key]["container_id"]]["image"]}
            class="location_icon_img"
            width="${icon_width}"
            height="${icon_height}"
            alt="container location"
          />
        </button>
      `)}
    </div>
  `
}
