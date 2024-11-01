import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["editor", "input"];

  connect() {
    this.quill = new Quill(this.editorTarget, { theme: "snow" });
    this.syncValue();
    this.quill.on("text-change", this.syncValue.bind(this));
  }

  syncValue() {
    this.inputTarget.value = this.quill.root.innerHTML;
  }
}
