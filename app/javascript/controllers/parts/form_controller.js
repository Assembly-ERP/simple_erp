import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "price",
    "instock",
    "inventory",
    "manualPrice",
    "instockDisplay",
    "priceDisplay",
    "staticPriceDisplay",
  ];

  connect() {
    this.manualPriceTarget.disabled = false;
    this.inventoryTarget.disabled = false;
  }

  overrideToggle(e) {
    if (e.target.checked) {
      this.priceDisplayTarget.classList.remove("hidden");
      this.staticPriceDisplayTarget.classList.add("hidden");
      this.priceTarget.disabled = false;
      this.priceTarget.required = true;
      return;
    }
    this.priceDisplayTarget.classList.add("hidden");
    this.staticPriceDisplayTarget.classList.remove("hidden");
    this.priceTarget.disabled = true;
    this.priceTarget.required = false;
  }

  inventoryToggle(e) {
    if (e.target.checked) {
      this.instockDisplayTarget.classList.remove("hidden");
      this.instockTarget.disabled = false;
      return;
    }
    this.instockDisplayTarget.classList.add("hidden");
    this.instockTarget.disabled = true;
  }
}
