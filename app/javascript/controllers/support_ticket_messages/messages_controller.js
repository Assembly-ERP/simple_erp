import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  submitEnd(event) {
    if (event.detail.success) {
      const trixElContent = this.element.querySelector(
        "#support_ticket_message_body",
      );

      trixElContent.innerHTML = "";
    }
  }
}
