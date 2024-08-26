import { Controller } from "@hotwired/stimulus";
import { openClassNames, closeClassNames } from "utils/drawer";

export default class extends Controller {
  open() {
    console.log(openClassNames, closeClassNames);
  }
}
