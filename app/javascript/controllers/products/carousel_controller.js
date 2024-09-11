import { Controller } from "@hotwired/stimulus";
import Swiper from "swiper";

export default class extends Controller {
  connect() {
    this.swiper = new Swiper(this.element, {
      pagination: {
        el: ".swiper-pagination",
      },
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  }

  disconnect() {
    this.swiper.destroy(true, true);
  }
}
