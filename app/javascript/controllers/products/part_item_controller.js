import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "quantity", "price", "add"];

  increment() {
    this.quantityTarget.stepUp();
    this.addTarget.dataset.quantity = this.quantityTarget.value;
  }

  decrement() {
    this.quantityTarget.stepDown();
    this.addTarget.dataset.quantity = this.quantityTarget.value;
  }

  quantityInput(event) {
    if (Number(event.target.value) < 0)
      event.target.value = Math.abs(event.target.value);
    else if (
      (event.target.value != "" || event.data == "e") &&
      Number(event.target.value) == 0
    )
      event.target.value = this.quantityTarget.min;

    this.addTarget.dataset.quantity = event.target.value;
  }

  quantityChange(event) {
    event.target.value = event.target.value || this.quantityTarget.min;
    event.target.blur();
  }
}
