import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["target", "template", "addedList"];

  static values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  };

  add(e) {
    e.preventDefault();
    const dataset = e.target.dataset;
    const totalPrice = (
      Number(dataset.price) * Number(dataset.quantity)
    ).toFixed(2);

    let template = this.templateTarget.innerHTML
      .replace(/NEW_RECORD/g, new Date().getTime().toString())
      .replace("{{name}}", dataset.name)
      .replace(/{{quantity}}/g, dataset.quantity)
      .replace("{{price}}", totalPrice)
      .replace("{{part-id}}", dataset.partId);

    this.targetTarget.insertAdjacentHTML("beforebegin", template);
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
}
