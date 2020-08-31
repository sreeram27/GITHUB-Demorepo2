/****************************
Author : Smita
Created Date : 03/12/2020
User Story: PRDCRM-51723
****************************/

/* eslint-disable no-console */
/* eslint-disable no-useless-concat */
import { LightningElement, wire,api,track} from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
/** Wire adapter to load records, utils to extract values. */
import { getRecord } from 'lightning/uiRecordApi';

/** Pub-sub mechanism for sibling component communication. */
import { registerListener, unregisterAllListeners} from 'c/pubsub';


/** PG_Catalog_Item__c Schema. */
//import PG_CATALOG_ITEM_OBJECT from '@salesforce/schema/PG_Catalog_Item__c';
import NAME_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Name';
import PG_TYPE_FIELD from '@salesforce/schema/PG_Catalog_Item__c.PG_Type__c';
import BROAD_CONTRACT_CATEGORY_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Broad_Contract_Category__c';
import PERFORMANCE_CATEGORY_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Performance_Category__c';
import 	SME_FIELD from '@salesforce/schema/PG_Catalog_Item__c.SME__c';
import 	SPECIFIC_CONTRACT_CATEGORY_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Specific_Contract_Category__c';
import  ANA_MINIMUM_MEMBERS_FIELD from '@salesforce/schema/PG_Catalog_Item__c.ANA_Minimum_Members__c';
import 	LG_MINIMUM_MEMBERS_FIELD from '@salesforce/schema/PG_Catalog_Item__c.LG_Minimum_Members__c';
import DESCRIPTION_OF_PG_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Description_of_PG__c';
import RECOMMENDED_PG_PENALTY_TIERING_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Recommended_PG_Penalty_Tiering__c';
import CONFLICTING_PG_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Conflicting_PGs__c';
import ADDITIONAL_NOTES_OR_SPECIAL_APPROVALS_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Additional_Notes_or_Special_Approvals__c';
import PG_TITLE_FIELD from '@salesforce/schema/PG_Catalog_Item__c.PG_Title__c';
import createMetric from '@salesforce/apex/CreateMetricRecord.createMetric';
/** Record fields to load. */
const PGFIELDS   = [
NAME_FIELD,
PG_TYPE_FIELD,
PG_TITLE_FIELD,
BROAD_CONTRACT_CATEGORY_FIELD,
PERFORMANCE_CATEGORY_FIELD,	
SME_FIELD,
SPECIFIC_CONTRACT_CATEGORY_FIELD,
ANA_MINIMUM_MEMBERS_FIELD,
LG_MINIMUM_MEMBERS_FIELD,
DESCRIPTION_OF_PG_FIELD,
RECOMMENDED_PG_PENALTY_TIERING_FIELD,
CONFLICTING_PG_FIELD,
ADDITIONAL_NOTES_OR_SPECIAL_APPROVALS_FIELD,
];


/**
 * Component to display details of a PG_Catalog_Item__c.
 */
export default class MetricCard extends NavigationMixin(LightningElement) {
    


@api getIdFromParent;
@track measurementPeriod;
@track reportingPeriod;
@track tiering;
recordId;

@wire(CurrentPageReference) pageRef;


@wire(getRecord, { recordId: '$recordId', fields: PGFIELDS})
pgcatalogitem;

connectedCallback() {
    
    registerListener('pgCatalogItemSelected', this.handlePGCatalogItemSelected, this);
    const param = 'c__pgrequestId';
        this.getUrlParamValue(window.location.href, param);
    
}


getUrlParamValue(url, key) {
    console.log('param--> '+ new URL(url).searchParams.get(key));
    this.pgID = new URL(url).searchParams.get(key);
}

disconnectedCallback() {
    unregisterAllListeners(this);
}

/**
 * Handler for when a pgcatalogitem is selected. When `this.recordId` changes, the @wire
 * above will detect the change and provision new data.
 */
handlePGCatalogItemSelected(pgcatalogitemid) {
    console.log('id ' + pgcatalogitemid);
    
    this.recordId = pgcatalogitemid;
    this.measurementPeriod='';
    this.reportingPeriod='';
    this.tiering='';
    console.log('mp'+this.measurementPeriod);
}



handleMeasurementPeriodChange(event) {
    this.measurementPeriod = event.detail.value;
}

handleReportingPeriodChange(event) {
    this.reportingPeriod=event.detail.value;
}

handleTieringChange(event) {
    this.tiering=event.detail.value;
}


handleClick() {
    createMetric({ id : this.recordId ,measurementPeriod:this.measurementPeriod ,reportingPeriod:this.reportingPeriod,pgReqId:this.pgID,tieringValue:this.tiering})
        .then(result => {
            this.message = result;
            this.error = undefined;
            if(this.message !== undefined) {
                //this.NAME_FIELD = '';
                // this.PG_TYPE_FIELD = '';
                // this.BROAD_CONTRACT_CATEGORY_FIELD = '';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Metric created',
                        variant: 'success',
                    }),
                );
            }
            
            console.log(JSON.stringify(result));
            console.log("result", this.message);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
            console.log("error", JSON.stringify(this.error));
        });
        

}
get noData() {
    return !this.pgcatalogitem.error && !this.pgcatalogitem.data;
}
}