import { LightningElement, api} from 'lwc';

export default class SearchInput extends LightningElement {
    @api brokerName = '';
    @api brokerTaxId = '';
    @api brokerEmail = '';
    @api brokerPhone = '';
    @api brokerState = '';
    @api getIdFromParent;
    
    get sourceURL() {
        return '/' + this.OppId;
    }
    //Clear inndividual Search Criteria Field
    handleClearSearchCriteria() {
        this.brokerName = "";
        let inputBrokerName=this.template.querySelector(".inputBrokerName");
        inputBrokerName.setCustomValidity('');
        inputBrokerName.reportValidity();
        this.brokerTaxId = "";
        let inputTaxId=this.template.querySelector(".inputTaxId");
        inputTaxId.setCustomValidity('');
        inputTaxId.reportValidity();
        this.brokerEmail = "";
        this.brokerPhone = "";
        let inputPhone=this.template.querySelector(".inputPhone");
        inputPhone.setCustomValidity('');
        inputPhone.reportValidity(); 
        this.brokerState = "";   
        let inputState=this.template.querySelector(".inputState");
        inputState.setCustomValidity('');
        inputState.reportValidity();
    }
    changeHandlerName(event) {
        this.brokerName = event.target.value;
        let inputValue = event.target.value;
        let inputBrokerName=this.template.querySelector(".inputBrokerName"); 
        if(inputValue.indexOf('@')>=0) {
             //set an error
            inputBrokerName.setCustomValidity("Please Don't include '@' in Broker name");
            inputBrokerName.reportValidity();
        }
        else if(inputValue.indexOf(',')>=0) {
             //set an error
            inputBrokerName.setCustomValidity("Please Don't include ',' in Broker name");
            inputBrokerName.reportValidity();
        }
        else if(inputValue.indexOf(';')>=0) {
            //set an error
           inputBrokerName.setCustomValidity("Please Don't include ';' in Broker name");
           inputBrokerName.reportValidity();
       }
        else {         
             //reset an error
            inputBrokerName.setCustomValidity('');
            inputBrokerName.reportValidity(); 
           
        }

    }
    changeHandlerTaxId(event) {
        
        this.brokerTaxId = event.target.value;
        let inputValue = event.target.value;
        let inputTaxId=this.template.querySelector(".inputTaxId"); 
        if(inputValue.indexOf('@')>=0) {
            //set an error
            inputTaxId.setCustomValidity("Please Don't include '@' in Broker name");
            inputTaxId.reportValidity();
       }
       else if(inputValue.indexOf(',')>=0) {
             //set an error
             inputTaxId.setCustomValidity("Please Don't include ',' in Tax Id");
             inputTaxId.reportValidity();
        }
        else if(inputValue.indexOf(';')>=0) {
            //set an error
            inputTaxId.setCustomValidity("Please Don't include ';' in Tax Id");
            inputTaxId.reportValidity();
       }
        else {         
             //reset an error
             inputTaxId.setCustomValidity('');
             inputTaxId.reportValidity(); 
           
        }

    }
    changeHandlerEmail(event) {
        this.brokerEmail = event.target.value;
    }
    changeHandlerPhone(event) {
        this.brokerPhone = event.target.value;
        let inputValue = event.target.value;
        let inputPhone=this.template.querySelector(".inputPhone"); 
        if(inputValue.indexOf('@')>=0) {
            //set an error
            inputPhone.setCustomValidity("Please Don't include '@' in Broker name");
            inputPhone.reportValidity();
       }
       else if(inputValue.indexOf(',')>=0) {
             //set an error
             inputPhone.setCustomValidity("Please Don't include ',' in Tax Id");
             inputPhone.reportValidity();
        }
        else if(inputValue.indexOf(';')>=0) {
            //set an error
            inputPhone.setCustomValidity("Please Don't include ';' in Tax Id");
            inputPhone.reportValidity();
       }
        else {         
             //reset an error
             inputPhone.setCustomValidity('');
             inputPhone.reportValidity();   
        }

    }
    changeHandlerState(event) {
        this.brokerState = event.target.value;
        let inputValue = event.target.value;
        let inputState=this.template.querySelector(".inputState"); 
        if(inputValue.indexOf('@')>=0) {
            //set an error
            inputState.setCustomValidity("Please Don't include '@' in Broker name");
            inputState.reportValidity();
       }
       else if(inputValue.indexOf(',')>=0) {
             //set an error
             inputState.setCustomValidity("Please Don't include ',' in Tax Id");
             inputState.reportValidity();
        }
        else if(inputValue.indexOf(';')>=0) {
            //set an error
            inputState.setCustomValidity("Please Don't include ';' in Tax Id");
            inputState.reportValidity();
       }
        else {         
             //reset an error
             inputState.setCustomValidity('');
             inputState.reportValidity(); 
        }
       
    }
    handleClickSearch(){
        this.dispatchEvent(new CustomEvent('search'));
    } 
}