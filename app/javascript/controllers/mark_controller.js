import { Controller } from "@hotwired/stimulus"

// Conecta ao data-controller="mark"
export default class extends Controller {
  static targets = ["star", "mark"]

  connect() {
    this.updateStars();
  }

  updateStars() {
    const mark = Math.round(parseFloat(this.markTarget.textContent.trim()));

    this.starTargets.forEach((star, index) => {
      if (index < mark) {
        star.classList.add("text-yellow-400");
        star.classList.remove("text-gray-400");
      } else {
        star.classList.add("text-gray-400");
        star.classList.remove("text-yellow-400");
      }
    });
  }
}
