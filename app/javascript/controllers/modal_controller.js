import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  
  showModal(){
    this.modalTarget.showModal();
  }

  closeModal(){
    this.modalTarget.close();
  }
}
