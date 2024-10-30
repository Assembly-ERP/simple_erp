import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["image"];

  logoHandler(event) {
    const imageEl = this.imageTarget;
    const reader = new FileReader();
    reader.onload = () => (imageEl.src = reader.result);
    reader.readAsDataURL(event.target.files[0]);
  }
}
