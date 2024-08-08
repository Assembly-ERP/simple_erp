import { Controller } from "@hotwired/stimulus";
import { useTransition } from "stimulus-use";

export default class extends Controller {
  static targets = ["arrow", "menu"];

  connect() {
    useTransition(this, { element: this.menuTarget });
  }

  toggle() {
    this.toggleTransition();
  }

  rotate() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.arrowTarget.classList.remove("rotate-90");
      return;
    }
    this.arrowTarget.classList.remove("rotate-90");
  }

  hide(e) {
    !this.element.contains(e.target) &&
      !this.menuTarget.classList.contains("hidden") &&
      this.leave();
  }
}
