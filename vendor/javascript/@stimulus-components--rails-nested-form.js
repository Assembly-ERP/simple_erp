import { Controller as e } from "@hotwired/stimulus";
const t = class _RailsNestedForm extends e {
  add(e) {
    e.preventDefault();
    const t = this.templateTarget.innerHTML.replace(
      /NEW_RECORD/g,
      new Date().getTime().toString(),
    );
    this.targetTarget.insertAdjacentHTML("beforebegin", t);
    const r = new CustomEvent("rails-nested-form:add", { bubbles: !0 });
    this.element.dispatchEvent(r);
  }
  remove(e) {
    e.preventDefault();
    const t = e.target.closest(this.wrapperSelectorValue);
    if (t.dataset.newRecord === "true") t.remove();
    else {
      t.style.display = "none";
      const e = t.querySelector("input[name*='_destroy']");
      e.value = "1";
    }
    const r = new CustomEvent("rails-nested-form:remove", { bubbles: !0 });
    this.element.dispatchEvent(r);
  }
};
(t.targets = ["target", "template"]),
  (t.values = {
    wrapperSelector: { type: String, default: ".nested-form-wrapper" },
  });
let r = t;
export { r as default };
