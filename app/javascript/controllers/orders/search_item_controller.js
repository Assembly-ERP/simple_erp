import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["quantity", "add"];

  connect() {
    this.checkIfExistOnItems();
  }

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

    this.addTarget.dataset.quantity = event.target.value;
  }

  checkIfExistOnItems() {
    const item = this.checkAddedItem(
      this.addTarget.dataset.pid,
      this.addTarget.dataset.type,
    );

    if (item) {
      this.addTarget.classList.remove("bg-[color:var(--primary)]");
      this.addTarget.classList.add("bg-[color:var(--secondary)]");
      this.addTarget.innerHTML = "Update";
      this.addTarget.dataset.quantity = item.dataset.qty;
      this.quantityTarget.value = item.dataset.qty;
    }
  }

  checkAddedItem(id, type) {
    return document.querySelector(`[id='item-form-${type}_${id}']`);
  }
}
