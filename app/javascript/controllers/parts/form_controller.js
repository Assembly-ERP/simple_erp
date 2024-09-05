import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "price",
    "instock",
    "inventory",
    "manualPrice",
    "staticInstock",
    "staticPrice",
    "uploadingContainer",
    "uploading",
    "dropArea",
    "upload",
    "image",
    "weight",
  ];

  connect() {
    this.manualPriceTarget.disabled = false;
    this.inventoryTarget.disabled = false;

    ["dragenter", "dragover", "dragleave", "drop"].forEach((el) => {
      this.dropAreaTarget.addEventListener(
        el,
        this.imageHandler.bind(this),
        false,
      );
    });
  }

  calcByWeight() {
    const pricePerPound = Number(this.element.dataset.pricePerPound);
    const total = pricePerPound * Number(this.weightTarget.value);
    this.staticPriceTarget.innerHTML = this.toLocalePrice(total);
  }

  overrideToggle(e) {
    this.calcByWeight();
    if (e.target.checked) {
      this.priceTarget.disabled = false;
      this.priceTarget.required = true;
      this.priceTarget.classList.remove("hidden");
      this.staticPriceTarget.classList.add("hidden");
      return;
    }
    this.priceTarget.disabled = true;
    this.priceTarget.required = false;
    this.priceTarget.classList.add("hidden");
    this.staticPriceTarget.classList.remove("hidden");
  }

  inventoryToggle(e) {
    if (e.target.checked) {
      this.instockTarget.disabled = false;
      this.instockTarget.classList.remove("hidden");
      this.staticInstockTarget.classList.add("hidden");
      return;
    }
    this.instockTarget.disabled = true;
    this.instockTarget.classList.add("hidden");
    this.staticInstockTarget.classList.remove("hidden");
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
        this.displayImages(event.dataTransfer.files);
        break;
      case "input":
        this.displayImages(event.target.files);
        break;
      default:
        break;
    }
  }

  displayImages(files) {
    this.uploadingContainerTarget.classList.remove("hidden");
    const uploadingEl = this.uploadingTarget;

    for (let i = 0; i < files.length; i++) {
      const isFileAllowed = this.allowedFileTypes.includes(files[i].type);
      const reader = new FileReader();

      const container = document.createElement("div");
      container.classList.add("relative");

      reader.onload = (e) => {
        const img = new Image();
        img.src = e.target.result;
        img.classList.add(
          isFileAllowed ? "border-gray-300" : "border-red-600",
          "object-cover",
          "rounded-sm",
          "border",
          "h-24",
          "w-24",
        );

        container.appendChild(img);
        uploadingEl.appendChild(container);
      };

      reader.readAsDataURL(files[i]);
    }
  }

  get allowedFileTypes() {
    return this.uploadTarget.accept.split(", ");
  }

  toLocalePrice(price, currency = "$") {
    return (
      currency +
      price.toLocaleString("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      })
    );
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
