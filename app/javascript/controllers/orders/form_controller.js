import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  static targets = [
    "items",
    "empty",
    "target",
    "template",
    "addedItems",
    "summaryPrice",
    "summaryShipping",
    "summaryDiscount",
    "summaryTax",
    "summarySubtotal",
    "summaryTotal",
    "searchItems",
    "searchInput",
    "searchByRadio",
    "userAssignee",
    "customerSelect",
  ];

  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  };

  connect() {
    this.customerSlim = new SlimSelect({ select: this.customerSelectTarget });
    this.userAssigneeSlim = new SlimSelect({
      select: this.userAssigneeTarget,
    });

    // this.customerSelectTarget.style = "opacity: 0; height: 65px;";
    // this.customerSelectTarget.classList.add("absolute", "top-0");
    // this.customerSelectTarget.removeAttribute("aria-hidden");
    this.calculateSummary(true);
  }

  customerChange(e) {
    this.userAssigneeSlim.disable();

    if (!e.target.value) {
      this.userAssigneeSlim.setData([{ text: "Select User", value: "" }]);
      return;
    }

    const customerUserPath = this.userAssigneeTarget.dataset.url;
    const path = customerUserPath.replace(":id", e.target.value);

    fetch(path, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
    })
      .then((res) => {
        if (res.ok) {
          this.userAssigneeSlim.enable();
        }
        return res.json();
      })
      .then((data) => this.addAssigneeOptions(data));
  }

  addAssigneeOptions(users) {
    if (!users.length > 0) return;
    let data = [{ text: "Select User", value: "" }];
    for (const user of users) data.push({ value: user.id, text: user.name });
    this.userAssigneeSlim.setData(data);
  }

  clearAssigneeOptions() {
    this.userAssigneeTarget.querySelectorAll("option").forEach((el) => {
      if (el.value) el.remove();
    });
  }

  calculateSummary(start = false) {
    this.element.dataset.changed = start ? "false" : "true";
    this.summaryPriceTarget.dataset.value = this.basePriceCalc;

    const price = Number(this.summaryPriceTarget.dataset.value);
    const shipping = Number(this.summaryShippingTarget.dataset.value);
    const discount = Number(this.summaryDiscountTarget.dataset.value);
    const tax = Number(this.summaryTaxTarget.dataset.value);

    const discountAmount = price * (discount / 100);
    const subtotal = price - discountAmount + tax;
    const total = subtotal + shipping;

    this.summarySubtotalTarget.dataset.value = subtotal;
    this.summaryTaxTarget.innerHTML = this.toLocalePrice(tax);
    this.summarySubtotalTarget.innerHTML = this.toLocalePrice(subtotal);
    this.summaryPriceTarget.innerHTML = this.toLocalePrice(price);
    this.summaryShippingTarget.innerHTML = this.toLocalePrice(shipping);
    this.summaryTotalTarget.innerHTML = this.toLocalePrice(total);
    this.summaryDiscountTarget.innerHTML = this.toLocalePrice(
      discountAmount,
      "-$",
    );
  }

  get basePriceCalc() {
    let sum = 0;
    for (const el of this.addedItems) {
      sum += Number(el.dataset.price) * Number(el.dataset.qty);
    }
    return sum;
  }

  discountInput(event) {
    if (Number(event.target.value) < 0)
      event.target.value = Math.abs(event.target.value);
    else if (Number(event.target.value) > 100) {
      event.target.value = 100;
    }

    this.summaryDiscountTarget.dataset.value = event.target.value;
    this.calculateSummary();
  }

  discountChange(event) {
    this.summaryDiscountTarget.dataset.value = event.target.value;
    event.target.value = this.toLocalePrice(
      Number(event.target.value) || 0,
      "",
    );
    event.target.blur();
    this.calculateSummary();
  }

  shippingInput(event) {
    if (Number(event.target.value) < 0)
      event.target.value = Math.abs(event.target.value);

    this.summaryShippingTarget.dataset.value = event.target.value;
    this.calculateSummary();
  }

  shippingChange(event) {
    this.summaryShippingTarget.dataset.value = event.target.value;
    event.target.value = this.toLocalePrice(
      Number(event.target.value) || 0,
      "",
    );
    event.target.blur();
    this.calculateSummary();
  }

  taxInput(event) {
    if (Number(event.target.value) < 0)
      event.target.value = Math.abs(event.target.value);

    this.summaryTaxTarget.dataset.value = event.target.value;
    this.calculateSummary();
  }

  taxChange(event) {
    event.target.value = this.toLocalePrice(
      Number(event.target.value) || 0,
      "",
    );
    event.target.blur();
    this.calculateSummary();
  }

  addToItem(e) {
    e.preventDefault();

    e.target.classList.remove("bg-[color:var(--primary)]");
    e.target.classList.add("bg-[color:var(--secondary)]");
    e.target.innerHTML = "Update";

    const dataset = e.target.dataset;
    const checkedItem = this.checkAddedItem(dataset.pid, dataset.type);

    if (checkedItem) {
      this.appendPart(dataset, checkedItem);
      return;
    }

    this.appendPart(dataset);
  }

  appendPart(dataset, replaceEl = null) {
    this.element.dataset.changed = "true";

    const itemPrice = Number(dataset.price).toLocaleString("en-US", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });
    const totalPrice = (
      Number(dataset.price) * Number(dataset.quantity)
    ).toLocaleString("en-US", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });

    let template = this.templateTarget.content
      .querySelector("tbody")
      .innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
      .replace(/{{id}}/g, dataset.itemId || "")
      .replace(/{{item-id}}/g, dataset.pid)
      .replace(/{{name}}/g, dataset.name)
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace(/{{type}}/g, dataset.type)
      .replace(/{{item-price}}/g, itemPrice)
      .replace(/{{price}}/g, totalPrice)
      .replace(/{{part-id}}/g, dataset.type === "part" ? dataset.pid : "")
      .replace(
        /{{product-id}}/g,
        dataset.type === "product" ? dataset.pid : "",
      );

    if (!replaceEl) this.targetTarget.insertAdjacentHTML("beforeend", template);
    else replaceEl.outerHTML = template;
    this.hideAndShowEmpty();
    this.calculateSummary();
  }

  remove(e) {
    e.preventDefault();

    const closest = e.target.closest(this.wrapperSelectorValue);

    if (closest.dataset.newRecord === "true") closest.remove();
    else {
      closest.classList.add("hidden");
      const destroy = closest.querySelector("input[name*='_destroy']");
      destroy.value = "1";
    }

    this.resetSearchItem(e.target.dataset.pid, e.target.dataset.type);
    this.hideAndShowEmpty();
    this.calculateSummary();
  }

  hideAndShowEmpty() {
    if (!this.addedItems.length) {
      this.emptyTarget.classList.remove("hidden");
      return;
    }
    this.emptyTarget.classList.add("hidden");
  }

  get addedItems() {
    return this.addedItemsTarget.querySelectorAll(".added-item:not(.hidden)");
  }

  resetSearchItem(id, type) {
    const checkedSearchPart = this.checkSearchItem(id, type);

    if (checkedSearchPart) {
      const input = checkedSearchPart.querySelector(
        `[id='search-item-qty_${type}_${id}']`,
      );

      const button = checkedSearchPart.querySelector(
        `[id='search-item-btn_${type}_${id}']`,
      );

      if (input) input.value = 1;
      if (button) {
        button.classList.remove("bg-[color:var(--secondary)]");
        button.classList.add("bg-[color:var(--primary)]");
        button.innerHTML = "Add";
        button.dataset.quantity = 1;
      }
    }
  }

  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      let path = this.searchInputTarget.dataset.url;

      if (path.includes("?")) path += `&search_by=${this.searchByValue}`;
      else path += `?search_by=${this.searchByValue}`;

      if (this.searchInputTarget.value) {
        path += `&search=${this.searchInputTarget.value}`;
        path += "&filter_by=name";
      }

      fetch(path, {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
      })
        .then((res) => res.text())
        .then((html) => Turbo.renderStreamMessage(html));
    }, 400);
  }

  searchBy(e) {
    this.searchInputTarget.placeholder = `Search ${e.target.value}`;
    this.searchInputTarget.value = "";
    this.search();
  }

  toLocalePrice(price, currency = "$") {
    return (
      currency +
      price.toLocaleString("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
    );
  }

  checkSearchItem(id, type) {
    return this.searchItemsTarget.querySelector(
      `[id='search-item_${type}_${id}']`,
    );
  }

  checkAddedItem(id, type) {
    return this.addedItemsTarget.querySelector(
      `[id='item-form-${type}_${id}']`,
    );
  }

  get searchByValue() {
    return this.searchByRadioTargets.filter((radio) => radio.checked)[0].value;
  }

  get checkAddedItems() {
    return this.addedItemsTarget.querySelectorAll("[id^=item-form-]");
  }

  disconnect() {
    this.customerSlim.destroy();
    this.userAssigneeSlim.destroy();
  }
}
