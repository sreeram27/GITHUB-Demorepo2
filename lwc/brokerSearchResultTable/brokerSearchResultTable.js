import { LightningElement, track, wire } from 'lwc';

const columns = [
    {label: 'Broker Name', fieldName: 'brokerName', type: 'text'},
    {label: 'Broker Tax Id', fieldName: 'brokerTaxId', type: 'number'},
    {label: 'Broker Email', fieldName: 'brokerEmail', type: 'email'},
    {label: 'Broker Mobile', fieldName: 'brokerMobile', type: 'phone'},
    {label: 'Broker Licensed and/or Appointed in State', fieldName: 'brokerLicenseState', type: 'text'},
    {label: 'Paid TIN', fieldName: 'brokerPaidTin', type: 'text'},
    {label: 'Brokerage', fieldName: 'contRelBrokerage', type: 'text'},
];

var paramSearchInput = { brokerName: "",
                         brokerTaxId: "",
                         brokerEmail: "",
                         brokerPhone: "",
                         brokerState: ""
                       };
const data = [];
export default class BrokerSearchResultTable extends LightningElement {
    
    @track data = data;
    @track columns = columns;
}