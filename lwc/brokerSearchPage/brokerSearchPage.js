import { LightningElement,api, track, wire } from 'lwc';
import checkPermissionSet from '@salesforce/apex/BrokerSearchResult.checkPermissionSet';
import fetchBrokerSearchResult from '@salesforce/apex/BrokerSearchResult.fetchBrokerSearchResult';
import fetchBrokerSearchLookupData from '@salesforce/apex/BrokerSearchResult.fetchBrokerSearchLookupData';
import fetchBrokerStateLookupData from '@salesforce/apex/BrokerSearchResult.fetchBrokerStateLookupData';
// Import custom labels
import opportunity from '@salesforce/label/c.opportunity';
import brokerNoResult from '@salesforce/label/c.brokerNoResult';
const columns = [
{label: 'Broker Name', fieldName: 'brokerName', type: 'text'},
{label: 'Broker Tax Id', fieldName: 'brokerTaxId', type: 'text'},
{label: 'Broker Email', fieldName: 'brokerEmail', type: 'email'},
{label: 'Broker Mobile', fieldName: 'brokerMobile', type: 'phone'},
{label: 'Broker Licensed and/or Appointed in State', fieldName: 'brokerLicenseState', type: 'text'},
{label: 'Paid TIN', fieldName: 'brokerPaidTin', type: 'text'},
{label: 'Brokerage', fieldName: 'contRelBrokerage', type: 'text'},
];

var  paramSearchObject  = { brokerName: "",
                        brokerTaxId: "",
                        brokerEmail: "",
                        brokerPhone: "",
                        brokerState: ""
                    };

const dataSc = [];
const DELAY = 500;
export default class BrokerSearchPage extends LightningElement {
label = {opportunity,brokerNoResult};

@track data = dataSc;
@track columns = columns;
@track brokerState = 'NA';
@track brokerName = '';
@track brokerTaxId = '';
@track brokerEmail = '';
@track brokerPhone = '';

@track showContactRelationshipButton = false;
@track showNewBroker = false;
@track showBrokerSearchTable = false;
@track noResultFetched = false;

@api OppId;
@api OppName;
@track param;

//Added by Suresh
@track search = '';
@track error;
@track accounts;
@track brokerSearch;
@track searchLen = 0;
@track searchBroker;
@track searchType;
@track searchState;




@track selectedAccount = "";
@track showAccountsListFlagBrokerName = false;
@track showAccountsListFlagBrokerTax = false;
@track showAccountsListFlagBrokerEmail = false;
@track showAccountsListFlagBrokerPhone = false;
@track showAccountsListFlagBrokerState = false;


@wire(fetchBrokerSearchLookupData, { searchText: '$searchBroker', searchType: '$searchType' })
wiredAccounts({ error, data }) {
    
    if (data) {
        this.accounts = [];
        this.accounts = data;
        this.error = undefined;
        
        if(data.length === 0 && this.searchType === 'Name'){
            this.template.querySelector('.accounts_listBroker').classList.add('slds-hide');
        }
        else if(data.length === 0 && this.searchType === 'Tax'){
            this.template.querySelector('.accounts_listBrokerTax').classList.add('slds-hide');
        }
        else if(data.length === 0 && this.searchType === 'Email'){
            this.template.querySelector('.accounts_listBrokerEmail').classList.add('slds-hide');
        }
        else if(data.length === 0 && this.searchType === 'Phone'){
            this.template.querySelector('.accounts_listBrokerPhone').classList.add('slds-hide');
        }
    } 
    else if (error) {
        this.error = error;
        this.accounts = undefined;
        
    }
    
}

@wire(fetchBrokerStateLookupData, { searchState: '$searchState' })
wiredContacts({ error, data }) {
    if (data) {
        this.brokerSearch = data;
        this.error = undefined;
        
        if(data.length === 0){
            this.template.querySelector('.accounts_listBrokerState').classList.add('slds-hide');
        }
    } 
    else if (error) {
        this.error = error;
        this.brokerSearch = undefined;
    }
}


get sourceURL() {
    return '/' + this.OppId;
}


//Added by Suresh
/*eslint-disable*/
showTypeAheadName(event){
    console.log(' test event '+JSON.stringify(event.relatedTarget.className));
    this.template
        .querySelector('.accounts_listBroker')
        .classList.remove('slds-hide');
}
hideTypeAheadName(event){
    
    if(event !== null && event.relatedTarget !== null && event.relatedTarget.className !== null && !event.relatedTarget.className.includes('content')){

        if(!event.relatedTarget.className.includes('inputBrokerName') && !event.relatedTarget.className.includes('accounts_listBroker') && this.template.querySelector(".accounts_listBroker").classList.contains('accounts_listBroker') && !event.relatedTarget.className.includes('dontHideName') && !event.relatedTarget.className.includes('dontHideName1') && !event.relatedTarget.className.includes('dontHideName2')){
            this.template.querySelector('.accounts_listBroker').classList.add('slds-hide');
        }
        if(!event.relatedTarget.className.includes('inputTaxId') && !event.relatedTarget.className.includes('accounts_listBrokerTax') && this.template.querySelector(".accounts_listBrokerTax").classList.contains('accounts_listBrokerTax') && !event.relatedTarget.className.includes('dontHideTax') && !event.relatedTarget.className.includes('dontHideTax1') && !event.relatedTarget.className.includes('dontHideTax2')){
            this.template.querySelector('.accounts_listBrokerTax').classList.add('slds-hide');
        }
        if(!event.relatedTarget.className.includes('inputEmail') && !event.relatedTarget.className.includes('accounts_listBrokerEmail') && this.template.querySelector(".accounts_listBrokerEmail").classList.contains('accounts_listBrokerEmail') && !event.relatedTarget.className.includes('dontHideEmail') && !event.relatedTarget.className.includes('dontHideEmail1') && !event.relatedTarget.className.includes('dontHideEmail2')){
            this.template.querySelector('.accounts_listBrokerEmail').classList.add('slds-hide');
        }
        if(!event.relatedTarget.className.includes('inputPhone') && !event.relatedTarget.className.includes('accounts_listBrokerPhone') && this.template.querySelector(".accounts_listBrokerPhone").classList.contains('accounts_listBrokerPhone') && !event.relatedTarget.className.includes('dontHidePhone') && !event.relatedTarget.className.includes('dontHidePhone1') && !event.relatedTarget.className.includes('dontHidePhone2')){
            this.template.querySelector('.accounts_listBrokerPhone').classList.add('slds-hide');
        }
        if(!event.relatedTarget.className.includes('inputState') && !event.relatedTarget.className.includes('accounts_listBrokerState') && this.template.querySelector(".accounts_listBrokerState").classList.contains('accounts_listBrokerState') && !event.relatedTarget.className.includes('dontHideState') && !event.relatedTarget.className.includes('dontHideState1') && !event.relatedTarget.className.includes('dontHideState2')){
            this.template.querySelector('.accounts_listBrokerState').classList.add('slds-hide');
        }
        
    }
    
}
showHelpTextBrokerSearch(){
    console.log(' test helptext ');
    this.template
            .querySelector('.divHelpSearch')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerSearch(){
    console.log(' test helptext test');
    this.template
            .querySelector('.divHelpSearch')
            .classList.add('slds-hide');
}
showHelpTextBrokerName(){
    console.log(' test helptext ');
    this.template
            .querySelector('.divHelp')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerName(){
    console.log(' test helptext test');
    this.template
            .querySelector('.divHelp')
            .classList.add('slds-hide');
}
showHelpTextBrokerTax(){
    console.log(' test divHelpTax helptext ');
    this.template
            .querySelector('.divHelpTax')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerTax(){
    console.log(' test divHelpTax helptext test');
    this.template
            .querySelector('.divHelpTax')
            .classList.add('slds-hide');
}
showHelpTextBrokerEmail(){
    console.log(' test divHelpEmail helptext ');
    this.template
            .querySelector('.divHelpEmail')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerEmail(){
    console.log(' test divHelpEmail helptext test');
    this.template
            .querySelector('.divHelpEmail')
            .classList.add('slds-hide');
}
showHelpTextBrokerPhone(){
    console.log(' test divHelpPhone helptext ');
    this.template
            .querySelector('.divHelpPhone')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerPhone(){
    console.log(' test divHelpPhone helptext test');
    this.template
            .querySelector('.divHelpPhone')
            .classList.add('slds-hide');
}
showHelpTextBrokerState(){
    console.log(' test divHelpState helptext ');
    this.template
            .querySelector('.divHelpState')
            .classList.remove('slds-hide');
}
hideHelpTextBrokerState(){
    console.log(' test divHelpState helptext test');
    this.template
            .querySelector('.divHelpState')
            .classList.add('slds-hide');
}

handleOptionSelect(event) {
    let brokerName = event.currentTarget.dataset.name;
    let brokertax = event.currentTarget.dataset.tax;
    let brokerNemail = event.currentTarget.dataset.email;
    let brokerphone = event.currentTarget.dataset.phone;
    let brokerstate = event.currentTarget.dataset.state;
    
    if(brokerName != null || brokerName !== undefined){
        this.brokerName =  brokerName;
        this.template
            .querySelector('.accounts_listBroker')
            .classList.add('slds-hide');
    }
    
    if(brokertax != null || brokertax !== undefined){
        this.brokerTaxId = brokertax;
        this.template
            .querySelector('.accounts_listBrokerTax')
            .classList.add('slds-hide');
    }
    
    if(brokerNemail != null || brokerNemail !== undefined){
        this.brokerEmail = brokerNemail;
        this.template
            .querySelector('.accounts_listBrokerEmail')
            .classList.add('slds-hide');
    }
    
    if(brokerphone != null || brokerphone !== undefined){
        this.brokerPhone = brokerphone;
        this.template
            .querySelector('.accounts_listBrokerPhone')
            .classList.add('slds-hide');
    }
    
    if(brokerstate != null || brokerstate !== undefined){
        this.brokerState = brokerstate;
        this.template
            .querySelector('.accounts_listBrokerState')
            .classList.add('slds-hide');
    }
    

    
}

//End - Added by Suresh

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
    let inputEmail=this.template.querySelector(".inputEmail");
    inputEmail.setCustomValidity('');
    inputEmail.reportValidity(); 
    this.brokerPhone = "";
    let inputPhone=this.template.querySelector(".inputPhone");
    inputPhone.setCustomValidity('');
    inputPhone.reportValidity(); 
    //this.brokerState = this.AccountState;   
    this.brokerState = "NA";
    let inputState=this.template.querySelector(".inputState");
    inputState.setCustomValidity('');
    inputState.reportValidity();

    paramSearchObject.brokerState = "NA";
    paramSearchObject.brokerName = "";
    paramSearchObject.brokerTaxId = "";
    paramSearchObject.brokerEmail = "";
    paramSearchObject.brokerPhone = ""; 
    
    this.showBrokerSearchTable = false;
    this.noResultFetched = false;
    console.log('JSON value '+JSON.stringify(paramSearchObject));
}
changeHandlerName(event) {
    paramSearchObject.brokerName = event.target.value;
    this.brokerName = event.target.value;
    let inputValue = event.target.value;    
    let inputBrokerName=this.template.querySelector(".inputBrokerName"); 
    if(inputValue.indexOf('@')>=0 || inputValue.indexOf(',')>=0 || inputValue.indexOf(';')>=0) {
        //set an error
        inputBrokerName.setCustomValidity("Please Don't include '@' / ',' / ';'");
        inputBrokerName.reportValidity();
    }
    else {
        //reset an error
        inputBrokerName.setCustomValidity('');
        inputBrokerName.reportValidity(); 
    }
    if(inputValue.length <= 2){         
        this.template
            .querySelector('.accounts_listBroker')
            .classList.add('slds-hide');
    }
    else{
            this.template
                .querySelector('.accounts_listBroker')
                .classList.remove('slds-hide');
        
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        
            this.delayTimeout = setTimeout(() => {
                this.searchBroker = searchKey;
                this.searchType = "Name";
            }, DELAY);
            
    }

}
changeHandlerTaxId(event) {
    paramSearchObject.brokerTaxId = event.target.value;
    this.brokerTaxId = event.target.value;
    let inputValue = event.target.value;
    let inputTaxId=this.template.querySelector(".inputTaxId"); 
    if(inputValue.indexOf('@')>=0 || inputValue.indexOf(',')>=0 || inputValue.indexOf(';')>=0) {
        //set an error
        inputTaxId.setCustomValidity("Please Don't include '@' / ',' / ';'");
        inputTaxId.reportValidity();
    }
    else{
        //reset an error
        inputTaxId.setCustomValidity('');
        inputTaxId.reportValidity();
    }
    
    if(inputValue.length <= 2){         
            
            this.template
                .querySelector('.accounts_listBrokerTax')
                .classList.add('slds-hide');
        
    }
    else {         
            this.template
                .querySelector('.accounts_listBrokerTax')
                .classList.remove('slds-hide');
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        
            this.delayTimeout = setTimeout(() => {
                this.searchBroker = searchKey;
                this.searchType = "Tax";
            }, DELAY);
            
        
    }

}
changeHandlerEmail(event) {
    paramSearchObject.brokerEmail = event.target.value;
    this.brokerEmail = event.target.value;
    let inputBrokerEmail = event.target.value;
    if(inputBrokerEmail.length < 3){         
        this.template
                .querySelector('.accounts_listBrokerEmail')
                .classList.add('slds-hide');
    }
    else {         
        //reset an error
            this.template
                .querySelector('.accounts_listBrokerEmail')
                .classList.remove('slds-hide');
       window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
            this.delayTimeout = setTimeout(() => {
                this.searchBroker = searchKey;
                this.searchType = "Email";
            }, DELAY);
    }

}
changeHandlerPhone(event) {
    paramSearchObject.brokerPhone = event.target.value;
    this.brokerPhone = event.target.value;
    let inputValue = event.target.value;
    let inputPhone=this.template.querySelector(".inputPhone"); 
    if(inputValue.indexOf('@')>=0 || inputValue.indexOf(',')>=0 || inputValue.indexOf(';')>=0) {
        //set an error
        inputPhone.setCustomValidity("Please Don't include '@' / ',' / ';'");
        inputPhone.reportValidity();
    }
    else {
        //reset an error
        inputPhone.setCustomValidity('');
        inputPhone.reportValidity(); 
    }
    if(inputValue.length <= 2){         
            this.template
                .querySelector('.accounts_listBrokerPhone')
                .classList.add('slds-hide');
        
    }
    else {         
           this.template
                .querySelector('.accounts_listBrokerPhone')
                .classList.remove('slds-hide');
       window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        //let phn = (""+searchKey).replace(/\D/g, '');
        //let phnFormat = phn.match(/^(\d{3})(\d{3})(\d{4})$/);
        //let phoneFinal = (!phnFormat) ? null : "(" + phnFormat[1] + ") " + phnFormat[2] + "-" + phnFormat[3];
        
            this.delayTimeout = setTimeout(() => {
                this.searchBroker = searchKey;
                this.searchType = "Phone";
            }, DELAY); 
    }

}
changeHandlerState(event) {
    paramSearchObject.brokerState = event.target.value;
    this.brokerState = event.target.value;
    let inputValue = event.target.value;
    let inputState=this.template.querySelector(".inputState"); 
    if(inputValue.indexOf('@')>=0 || inputValue.indexOf(',')>=0 || inputValue.indexOf(';')>=0) {
        //set an error
        inputState.setCustomValidity("Please Don't include '@' / ',' / ';'");
        inputState.reportValidity();
    }
    else {
        //reset an error
        inputState.setCustomValidity('');
        inputState.reportValidity(); 
    }
    if(inputValue.length === 0){         
            this.template
                .querySelector('.accounts_listBrokerState')
                .classList.add('slds-hide');
   }
    else {         
            this.template
                .querySelector('.accounts_listBrokerState')
                .classList.remove('slds-hide');
       window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        console.log(' test state1 ');
            this.delayTimeout = setTimeout(() => {
                this.searchState = searchKey;
                //this.searchType = "State";
            }, DELAY); 
            console.log(' test state 2');
    }
    
}
connectedCallback(){
    checkPermissionSet()
    .then(result => {
        this.showNewBroker = result.showNewBroker;
        this.showContactRelationshipButton = result.showContactRelationshipButton;
    })
    .catch(error => {
        this.showNewBroker = false;
        this.showContactRelationshipButton = false;
    });
}
    

createBroker(){
    const modal = this.template.querySelector('c-broker-brokerage-modal');
    modal.show();
}

getSelectedRecord(event){
    var sel;
    const selectedRows = event.detail.selectedRows;
    if(typeof selectedRows !== "undefined"){
        for(sel of selectedRows){
            if(sel.brokerLicenseState === 'N/A'){
                const modal = this.template.querySelector('c-accept-cancel-broker');
                modal.show();
            }
        }
    }    
    
}

handleunselectbroker(){
    console.log('handleunselectbroker');
    var selectedRowsIds = [];
    this.template.querySelector('lightning-datatable').selectedRows = selectedRowsIds;
}

    handleClickSearch(evt){
    
        console.log('Current value of the input: ' + evt.target.value);

        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                        inputCmp.reportValidity();
                        return validSoFar && inputCmp.checkValidity();
            }, true);
        if(this.brokerState.length<2){
            alert('Please enter two charater in State field.');
        }
        else if (!allValid) {
            alert('Please update the invalid form entries and try again.');
        } 
        else {
            var resp;
            const modal = this.template.querySelector('c-accept-cancel-broker');
            modal.hide();
            if(typeof this.template.querySelector('lightning-datatable') !== "undefined"){
                console.log('call handle0'+ this.template.querySelector('lightning-datatable'));
                if(this.template.querySelector('lightning-datatable') !== null)
                {   console.log('call handle1');
                    this.handleunselectbroker();
                }
            }
            console.log('showSearchTable');
            //this.showBrokerSearchTable = true;
            this.param = paramSearchObject;
            console.log('parm '+JSON.stringify(this.param));
            fetchBrokerSearchResult({ 
                brokerName: this.param.brokerName,
                brokerTaxId: this.param.brokerTaxId,
                brokerEmail: this.param.brokerEmail,
                brokerMobile: this.param.brokerPhone,
                brokerLicenseState: this.param.brokerState
            })
            .then(result => {
                this.data = result;
                console.log('result: '+JSON.stringify(result));
                if(typeof result !== "undefined"){
                    for(resp of result){
                        console.log('resp: '+JSON.stringify(resp));
                        if(resp.noDataToShow){
                            this.noResultFetched = true;
                            this.showBrokerSearchTable = false;
                            console.log('resp noDataToShow');
                            modal.hide();
                        }else{
                            this.noResultFetched = false;
                            this.showBrokerSearchTable = true;
                            console.log('DataToShow');
                            modal.hide();
                        }
                    }
                }
            })
            .catch(error => {
                this.showBrokerSearchTable = false;
                modal.hide();
            });
        }
            
    }
    
}