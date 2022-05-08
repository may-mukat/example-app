import { render } from "react-dom"
import h from "./htm_create_element"
import { mapCreate } from "./map_create"

const root = document.getElementById("view")
if (root) {
  document.body.oncontextmenu = () => { return false }
  render(h`<${mapCreate} />`, root)
}
