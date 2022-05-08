import h from "./htm_create_element"

export const locationViewCreate = (...props) => {
  const [loggedIn, viewData, showFlag, setShowFlag] = props
  const { locationId, locationImage } = viewData
  const headerHeight = document.getElementById("header").clientHeight

  const imageCheck = (imageType, image) => {
    if (image != "#") {
      return h`
        <div class="mb-3">
          <p class="mb-1">${imageType}</p>
          <img src=${image} class="w-100" alt="location ${imageType}"/>
        </div>
      `
    }
  }

  const locationImgCreate = (props) => {
    const { containerName, distantView, nearView, animationGif } = props
    return h`
      <div class="container-fluid mt-3 mb-3">
        <h5>${containerName ? containerName : "対象のデータが存在しません"}</h5>
      </div>
      <div class="container-fluid">
        ${imageCheck("Distant View", distantView)}
        ${imageCheck("Near View", nearView)}
        ${imageCheck("Animation GIF", animationGif)}
      </div>
    `
  }

  return h`${showFlag && h`
  <style>
    .location_view {
      top: ${headerHeight}px;
      height: ${document.documentElement.clientHeight - headerHeight}px;
    }
  </style>
    <div class="location_view">
      <div class="location_view_top"></div>
      <button
        id="closeButton"
        aria-label="Close"
        className="btn-close bg-light m-2 position-absolute top-0 end-0"
        type="button"
        onClick=${() => setShowFlag(false)}
      ></button>
      <div class="location_image">
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
