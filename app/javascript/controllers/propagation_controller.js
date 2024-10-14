import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  ignore(event) {
    // event.preventDefault();
    event.stopPropagation();
  }
}
