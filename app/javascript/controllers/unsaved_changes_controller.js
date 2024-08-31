import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    leaveMessage: {
      type: String,
      default:
        "Your changes will be lost. Are you sure you want to leave this page?",
    },
  };

  formIsChanged() {
    this.element.dataset.changed = "true";
  }

  leavingPage(event) {
    if (!this.isFormChanged) return;
    if (
      event.type == "turbo:before-visit" &&
      !window.confirm(this.leaveMessageValue)
    ) {
      event.preventDefault();
      return;
    }

    event.returnValue = this.leaveMessageValue;
    return event.returnValue;
  }

  reset() {
    this.element.dataset.changed = "false";
  }

  get isFormChanged() {
    return this.element.dataset.changed === "true";
  }
}
