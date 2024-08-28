import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["staticPrice", "itemPrice", "total"];

  toggleInventory(e) {
    if (!e.target.checked) {
      this.staticPriceTarget.classList.remove("hidden");
      this.itemPriceTarget.parentElement.classList.add("hidden");
      return;
    }

    this.staticPriceTarget.classList.add("hidden");
    this.itemPriceTarget.parentElement.classList.remove("hidden");
  }

  priceChange(e) {
    const price = e.target.value || 0;
    const total = Number(price) * Number(this.element.dataset.qty);

    this.element.dataset.price = price;
    this.totalTarget.innerHTML =
      "$" +
      total.toLocaleString("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      });
  }
}
