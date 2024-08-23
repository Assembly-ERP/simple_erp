import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["items", "searchInput", "searchByRadio"];

  // Search
  search() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {}, 400);
  }

  searchBy(e) {
    this.searchInputTarget.placeholder = `Search ${e.target.value}`;
    this.searchInputTarget.value = "";
  }

  get searchByValue() {
    return this.searchByRadioTargets.filter((radio) => radio.checked)[0].value;
  }
}
