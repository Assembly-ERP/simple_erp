import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["target", "template", "addedPart"];

  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  };

  add(e) {
    e.preventDefault();

    e.target.classList.remove("bg-[color:var(--primary)]");
    e.target.classList.add("bg-[color:var(--secondary)]");
    e.target.innerHTML = "Update";

    const dataset = e.target.dataset;
    const checkedPart = this.checkPart(dataset.partId);

    if (checkedPart) {
      if (this.isNewPart) this.appendPart(dataset, checkedPart);
      else {
        /* update via turbo-stream*/
      }
      return;
    }

    this.appendPart(dataset);
  }

  appendPart(dataset, replaceEl = null) {
    const totalPrice = (
      Number(dataset.price) * Number(dataset.quantity)
    ).toFixed(2);

    let template = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime().toString())
      .replace("{{name}}", dataset.name)
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace("{{price}}", totalPrice)
      .replace(/{{part-id}}/g, dataset.partId);

    if (!replaceEl)
      this.targetTarget.insertAdjacentHTML("beforebegin", template);
    else replaceEl.outerHTML = template;

    const event = new CustomEvent("rails-nested-form:add", { bubbles: !0 });
    this.element.dispatchEvent(event);
  }

  remove(e) {
    e.preventDefault();

    const closest = e.target.closest(this.wrapperSelectorValue);

    if (closest.dataset.newRecord === "true") t.remove();
    else {
      closest.style.display = "none";
      const destroy = closest.querySelector("input[name*='_destroy']");
      destroy.value = "1";
    }

    const event = new CustomEvent("rails-nested-form:remove", { bubbles: !0 });
    this.element.dispatchEvent(event);
  }

  checkPart(id) {
    return document.querySelector(`[id='part-form-${id}']`);
  }

  get isNewPart() {
    return this.element.dataset.isNew == "true";
  }
}
