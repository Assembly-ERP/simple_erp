import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  connect() {
    this.slim = new SlimSelect({ select: this.element });

    this.element.style = "opacity: 0; height: 65px;";
    this.element.classList.add("absolute", "top-0");
    this.element.removeAttribute("aria-hidden");
  }

  disconnect() {
    this.slim.destroy();
  }
}
