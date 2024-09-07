import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["assignee"];

  connect() {
    this.assigneeInput = new Choices(this.assigneeTarget, {
      removeItemButton: true,
    });
  }

  disconnect() {
    this.assigneeInput.destroy();
  }
}
