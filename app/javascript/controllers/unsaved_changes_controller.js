import { Controller } from "@hotwired/stimulus";

const LEAVING_PAGE_MESSAGE =
  "You have attempted to leave this page. Your changes will be lost. Are you sure you want to exit this page?";

export default class extends Controller {
  formIsChanged() {
    this.element.dataset.changed = "true";
  }

  leavingPage(event) {
    if (this.isFormChanged) {
      if (event.type == "turbo:before-visit") {
        if (!window.confirm(LEAVING_PAGE_MESSAGE)) {
          event.preventDefault();
        }
      } else {
        event.returnValue = LEAVING_PAGE_MESSAGE;
        return event.returnValue;
      }
    }
  }

  reset() {
    this.element.dataset.changed = "false";
  }

  get isFormChanged() {
    return this.element.dataset.changed === "true";
  }
}
