import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapse"
export default class extends Controller {
  static targets = ["content", "button"]

  connect() {
    this.expanded = false
  }

  toggle() {
    this.expanded = !this.expanded
    this.contentTarget.classList.toggle("hidden")
    this.buttonTarget.textContent = this.expanded ? "Mostrar menos" : "Mostrar mais"
  }
}
