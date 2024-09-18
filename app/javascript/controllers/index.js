import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading";
import { application } from "controllers/application";
import Notification from "@stimulus-components/notification";
import Dialog from "@stimulus-components/dialog";
import RailsNestedForm from "@stimulus-components/rails-nested-form";
import Dropdown from "@stimulus-components/dropdown";
import ColorPicker from "@stimulus-components/color-picker";

application.register("notification", Notification);
application.register("dialog", Dialog);
application.register("nested-form", RailsNestedForm);
application.register("dropdown", Dropdown);
application.register("color-picker", ColorPicker);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// lazyLoadControllersFrom("controllers", application);

// Eager load all controllers defined in the import map under controllers/**/*_controller
eagerLoadControllersFrom("controllers", application);
