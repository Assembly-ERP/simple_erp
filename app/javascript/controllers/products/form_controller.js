import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "empty",
    "target",
    "template",
    "searchParts",
    "addedParts",
    "summaryTotalPrice",
    "summaryTotalSum",
    "summaryDiscount",
    "searchInput",
    "staticWeight",
    "staticPrice",
    "uploadingContainer",
    "uploading",
    "dropArea",
    "upload",
    "image",
    "weight",
    "iconTemplate",
  ];

  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  };

  connect() {
    ["dragenter", "dragover", "dragleave", "drop"].forEach((el) => {
      this.dropAreaTarget.addEventListener(
        el,
        this.imageHandler.bind(this),
        false,
      );
    });
  }

  add(e) {
    e.preventDefault();

    e.target.classList.remove("bg-[color:var(--primary)]");
    e.target.classList.add("bg-[color:var(--secondary)]");
    e.target.innerHTML = "Update";

    const dataset = e.target.dataset;
    const checkedPart = this.checkPart(dataset.partId);

    if (checkedPart) {
      this.appendPart(dataset, checkedPart);
      return;
    }

    this.appendPart(dataset);
  }

  appendPart(dataset, replaceEl = null) {
    const totalPrice = (
      Number(dataset.price) * Number(dataset.quantity)
    ).toLocaleString("en-US", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    });

    let template = this.templateTarget.content
      .querySelector("tbody")
      .innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
      .replace(/{{id}}/g, dataset.itemId || "")
      .replace(/{{name}}/g, dataset.name)
      .replace(/{{sku}}/g, dataset.sku || "N/A")
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace(/{{price}}/g, totalPrice)
      .replace(/{{price-per-item}}/g, Number(dataset.price).toFixed(2))
      .replace(/{{weight}}/g, Number(dataset.weight).toFixed(2))
      .replace(/{{part-id}}/g, dataset.partId);

    if (!replaceEl) {
      this.targetTarget.insertAdjacentHTML("beforeend", template);
    } else replaceEl.outerHTML = template;

    this.hideAndShowEmpty();
  }

  remove(e) {
    e.preventDefault();

    const closest = e.target.closest(this.wrapperSelectorValue);

    if (closest.dataset.newRecord === "true") closest.remove();
    else {
      closest.classList.add("hidden");
      const destroy = closest.querySelector("input[name*='_destroy']");
      destroy.value = "1";
    }

    this.resetSearchPart(e.target.dataset.partId);
    this.hideAndShowEmpty();
  }

  resetSearchPart(id) {
    const checkedSearchPart = this.checkSearchPart(id);

    if (checkedSearchPart) {
      const input = checkedSearchPart.querySelector(
        `[id='search-part-qty_part_${id}']`,
      );

      const button = checkedSearchPart.querySelector(
        `[id='search-part-btn-${id}']`,
      );

      if (input) input.value = 1;
      if (button) {
        button.classList.remove("bg-[color:var(--secondary)]");
        button.classList.add("bg-[color:var(--primary)]");
        button.innerHTML = "Add";
        button.dataset.quantity = 1;
      }
    }
  }

  hideAndShowEmpty() {
    if (!this.addedParts.length) {
      this.emptyTarget.classList.remove("hidden");
      return;
    }
    this.emptyTarget.classList.add("hidden");
  }

  checkPart(id) {
    return this.addedPartsTarget.querySelector(`[id='part-form-${id}']`);
  }

  checkSearchPart(id) {
    return this.searchPartsTarget.querySelector(`[id='search-part-${id}']`);
  }

  get addedParts() {
    return this.addedPartsTarget.querySelectorAll(".added-part:not(.hidden)");
  }

  // search
  search(e) {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(() => {
      let path = this.searchInputTarget.dataset.url;

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
    }, 400);
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
      if (!isFileAllowed) return;

      const parser = new DOMParser();
      const reader = new FileReader();

      const identity = new Date().valueOf();

      const container = document.createElement("div");
      container.classList.add("relative");
      container.setAttribute("data-parts--form-target", "image");
      container.setAttribute("data-identity", identity);

      const removeBtn = document.createElement("button");
      removeBtn.setAttribute("data-identity", identity);
      removeBtn.setAttribute("data-signed", "false");
      removeBtn.setAttribute("data-action", "click->parts--form#removeImage");
      removeBtn.setAttribute("type", "button");
      removeBtn.classList.add("absolute", "top-1", "right-1");
      const icon = parser.parseFromString(
        this.iconTemplateTarget.innerHTML,
        "text/html",
      );
      removeBtn.appendChild(icon.body.firstChild);

      const input = document.createElement("input");
      input.setAttribute("type", "file");
      input.setAttribute("class", "hidden");
      input.setAttribute("id", identity);
      input.setAttribute("name", "product[images][]");
      input.setAttribute("multiple", "");

      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(files[i]);

      input.files = dataTransfer.files;

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
        container.appendChild(removeBtn);
        container.appendChild(input);
        uploadingEl.appendChild(container);
      };

      reader.readAsDataURL(files[i]);
    }

    this.uploadTarget.value = "";
  }

  removeImage(e) {
    const image = this.findImageEl(e.target.dataset.identity);
    if (image) image.remove();
  }

  get allowedFileTypes() {
    return this.uploadTarget.accept.split(", ");
  }

  findImageEl(identity) {
    return this.imageTargets.find(
      (image) => image.dataset.identity === identity,
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
