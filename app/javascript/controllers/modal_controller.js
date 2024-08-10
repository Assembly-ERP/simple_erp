// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "spinner", "file", "openModal", "closeModal", "previewFile"]

  connect() {
    console.log("Modal controller connected")
  }

  open() {
    console.log("Opening modal")
    const modal = this.element.closest(".modal")
    modal.style.display = "block"
    this.spinnerTarget.style.display = "block"
    this.modalContentTarget.style.display = "none"
  }

  close() {
    console.log("Closing modal")
    const modal = this.element.closest(".modal")
    modal.style.display = "none"
    this.spinnerTarget.style.display = "none"
  }

  showContent() {
    console.log("Showing content");
  console.log("Spinner Target: ", this.spinnerTarget);
  console.log("File Target: ", this.fileTarget);
    this.spinnerTarget.style.display = "none";
    this.modalContentTarget.style.display = "block";
  }

}
