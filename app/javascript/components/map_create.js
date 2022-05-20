import h from "./htm_create_element"
import { useState, useRef, useEffect } from "react"
import { canvasDraw, mapZoom, mapMove } from "./canvas"
import { locationViewCreate } from "./location_view_create"
import { locationPointsCreate } from "./location_points_create"

export const mapCreate = () => {
  const root = document.getElementById("view")
  if (root) {
    const [showFlag, setShowFlag]   = useState(false)
    const [viewData, setViewData]   = useState({})
    const [eleClient, setEleClient] = useState({ width: 0, height: 0 })
    const [srcCoord, setSrcCoord]   = useState({ x: 0, y: 0, width: 0, height: 0 })
    const [mousePos, setMousePos]   = useState({ x: 0, y: 0 })
    const [zoomLevel, setZoomLevel] = useState(1)
    const [moveFlag, setMoveFlag]   = useState(false)

    const [data] = useState(JSON.parse(document.getElementById("location_data_json").value))
    const [image]      = useState(data["map_image"])
    const [locations]  = useState(data["locations"])
    const [containers] = useState(data["containers"])
    const [loggedIn]   = useState(data["logged_in"])
    const [imageInst]  = useState(new Image())

    const mapRef = useRef(null)

    useEffect(() => {
      const observer = new ResizeObserver(() => {
        setEleClient({
          ...eleClient,
          width:  document.documentElement.clientWidth,
          height: document. documentElement.clientHeight - document.getElementById("header").clientHeight
        })
      })
      mapRef.current && observer.observe(mapRef.current)
      return () => { observer.disconnect() }
    }, [])

    // マップ画像がある時、下記それぞれを実行する
    // mapZoom()                スクロールした際にズームレベルに応じて拡大・縮小処理を行う
    // mapMove()                ドラッグ時のマウス移動に応じて、マップ画像の移動処理を行う
    // locationPointsCreate()   地点情報をもとに各座標地点に対象ルートコンテナのアイコン画像を配置する
    // locationViewCreate()     ルートコンテナアイコンをクリックした際にクリック対象に対応した画像を表示する
    if (image !== null) {
      useEffect(() => {
        setSrcCoord({ ...srcCoord, width: eleClient["width"], height: eleClient["height"] })
        canvasDraw(imageInst, image, srcCoord, setSrcCoord, srcCoord["x"], srcCoord["y"])
      }, [eleClient])

      return h`
        <div
          id="map"
          ref=${mapRef}
        >
          <canvas
            id="map_image"
            class="map_image"
            width=${eleClient["width"]}
            height=${eleClient["height"]}
            onWheel=${(e) => { mapZoom(e, imageInst, image, zoomLevel, setZoomLevel, srcCoord, setSrcCoord) }}
            onMouseMove=${(e) => { mapMove(e, imageInst, image, zoomLevel, srcCoord, setSrcCoord, mousePos, setMousePos, moveFlag) }}
            onMouseDown=${() => { setMoveFlag(true) }}
            onMouseUp=${() => { setMoveFlag(false) }}
            onMouseOut=${() => { setMoveFlag(false) }}
          >
            お使いのブラウザは動作対象外です。GoogleChrome最新版をお試しください。
          </canvas>
          ${locationPointsCreate(containers, locations, zoomLevel, srcCoord, setViewData, setShowFlag)}
          ${locationViewCreate(loggedIn, viewData, showFlag, setShowFlag)}
        </div>
      `
    } else {
      return h`
        <span class="d-block m-3">対象の地図画像が登録されていません。</span>
        <a href="#" class="d-block ms-3">管理者に登録するように要請してください。</a>
      `
    }
  }
}
