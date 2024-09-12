import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = [
    "customerDisplay",
    "firstName",
    "lastName",
    "phone",
    "email",
    "select",
    "cancel",
    "spinner",
    "role",
    "submit",
    "reset",
  ];

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

  submitStart() {
    this.spinnerTarget.classList.remove("hidden");
    this.submitTarget.disabled = true;
    this.resetTarget.disabled = true;
  }

  submitEnd(event) {
    this.spinnerTarget.classList.add("hidden");
    this.submitTarget.disabled = false;
    this.resetTarget.disabled = false;

    if (event.detail.success) {
      this.cancelTarget.click();
      this.reset();
    }
  }

  reset() {
    this.firstNameTarget.value = "";
    this.lastNameTarget.value = "";
    this.phoneTarget.value = "";
    this.emailTarget.value = "";
    this.selectTarget.value = "";
    this.roleTargets[0].checked = true;
    this.customerDisplayTarget.classList.add("hidden");
    this.selectTarget.required = false;
  }

  disconnect() {
    this.choices.destroy();
  }
}
