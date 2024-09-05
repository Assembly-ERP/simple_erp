import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.swiper = new Swiper(this.element, {
      loop: true,
      // If we need pagination
      pagination: {
        el: ".swiper-pagination",
      },
      // Navigation arrows
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  }
}
