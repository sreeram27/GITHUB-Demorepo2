import { LightningElement, api, track  } from 'lwc';
//const CSS_CLASS = 'modal-hidden';
export default class BrokerBrokerageModal extends LightningElement {
    @track value = '';
    @track showModal = false;
    get brokerBrokerageOptions() {
        return [
            { label: 'Brokerage Paid', value: 'BrokeragePaid' },
            { label: 'Broker Paid', value: 'BrokerPaid' },
        ];
    }

    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        //console.log(`Option selected with value: ${selectedOption}`);
    }

    @api show() {
        this.showModal = true;
    }

    @api hide() {
        this.showModal = false;
    }

    handleDialogClose() {
        this.hide();
    }

    handlePopup() {
        this.template.querySelector("section").classList.remove("slds-hide");
        this.template
          .querySelector("div.modalBackdrops")
          .classList.remove("slds-hide");
      }
    
}