import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static target = ["updateDescriptions"]

  addUpdateDescriptionField() {
    const descriptionContainer = document.createElement("div");
    descriptionContainer.classList.add("mt-2 mb-5");
    
    const descriptionLabel = document.createElement("label");
    descriptionLabel.innerHTML = "Comentário da atualização";

    const descriptionField = document.createElement("input");
    descriptionField.classList.add("field-primary");
    descriptionField.setAttribute("id", "event_content_update_description");
    descriptionField.setAttribute("name", "event_content[update_description]");
    descriptionField.setAttribute("type", "text");
    descriptionField.setAttribute("placeholder", "Descreva as mudanças no conteúdo");
  }
}