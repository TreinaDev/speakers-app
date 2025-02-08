import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="collapse"
export default class extends Controller {
  static targets = ["content", "button"]

  connect() {
    this.expanded = false
    this.buttonTarget.classList.add("expanded")
  }

  toggle() {
    this.expanded = !this.expanded
    this.contentTarget.classList.toggle("hidden")
    this.buttonTarget.textContent = this.expanded ? "Mostrar menos" : "Mostrar mais"
    if (this.expanded) {
      this.buttonTarget.classList.add("contract")
      this.buttonTarget.classList.remove("expanded")
    } else {
      this.buttonTarget.classList.add("expanded")
      this.buttonTarget.classList.remove("contract")
    }
  }
}
