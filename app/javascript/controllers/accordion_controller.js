import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content", "iconDown"];

  connect() {
    if (this.element.dataset.open === "false") {
      this.contentTarget.classList.add("hidden");
      this.iconDownTarget.classList.remove("rotate-180");
      return;
    }
    this.contentTarget.classList.remove("hidden");
    this.iconDownTarget.classList.add("rotate-180");
  }

  toggle() {
    if (this.contentTarget.classList.contains("hidden")) {
      this.contentTarget.classList.remove("hidden");
      this.iconDownTarget.classList.add("rotate-180");
      return;
    }
    this.contentTarget.classList.add("hidden");
    this.iconDownTarget.classList.remove("rotate-180");
  }
}
