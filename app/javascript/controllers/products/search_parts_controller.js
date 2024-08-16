import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["loadingTemplate", "filter"];

  connect() {
    this.loadingTemplate = this.loadingTemplateTarget.innerHTML;
  }

  search(e) {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      let path = this.element.dataset.url;

      if (e.target.value) {
        // search
        if (path.includes("?")) path += "&search=" + e.target.value;
        else path += "?search=" + e.target.value;

        // search by
        path += "&filter_by=name";
      }

      fetch(path, {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
      })
        .then((res) => res.text())
        .then((html) => Turbo.renderStreamMessage(html));
    }, 500);
  }
}
