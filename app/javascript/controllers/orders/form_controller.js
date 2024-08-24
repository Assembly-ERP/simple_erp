import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "items",
    "target",
    "template",
    "addedItems",
    "searchInput",
    "searchByRadio",
  ];

  addToItem(e) {
    e.preventDefault();

    e.target.classList.remove("bg-[color:var(--primary)]");
    e.target.classList.add("bg-[color:var(--secondary)]");
    e.target.innerHTML = "Update";

    const dataset = e.target.dataset;
    const checkedItem = this.checkAddedItem(dataset.itemId, dataset.type);

    if (checkedItem) {
      this.appendPart(dataset, checkedItem);
      return;
    }

    this.appendPart(dataset);
  }

  appendPart(dataset, replaceEl = null) {
    const totalPrice = (
      Number(dataset.price) * Number(dataset.quantity)
    ).toFixed(2);

    let template = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime().toString())
      .replace("{{id}}", dataset.itemId || "")
      .replace("{{name}}", dataset.name)
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace(/{{type}}/g, dataset.type)
      .replace(/{{item-price}}/g, dataset.price)
      .replace(/{{price}}/g, totalPrice)
      .replace(/{{weight}}/g, dataset.weight);

    if (!replaceEl)
      this.targetTarget.insertAdjacentHTML("beforebegin", template);
    else replaceEl.outerHTML = template;

    const event = new CustomEvent("rails-nested-form:add", { bubbles: !0 });
    this.element.dispatchEvent(event);
    // this.hideAndShowEmpty();
  }

  checkAddedItem(id, type) {
    return this.addedItemsTarget.querySelector(
      `[id='item-form-${type}_${id}']`,
    );
  }

  // Search
  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      let path = this.searchInputTarget.dataset.url;
      path += `?search_by=${this.searchByValue}`;

      if (this.searchInputTarget.value) {
        path += "&search=" + this.searchInputTarget.value;
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

  get searchByValue() {
    return this.searchByRadioTargets.filter((radio) => radio.checked)[0].value;
  }
}
