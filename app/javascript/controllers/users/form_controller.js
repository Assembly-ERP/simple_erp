import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["select", "customerDisplay"];

  connect() {
    this.choices = new Choices(this.selectTarget, {
      shouldSort: false,
      removeItemButton: this.selectTarget.multiple,
      position: "top",
    });
  }

  showCustomerInput() {
    this.customerDisplayTarget.classList.remove("hidden");
    this.selectTarget.required = true;
  }

  hideCustomerInput() {
    this.customerDisplayTarget.classList.add("hidden");
    this.selectTarget.required = false;
  }

  disconnect() {
    this.choices.destroy();
  }
}
