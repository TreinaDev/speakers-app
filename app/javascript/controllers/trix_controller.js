import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("trix-initialize", () => {
      console.log("Trix foi inicializado!");
      setTimeout(() => this.translateTooltips(), 0);
    });

  }

  translateTooltips() {
    const tooltips = {
      bold: "Negrito",
      italic: "Itálico",
      strike: "Tachado",
      href: "Inserir Link",
      heading1: "Título",
      quote: "Citação",
      code: "Código",
      bullet: "Lista com Marcadores",
      number: "Lista Numerada",
      decreaseNestingLevel: "Diminuir Recuo",
      increaseNestingLevel: "Aumentar Recuo",
      attachFiles: "Anexar Arquivos",
      undo: "Desfazer",
      redo: "Refazer",
    };

    const buttons = this.element.closest("form").querySelectorAll(".trix-button");

    buttons.forEach((button) => {
      const action = button.dataset.trixAction || button.dataset.trixAttribute;
      if (tooltips[action]) {
        button.setAttribute("title", tooltips[action]);
        button.textContent = tooltips[action];
      }
    });
  }
}