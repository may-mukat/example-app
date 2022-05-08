import h from "./htm_create_element"

export const locationPointsCreate = (...props) => {
  const [containers, locations, zoomLevel, srcCoord, setViewData, showFlag, setShowFlag] = props
  const headerHeight = document.getElementById("header").clientHeight
  let chgLocations   = {}

  const correctionValX = 3585
  const correctionValY = 2252
  const correctionMag  = 2.89

  Object.keys(locations).map(key => {
    const location_x = (locations[key]["x_coordinate"] * correctionMag) + correctionValX
    const location_y = (-locations[key]["y_coordinate"] * correctionMag) + correctionValY
    // console.log("key", key)
    // console.log("origin_x", locations[key]["x_coordinate"])
    // console.log("origin_y", locations[key]["y_coordinate"])
    // console.log("hosei_x", location_x)
    // console.log("hosei_y", location_y)
    // console.log(srcCoord["x"])
    // console.log(srcCoord["y"])
    // console.log(srcCoord["x"] + srcCoord["width"])
    // console.log(srcCoord["y"] + srcCoord["height"])
    // console.log("---")
    if (
      srcCoord["x"] <= location_x &&
      srcCoord["y"] <= location_y &&
      srcCoord["x"] + srcCoord["width"]  >= location_x &&
      srcCoord["y"] + srcCoord["height"] >= location_y
    ) {
      chgLocations[key] = {...locations[key]}
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
          top:  ${(chgLocations[key]["y_coordinate"] - srcCoord["y"] + headerHeight) * zoomLevel}px;
          left: ${(chgLocations[key]["x_coordinate"] - srcCoord["x"]) * zoomLevel}px;
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
            width="30"
            height="auto"
            alt="container location"
          />
        </button>
      `)}
    </div>
  `
}
