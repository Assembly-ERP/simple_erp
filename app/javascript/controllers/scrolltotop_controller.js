import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.scrollTo({ top: 0, behavior: "smooth" });
  }
}
