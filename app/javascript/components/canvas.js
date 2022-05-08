export const canvasDraw = (imgInst, img, srcCoord, setSrcCoord, sx, sy, nextWidth=null, nextHeight=null) => {
  const canvas  = document.getElementById("map_image")
  if(canvas) {
    const ctx     = canvas.getContext("2d")
    const sw      = nextWidth  === null ? canvas.width : nextWidth
    const sh      = nextHeight === null ? canvas.height : nextHeight

    imgInst.addEventListener("load", () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      ctx.drawImage(imgInst, sx, sy, sw, sh, 0, 0, canvas.width, canvas.height)
    })
    imgInst.src = img
    setSrcCoord({ ...srcCoord, x: sx, y: sy, width: sw, height: sh })
  }
}

const coordinateCheck = (target, criteria) => {
  return Math.max(0, Math.min(target, criteria))
}

export const mapZoom = (...props) => {
  const [e, imgInst, img, zoomLevel, setZoomLevel, srcCoord, setSrcCoord] = props
  const maxZoom   = 5
  const minZoom   = 1
  const zoomValue = 0.1
  const canvas    = document.getElementById("map_image")
  let nextZoom

  // trueの場合ズームアウト、falseの場合ズームイン時の倍率を計算する
  if (0 < e.deltaY) {
    nextZoom = minZoom <= zoomLevel - zoomValue ? zoomLevel - zoomValue : zoomLevel
  } else {
    nextZoom = maxZoom >= zoomLevel + zoomValue ? zoomLevel + zoomValue : zoomLevel
  }
  nextZoom = Math.round(nextZoom * 10) / 10
  setZoomLevel(nextZoom)

  // 計算したズーム倍率、マウスの座標位置を共に、画像描画に必要なsx, sy, sw, shを計算する
  const nextWidth  = canvas.width / nextZoom
  const nextHeight = canvas.height / nextZoom
  const nextLeft = coordinateCheck(
    srcCoord["x"] + (e.clientX / zoomLevel) - (e.clientX / nextZoom),
    imgInst.width - nextWidth
  )
  const nextTop = coordinateCheck(
    srcCoord["y"] + (e.clientY / zoomLevel) - (e.clientY / nextZoom),
    imgInst.height - nextHeight
  )

  // setSrcCoord({ ...srcCoord, x: nextLeft, y: nextTop, width: nextWidth, height: nextHeight })
  canvasDraw(imgInst, img, srcCoord, setSrcCoord, nextLeft, nextTop, nextWidth, nextHeight)
  canvas.addEventListener("mousewheel", function(e) { e.preventDefault() }, { passive: false })
}

export const mapMove = (...props) => {
  const [e, imgInst, img, zoomLevel, srcCoord, setSrcCoord, mousePos, setMousePos, moveFlag] = props
  setMousePos({ ...mousePos, x: e.clientX, y: e.clientY })
  const canvas   = document.getElementById("map_image")

  // ドラッグ中のマウス移動を検知し、画像の描画位置変更のためのsx, sy, sw, shを計算する
  if (moveFlag) {
    const width    = canvas.width / zoomLevel
    const height   = canvas.height / zoomLevel
    const nextLeft = coordinateCheck(
      srcCoord["x"] + ((mousePos["x"] - e.clientX) / zoomLevel),
      imgInst.width - width
    )
    const nextTop  = coordinateCheck(
      srcCoord["y"] + ((mousePos["y"] - e.clientY) / zoomLevel),
      imgInst.height - height
    )

    // setSrcCoord({ ...srcCoord, x: nextLeft, y: nextTop, width: width, height: height })
    canvasDraw(imgInst, img, srcCoord, setSrcCoord, nextLeft, nextTop, width, height)
  }
}
