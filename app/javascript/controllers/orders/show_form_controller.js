import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["assignee", "status"];

  submitOnChange(event) {
    event.target.form.requestSubmit();
    event.target.disabled = true;
  }
}
