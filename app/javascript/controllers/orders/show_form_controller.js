import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["customer", "assignee"];

  connect() {
    this.customerInput = new Choices(this.customerTarget);
    this.assigneeInput = new Choices(this.assigneeTarget, {
      removeItemButton: true,
    });
  }

  disconnect() {
    this.customerInput.destroy();
    this.assigneeInput.destroy();
  }
}
