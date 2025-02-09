import { Controller } from "@hotwired/stimulus"

// Conecta ao data-controller="mark"
export default class extends Controller {
  static targets = ["star", "mark"]

  connect() {
    this.updateStars();
  }

  updateStars() {
    // Pega o valor de avaliação do comentário
    const mark = Math.round(parseFloat(this.markTarget.textContent.trim()));

    // Atualiza as estrelas com base no valor da avaliação
    this.starTargets.forEach((star, index) => {
      if (index < mark) {
        star.classList.add("text-yellow-400"); // Estrela preenchida
        star.classList.remove("text-gray-400"); // Estrela vazia
      } else {
        star.classList.add("text-gray-400"); // Estrela vazia
        star.classList.remove("text-yellow-400"); // Estrela preenchida
      }
    });
  }
}
