import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-toggle"
export default class extends Controller {
  static targets = ["input"];

  toggle(event) {
    const selectedIndex = event.target.selectedIndex;
    const totalOptions = event.target.options.length - 1;

    if (selectedIndex == totalOptions) {
      this.inputTarget.style.display = 'grid';
    } else {
      this.inputTarget.style.display = 'none';
    }
  }

}
