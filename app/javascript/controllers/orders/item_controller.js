import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["staticPrice", "itemPrice", "total"];

  connect() {
    this.originalPrice = this.element.dataset.originalPrice;
    this.fallbackPrice = this.element.dataset.price;
  }

  toggleInventory(e) {
    if (!e.target.checked) {
      this.element.dataset.price = this.originalPrice;

      const total =
        Number(this.originalPrice) * Number(this.element.dataset.qty);

      this.totalTarget.innerHTML = this.toLocaPrice(total);
      this.staticPriceTarget.innerHTML = this.toLocaPrice(
        Number(this.originalPrice),
      );
      this.staticPriceTarget.classList.remove("hidden");
      this.itemPriceTarget.parentElement.classList.add("hidden");
      return;
    }

    this.element.dataset.price = this.fallbackPrice;
    const total =
      Number(this.element.dataset.price) * Number(this.element.dataset.qty);
    this.totalTarget.innerHTML = this.toLocaPrice(total);
    this.staticPriceTarget.classList.add("hidden");
    this.itemPriceTarget.parentElement.classList.remove("hidden");
  }

  toLocaPrice(value) {
    return (
      "$" +
      value.toLocaleString("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
    );
  }

  priceChange(e) {
    const price = e.target.value || 0;
    const total = Number(price) * Number(this.element.dataset.qty);

    this.element.dataset.price = price;
    this.fallbackPrice = price;
    this.totalTarget.innerHTML = this.toLocaPrice(total);
  }
}
