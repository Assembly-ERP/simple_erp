import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading";
import { application } from "controllers/application"
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
lazyLoadControllersFrom("controllers", application);

// Eager load all controllers defined in the import map under controllers/**/*_controller
// eagerLoadControllersFrom("controllers", application)
