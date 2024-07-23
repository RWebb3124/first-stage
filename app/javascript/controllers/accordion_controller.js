import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accordion"
export default class extends Controller {
  toggle(event) {
    const button = event.currentTarget
    button.classList.toggle("collapsed")
    const collapseTarget = document.querySelector(button.getAttribute("data-bs-target"))
    collapseTarget.classList.toggle("show")
  }
}
