import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {

  static targets = [ "startTime", "endTime" ]

  connect() {
    flatpickr(this.startTimeTarget, {
      enableTime: true,
      altInput: true
    })
    flatpickr(this.endTimeTarget, {
      enableTime: true,
      altInput: true
    })
  }
}
