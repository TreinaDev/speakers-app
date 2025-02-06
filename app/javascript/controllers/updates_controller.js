import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["updateDescription"]
  

  toggleUpdateDescription(event) {
    if (event.target.checked) {
      this.addUpdateDescriptionField();
    } else {
      this.removeUpdateDescriptionField();
    }
  }

  addUpdateDescriptionField() {
    if (this.updateDescriptionTarget.querySelector("#update_description_container")) {
      return;
    }

    const descriptionContainer = document.createElement("div");
    descriptionContainer.classList.add("field");
    descriptionContainer.setAttribute("id", "update_description_container");

    const descriptionLabel = document.createElement("label");
    descriptionLabel.setAttribute("for", "event_content_update_description");
    descriptionLabel.innerHTML = "Comentário da atualização";

    const descriptionField = document.createElement("input");
    descriptionField.classList.add("field-primary");
    descriptionField.setAttribute("id", "event_content_update_description");
    descriptionField.setAttribute("name", "event_content[update_description]");
    descriptionField.setAttribute("type", "text");
    descriptionField.setAttribute("placeholder", "Descreva as mudanças no conteúdo");

    descriptionContainer.appendChild(descriptionLabel);
    descriptionContainer.appendChild(descriptionField);

    this.updateDescriptionTarget.appendChild(descriptionContainer);
  }

  removeUpdateDescriptionField() {
    const descriptionContainer = this.updateDescriptionTarget.querySelector("#update_description_container");
    if (descriptionContainer) {
      descriptionContainer.remove();
    }
  }
}