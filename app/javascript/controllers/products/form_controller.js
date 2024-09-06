import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "empty",
    "target",
    "template",
    "searchParts",
    "addedParts",
    "summaryTotalPrice",
    "summaryTotalSum",
    "summaryDiscount",
    "searchInput",
    "staticWeight",
    "staticPrice",
  ];

  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  };

  add(e) {
    e.preventDefault();

    e.target.classList.remove("bg-[color:var(--primary)]");
    e.target.classList.add("bg-[color:var(--secondary)]");
    e.target.innerHTML = "Update";

    const dataset = e.target.dataset;
    const checkedPart = this.checkPart(dataset.partId);

    if (checkedPart) {
      this.appendPart(dataset, checkedPart);
      return;
    }

    this.appendPart(dataset);
  }

  appendPart(dataset, replaceEl = null) {
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
      .replace(/{{name}}/g, dataset.name)
      .replace(/{{sku}}/g, dataset.sku || "N/A")
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace(/{{price}}/g, totalPrice)
      .replace(/{{price-per-item}}/g, Number(dataset.price).toFixed(2))
      .replace(/{{weight}}/g, Number(dataset.weight).toFixed(2))
      .replace(/{{part-id}}/g, dataset.partId);

    if (!replaceEl) {
      this.targetTarget.insertAdjacentHTML("beforeend", template);
    } else replaceEl.outerHTML = template;

    this.hideAndShowEmpty();
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

    this.resetSearchPart(e.target.dataset.partId);
    this.hideAndShowEmpty();
  }

  resetSearchPart(id) {
    const checkedSearchPart = this.checkSearchPart(id);

    if (checkedSearchPart) {
      const input = checkedSearchPart.querySelector(
        `[id='search-part-qty_part_${id}']`,
      );

      const button = checkedSearchPart.querySelector(
        `[id='search-part-btn-${id}']`,
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

  hideAndShowEmpty() {
    if (!this.addedParts.length) {
      this.emptyTarget.classList.remove("hidden");
      return;
    }
    this.emptyTarget.classList.add("hidden");
  }

  checkPart(id) {
    return this.addedPartsTarget.querySelector(`[id='part-form-${id}']`);
  }

  checkSearchPart(id) {
    return this.searchPartsTarget.querySelector(`[id='search-part-${id}']`);
  }

  get addedParts() {
    return this.addedPartsTarget.querySelectorAll(".added-part:not(.hidden)");
  }

  // search
  search(e) {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      let path = this.searchInputTarget.dataset.url;

      if (e.target.value) {
        // search
        if (path.includes("?")) path += "&search=" + e.target.value;
        else path += "?search=" + e.target.value;

        // search by
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
}
