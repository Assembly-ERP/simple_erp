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
    "error",
  ];

  connect() {
    this.choices = new Choices(this.selectTarget, {
      shouldSort: false,
      removeItemButton: this.selectTarget.multiple,
      position: "top",
    });
    this.collectInitData();
  }

  collectInitData() {
    this.firstNameInit = this.firstNameTarget.value;
    this.lastNameInit = this.lastNameTarget.value;
    this.phoneInit = this.phoneTarget.value;
    this.emailInit = this.emailTarget.value;
    this.customerInit = this.selectTarget.value;
    this.roleIndexInit = this.roleTargets.findIndex((target) => target.checked);
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
    this.cancelTarget.disabled = true;
  }

  submitEnd(event) {
    this.spinnerTarget.classList.add("hidden");
    this.submitTarget.disabled = false;
    this.resetTarget.disabled = false;
    this.cancelTarget.disabled = false;

    if (event.detail.success) {
      if (this.element.dataset.isNew == "true") {
        this.cancelTarget.click();
      } else {
        this.collectInitData();
      }
      this.reset();
    }
  }

  reset() {
    this.firstNameTarget.value = this.firstNameInit;
    this.lastNameTarget.value = this.lastNameInit;
    this.phoneTarget.value = this.phoneInit;
    this.emailTarget.value = this.emailInit;
    this.selectTarget.value = this.customerInit;
    this.roleTargets[this.roleIndexInit].checked = true;
    this.errorTarget.classList.add("hidden");

    if (!this.roleTargets[this.roleIndexInit].value.includes("customer")) {
      this.hideCustomerInput();
    }
  }

  disconnect() {
    this.choices.destroy();
  }
}
