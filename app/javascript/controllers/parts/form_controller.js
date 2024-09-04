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
      this.priceTarget.disabled = false;
      this.priceTarget.required = true;
      return;
    }
    this.priceTarget.disabled = true;
    this.priceTarget.required = false;
  }

  inventoryToggle(e) {
    if (e.target.checked) {
      this.instockTarget.disabled = false;
      return;
    }
    this.instockTarget.disabled = true;
  }
}
