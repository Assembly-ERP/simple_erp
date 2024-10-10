import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["quantity"];

  increment() {
    this.quantityTarget.stepUp();
  }

  decrement() {
    this.quantityTarget.stepDown();
  }

  quantityReset(event) {
    if (!event.detail.success) return;
    this.quantityTarget.value = this.quantityTarget.min;
  }

  quantityInput(event) {
    if (Number(event.target.value) < 0)
      event.target.value = Math.abs(event.target.value);
    else if (
      (event.target.value != "" || event.data == "e") &&
      Number(event.target.value) == 0
    )
      event.target.value = this.quantityTarget.min;
  }

  quantityChange(event) {
    event.target.value = event.target.value || this.quantityTarget.min;
    event.target.blur();
  }
}
