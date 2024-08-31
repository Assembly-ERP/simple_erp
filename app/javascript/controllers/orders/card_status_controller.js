import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  static targets = ["select"];

  connect() {
    this.selectSlim = new SlimSelect({ select: this.selectTarget });
  }

  populate() {
    const path = "";

    fetch(path, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
    })
      .then((res) => {
        return res.json();
      })
      .then((data) => console.log(data));
  }

  disconnect() {
    this.selectSlim.destroy();
  }
}
