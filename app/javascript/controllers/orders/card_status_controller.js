import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["statusInput", "dialog", "display"];

  submit(e) {
    e.preventDefault();

    let path = e.detail.url.origin + e.detail.url.pathname;
    if (this.element.dataset.isModal === "true") path += "?modal=true";

    const formData = new FormData();
    formData.append("order[order_status_id]", this.statusChecked.value);

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
        if (res.ok) {
          this.dialogTarget.close();
          this.displayTarget.innerHTML = this.statusChecked.dataset.label;
          if (this.orderListItem)
            this.orderListItem.innerHTML = this.statusChecked.dataset.label;
        }
        return res.text();
      })
      .then((html) => Turbo.renderStreamMessage(html));
  }

  get orderListItem() {
    return document.querySelector(
      `[id='list-order-status-${this.element.dataset.orderId}']`,
    );
  }

  get statusChecked() {
    return this.statusInputTargets.find((el) => el.checked);
  }
}
