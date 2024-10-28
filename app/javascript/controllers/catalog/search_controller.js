import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "input",
    "filterByRadio",
    "minPrice",
    "maxPrice",
    "minWeight",
    "maxWeight",
    "categoryList",
  ];

  search() {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      this.searchExec();
    }, 400);
  }

  searchExec() {
    let path = this.element.dataset.url;
    const searchValue = this.inputTarget.value;

    if (path.includes("?")) path += `&search=${searchValue}`;
    else path += `?search=${searchValue}`;

    path += `&search_by[]=name`;
    path += `&search_by[]=sku`;
    path += `&filter_by=${this.filterByValue}`;

    if (this.maxPriceTarget.value) {
      path += `&min_price=${this.minPriceTarget.value || 0}`;
      path += `&max_price=${this.maxPriceTarget.value}`;
    }

    if (this.maxWeightTarget.value) {
      path += `&min_weight=${this.minWeightTarget.value || 0}`;
      path += `&max_weight=${this.maxWeightTarget.value}`;
    }

    if (this.checkedCategory.length > 0) {
      for (const category of this.checkedCategory) {
        path += `&category[]=${category}`;
      }
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
  }

  get filterByValue() {
    return this.filterByRadioTargets.filter((radio) => radio.checked)[0].value;
  }

  get checkedCategory() {
    return Array.from(this.element.querySelectorAll(`[id*='category-item-']`))
      .filter((item) => item.checked)
      .map((item) => item.value);
  }
}
