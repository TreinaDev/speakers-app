import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ['active', 'unactive']
  static targets = ["btn", "tab"]
  static values = { defaultTab: String }

  connect() {
    let storedTab = localStorage.getItem('selectedTab') || this.defaultTabValue;
    this.showTab(storedTab);
  }

  select(event) {
    let selectedTabId = event.currentTarget.id;
    localStorage.setItem('selectedTab', selectedTabId);
    this.showTab(selectedTabId);
  }

  showTab(tabId) {
    this.tabTargets.forEach(tab => tab.hidden = true);
    let selectedTab = this.tabTargets.find(tab => tab.id === tabId);
    if (selectedTab) {
      selectedTab.hidden = false;
    }

    this.btnTargets.forEach(btn => {
      if (btn.id === tabId) {
        this.active(btn);
      } else {
        this.unactive(btn);
      }
    });
  }

  unactive(btn) {
    btn.classList.remove(...this.activeClasses);
    btn.classList.add(...this.unactiveClasses);
  }

  active(btn) {
    const tab = btn.parentNode;

    switch (btn.id) {
      case 'tab1':
        tab.style.setProperty('--current_button', '0');
        break;
      case 'tab2':
        tab.style.setProperty('--current_button', '1');
        break;
      case 'tab3':
        tab.style.setProperty('--current_button', '2');
        break;
      default:
        tab.style.setProperty('--current_button', '0');
    }

    btn.classList.add(...this.activeClasses);
    btn.classList.remove(...this.unactiveClasses);
  }
}
