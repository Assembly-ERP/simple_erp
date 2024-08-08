import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["price", "manualPrice", "instock", "inventory"];

  connect() {
    this.manualPriceTarget.disabled = false;
    this.inventoryTarget.disabled = false;
  }

  overrideToggle(e) {
    if (e.target.checked) {
      this.priceTarget.readOnly = false;
      this.priceTarget.required = true;
      return;
    }
    this.priceTarget.readOnly = true;
    this.priceTarget.required = false;
    this.priceTarget.value = null;
  }

  inventoryToggle(e) {
    if (e.target.checked) {
      this.instockTarget.readOnly = false;
      return;
    }
    this.instockTarget.readOnly = true;
    this.instockTarget.value = null;
  }
}
