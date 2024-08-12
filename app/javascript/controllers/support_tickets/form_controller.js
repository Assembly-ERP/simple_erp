import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["userSelection"];

  customerChanged(e) {
    this.userSelectionTarget.disabled = true;
    const path = `${this.baseURL}/operational_portal/support_tickets/form_user_selection?customer_id=${e.target.value}`;

    fetch(path, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
    })
      .then((res) => res.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  get baseURL() {
    return location.origin;
  }

  get supportTickerId() {
    return "";
  }
}
