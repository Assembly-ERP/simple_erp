import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["items", "searchInput", "searchByRadio"];

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
