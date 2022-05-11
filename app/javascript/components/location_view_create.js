import h from "./htm_create_element"

export const locationViewCreate = (...props) => {
  const [loggedIn, viewData, showFlag, setShowFlag] = props
  const { locationId, locationImage } = viewData
  const headerHeight = document.getElementById("header").clientHeight

  const imageCheck = (imageType, image) => {
    if (image != "#") {
      return h`
        <div class="mb-3">
          <span class="d-block mb-2">${imageType} View</span>
          <span class="d-block view-shadow"><img src=${image} class="w-100" alt="${imageType} Image"/></span>
        </div>
      `
    }
  }

  const locationImgCreate = (props) => {
    const { containerName, distantView, nearView, animationGif } = props
    return h`
      <h5 class="mb-3">${containerName ? containerName : "対象のマップ画像が存在しません"}</h5>
      ${imageCheck("Distant", distantView)}
      ${imageCheck("Near", nearView)}
      ${imageCheck("Animation", animationGif)}
    `
  }

  return h`${showFlag && h`
  <style>
    .location_view {
      top: ${headerHeight}px;
      height: ${document.documentElement.clientHeight - headerHeight}px;
    }
  </style>
    <div class="container-fluid location_view">
      <button
        id="closeButton"
        aria-label="Close"
        className="btn-close bg-light my-3 mx-2 position-absolute top-0 end-0"
        type="button"
        onClick=${() => setShowFlag(false)}
      ></button>
      <div class="mt-3 location_image">
        ${locationImgCreate(locationImage)}
      </div>
      ${loggedIn && h`
        <div>
          <a href="/locations/${locationId}/edit" class="btn btn-secondary ms-3">Edit Location</a>
        </div>
      `}
    </div>
  `}`
}
