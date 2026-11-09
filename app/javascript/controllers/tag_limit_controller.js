import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tag-limit"
// Stops more than `max` tag checkboxes being ticked. This only improves the UX;
// the real limit is the User#tags_within_limit validation on the server.
export default class extends Controller {
  static targets = ["checkbox"]
  static values = { max: Number }

  connect() {
    this.update()
  }

  // Runs on load and every time a checkbox changes.
  update() {
    const full = this.checkboxTargets.filter(box => box.checked).length >= this.maxValue

    this.checkboxTargets.forEach(box => {
      box.disabled = full && !box.checked
    })
  }
}
