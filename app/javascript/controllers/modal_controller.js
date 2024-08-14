// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "modal",
    "spinner",
    "file",
    "openModal",
    "closeModal",
    "previewFile",
  ];

  open() {
    const modal = this.element.closest(".modal");
    modal.style.display = "block";
    this.spinnerTarget.style.display = "block";
    this.modalContentTarget.style.display = "none";
  }

  close() {
    const modal = this.element.closest(".modal");
    modal.style.display = "none";
    this.spinnerTarget.style.display = "none";
  }

  showContent() {
    this.spinnerTarget.style.display = "none";
    this.modalContentTarget.style.display = "block";
  }
}
