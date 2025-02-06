// app/javascript/controllers/tabs_controller.js
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static classes = ['active', 'unactive']
    static targets = ["btn", "tab"]
    static values = {defaultTab: String}

    connect() {
      this.tabTargets.map(x => x.hidden = true)
      let selectedTab = this.tabTargets.find(element => element.id === this.defaultTabValue)
      selectedTab.hidden = false
      let selectedBtn = this.btnTargets.find(element => element.id === this.defaultTabValue)
      let otherBtn = this.btnTargets.filter(btn => btn !== selectedBtn);
      this.active(selectedBtn);
      otherBtn.forEach((x) => {
        this.unactive(x);
      })
    }

    select(event) {
      let selectedTab = this.tabTargets.find(element => element.id === event.currentTarget.id)
      if (selectedTab.hidden) {
        this.tabTargets.map(x => x.hidden = true)
        this.btnTargets.forEach((x) => {
          this.unactive(x)
        });
        selectedTab.hidden = false
        this.active(event.currentTarget);
      }
    }

    unactive(btn){
      btn.classList.remove(...this.activeClasses);
      btn.classList.add(...this.unactiveClasses);
    }

    async active(btn){
      const tab = btn.parentNode
      
      switch(btn.id){
        case 'tab1':
          tab.style.setProperty('--current_button', '0')
          break;
        case 'tab2':
          tab.style.setProperty('--current_button', '1')
          break;
        case 'tab3':
          tab.style.setProperty('--current_button', '2')
        break;
        default:
          tab.style.setProperty('--current_button', '0')
      }

      btn.classList.add(...this.activeClasses);
      btn.classList.remove(...this.unactiveClasses);
    }
}
