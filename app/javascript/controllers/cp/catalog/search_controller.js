import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "filterByRadio"];

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
    // path += `&search_by[]=description`;
    // path += `&filter_by=${this.filterByValue}`;

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

  // get filterByValue() {
  //   return this.filterByRadioTargets.filter((radio) => radio.checked)[0].value;
  // }
}