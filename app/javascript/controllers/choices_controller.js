import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["select"];

  connect() {
    this.choices = new Choices(this.selectTarget, {
      shouldSort: false,
      removeItemButton: this.selectTarget.multiple,
    });
  }

  disconnect() {
    this.choices.destroy();
  }
}
