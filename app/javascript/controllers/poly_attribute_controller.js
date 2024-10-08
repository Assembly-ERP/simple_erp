import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["staticLabel", "inputLabel"];

  editLabelToggle() {
    if (this.staticLabelTarget.classList.contains("hidden")) {
      this.staticLabelTarget.classList.remove("hidden");
      this.inputLabelTarget.classList.add("hidden");
      return;
    }

    this.staticLabelTarget.classList.add("hidden");
    this.inputLabelTarget.classList.remove("hidden");
  }
}
