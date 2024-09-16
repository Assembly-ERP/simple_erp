import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submitBtn"];

  editing() {
    this.submitBtnTarget.disabled = false;
  }

  submitted(event) {
    if (!event.detail.success) return;
    this.submitBtnTarget.disabled = true;
  }
}
