import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropArea", "fileSelected"];

  connect() {
    ["dragenter", "dragover", "dragleave", "drop"].forEach((el) => {
      this.dropAreaTarget.addEventListener(
        el,
        this.fileHandler.bind(this),
        false,
      );
    });
  }

  submitEnd(event) {
    if (event.detail.success) {
      const trixElContent = this.element.querySelector(
        "#support_ticket_message_body",
      );

      trixElContent.innerHTML = "";
      window.scrollTo({ top: document.body.scrollHeight });
    }
  }

  fileHandler(event) {
    event.preventDefault();
    event.stopPropagation();

    switch (event.type) {
      case "dragenter":
      case "dragover":
        break;
      case "dragleave":
      case "drop":
        if (event.type != "drop") return;
        this.displayFiles(event.dataTransfer.files);
        break;
      case "input":
        this.displayFiles(event.target.files);
        break;
      default:
        break;
    }
  }

  displayFiles(files) {
    this.fileSelectedTarget.innerText = files.length
      ? `${files.length} file(s) selected`
      : "Browse files";
  }

  disconnect() {
    ["dragenter", "dragover", "dragleave", "drop"].forEach((el) => {
      this.dropAreaTarget.removeEventListener(
        el,
        this.imageHandler.bind(this),
        false,
      );
    });
  }
}
