import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  connect() {
    this.slim = new SlimSelect({ select: this.element });
  }

  disconnect() {
    this.slim.destroy();
  }
}
