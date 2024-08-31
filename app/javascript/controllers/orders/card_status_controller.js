import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["statusInput"];

  submit(e) {
    e.preventDefault();
    const path = e.detail.url.origin + e.detail.url.pathname + "?modal=yes";
    const statusChecked = this.statusInputTargets.find((el) => el.checked);

    const formData = new FormData();
    formData.append("order[order_status_id]", statusChecked.value);

    fetch(path, {
      method: "PATCH",
      body: formData,
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
    })
      .then((res) => {
        if (res.ok) this.element.close();
        return res.text();
      })
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
