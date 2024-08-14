import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadingTemplate"];

  connect() {
    this.loadingTemplate = this.loadingTemplateTarget.innerHTML;
  }

  search() {}
}
