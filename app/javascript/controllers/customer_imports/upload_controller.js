import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["upload", "dropArea", "files"];

  connect() {
    ["dragenter", "dragover", "dragleave", "drop"].forEach((el) => {
      this.dropAreaTarget.addEventListener(
        el,
        this.imageHandler.bind(this),
        false,
      );
    });
  }

  imageHandler(event) {
    event.preventDefault();
    event.stopPropagation();

    switch (event.type) {
      case "dragenter":
      case "dragover":
        event.target.classList.add("border-[color:var(--primary)]");
        event.target.classList.add("text-[color:var(--primary)]");
        break;
      case "dragleave":
      case "drop":
        event.target.classList.remove("border-[color:var(--primary)]");
        event.target.classList.remove("text-[color:var(--primary)]");
        if (event.type != "drop") return;
        this.uploadSheet(event.dataTransfer.files);
        break;
      case "input":
        this.uploadSheet(event.target.files);
        break;
      default:
        break;
    }
  }

  uploadSheet(files) {
    if (files.length > 1) {
      alert("Warning: Upload only one file");
      return;
    }

    if (!this.allowedFileTypes.includes(files[0].type)) {
      alert(
        `Warning: Invalid file type. Please upload (${this.uploadTarget.accept}) file.`,
      );
      return;
    }

    const uploadingEl = this.filesTarget;
    const identity = new Date().valueOf();

    const input = document.createElement("input");
    input.setAttribute("type", "file");
    input.setAttribute("class", "hidden");
    input.setAttribute("id", identity);
    input.setAttribute("name", "customer_import[sheet]");
    input.files = files;

    uploadingEl.innerHTML = "";
    uploadingEl.appendChild(input);

    this.element.requestSubmit();

    uploadingEl.innerHTML = "";
    this.uploadTarget.value = "";
  }

  get allowedFileTypes() {
    return this.uploadTarget.accept.split(", ");
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
