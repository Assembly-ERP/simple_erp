import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["customerSelect", "userSelect"];

  connect() {
    this.customerSlim = new Choices(this.customerSelectTarget);
    this.userSlim = new Choices(this.userSelectTarget);
  }

  customerChanged(e) {
    this.userSlim.disable();
    this.userSlim.clearStore();
    this.userSlim.setChoiceByValue("");
    this.userSelectTarget.value = "";

    if (!e.target.value) return;

    const path = this.element.dataset.customerUsersUrl.replace(
      ":id",
      e.target.value,
    );

    fetch(path, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
    })
      .then((res) => {
        if (res.ok) this.userSlim.enable();
        return res.json();
      })
      .then((data) => this.addAssigneeOptions(data));
  }

  get baseURL() {
    return location.origin;
  }

  addAssigneeOptions(users) {
    if (!users.length > 0) return;
    let data = [];
    for (const user of users)
      data.push({
        value: user.id,
        label: user.name,
      });

    this.userSlim.setValue(data);
  }

  disconnect() {
    this.customerSlim.destroy();
    this.userSlim.destroy();
  }
}
