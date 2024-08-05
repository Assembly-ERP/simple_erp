// app/javascript/controllers/index.js
import { application } from "../application"
import ModalController from "./modal_controller";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"



eagerLoadControllersFrom("controllers", application)

application.register("modal", ModalController);

