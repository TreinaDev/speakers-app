import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-modal"
export default class extends Controller {
  static targets = ["modal", "fullImage"]

  open(event) {
    const imageUrl = event.currentTarget.getAttribute("data-full-src")
    this.fullImageTarget.src = imageUrl
    this.modalTarget.classList.remove("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }
}
