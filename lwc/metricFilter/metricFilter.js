/****************************
Author : Ravideep Singh
Created Date : 03/09/2020
History : @: 03/10/2020 - PRDCRM-51773 : Revision to Filter for PG Catalog Items-->
****************************/

import { LightningElement, wire,track } from 'lwc';
import MASTER_RECORDTYPE_ID from '@salesforce/label/c.MasterRecordTypeId';
import { CurrentPageReference } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import PG_TYPE_FIELD from '@salesforce/schema/PG_Catalog_Item__c.PG_Type__c';
import PERFORMANCE_CATEGORY_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Performance_Category__c';
import BROAD_CONTRACT_CATEGORY_FIELD from '@salesforce/schema/PG_Catalog_Item__c.Broad_Contract_Category__c';

/** Pub-sub mechanism for sibling component communication. */
import { fireEvent } from 'c/pubsub';


/** The delay used when debouncing event handlers before firing the event. */
const DELAY = 350;
var pgTypesFilterArray; 
var contractCategoriesFilterArray; 
/**
 * Displays a filter panel to search for PG_Metric__c[].
 */
export default class MetricFilter extends LightningElement {
    pgTypesFilterArray = new Array; 
    contractCategoriesFilterArray = new Array; 
    searchKey = '';

    filters = {
        searchKey: '',
    };
    connectedCallback(){
        console.log('connected call filter-->');
        //this.handleReset(event);
        pgTypesFilterArray = new Array();
        contractCategoriesFilterArray = new Array();

    }

    @wire(CurrentPageReference) pageRef;

    @wire(getPicklistValues, {
        recordTypeId: MASTER_RECORDTYPE_ID,
        fieldApiName: PG_TYPE_FIELD
    })
    pgtypes;

    performancecatagoriesdata;
    performancecategorieserror;
    @wire(getPicklistValues, {
        recordTypeId: MASTER_RECORDTYPE_ID,
        fieldApiName: PERFORMANCE_CATEGORY_FIELD
    })
    setPicklistOptions({ error, data }) {
        if (data) {
            this.performancecatagoriesdata = data;
            this.performancecategorieserror = undefined;
            //console.log(JSON.stringify(data));
            this.options = [ { label: '--None--', value: null, selected: true }, ...data.values ];
        } else {
            this.performancecatagoriesdata = undefined;
            this.performancecategorieserror = error;
            //console.log(error);
        }
       
    }

    @wire(getPicklistValues, {
        recordTypeId: MASTER_RECORDTYPE_ID,
        fieldApiName: BROAD_CONTRACT_CATEGORY_FIELD
    })
    contractcategories;

    handleSearchKeyChange(event) {
        this.filters.searchKey = event.target.value;
        this.delayedFireFilterChangeEvent();
    }

    handleChange(event) {
       
            const pgTypeArray = this.pgtypes.data.values.map(
                item => item.value
            );
            const contractCategoriesTypeArray = this.contractcategories.data.values.map(
                item => item.value
            );
            

        console.log('pgTypeArray--> '+ pgTypeArray);
        console.log('contractCategoriesTypeArray--> '+ contractCategoriesTypeArray);
        console.log('value2--> '+ event.target.dataset.value);
        console.log('type--> '+ event.target.dataset.filter);
        console.log('checkedtype--> '+ event.target.checked);
        const value = event.target.dataset.value;
       
        if (event.target.checked === true) {
            if (pgTypeArray.includes(value)) {
               //console.log('includespgtypesvalue');
               pgTypesFilterArray.push(value);
               this.filters[event.target.dataset.filter] = pgTypesFilterArray;
            }
            else if(contractCategoriesTypeArray.includes(value)){
                //console.log('includescontractcategoriesvalue');
                contractCategoriesFilterArray.push(value);
                this.filters[event.target.dataset.filter] = contractCategoriesFilterArray;
            }
            
        }
        else if(event.target.checked === false){
            //console.log('unchecked--> ');
            //console.log('filtersset1--> '+ this.filters[event.target.dataset.filter]);
            if (pgTypesFilterArray.includes(value)) {
                //console.log('includespgtypesvalue1');
                pgTypesFilterArray = pgTypesFilterArray.filter(
                    item => item !== value
                 );
				 this.filters[event.target.dataset.filter] = pgTypesFilterArray;
             }
             else if(contractCategoriesFilterArray.includes(value)){
                 //console.log('includescontractcategoriesvalue1');
                 contractCategoriesFilterArray = contractCategoriesFilterArray.filter(
                    item => item !== value
                 );
				this.filters[event.target.dataset.filter] = contractCategoriesFilterArray;
            }
        }
        else {
            var performanceCategoriesFilterArray = new Array;
            this.value = event.detail.value;
            //console.log('dropdownvalue--> ' + this.value)
            if(this.value){
                performanceCategoriesFilterArray.push(this.value)
            }
            this.filters[event.target.dataset.filter] = performanceCategoriesFilterArray;
        }
    
        
        console.log('filtersset2--> '+ this.filters[event.target.dataset.filter]);
        fireEvent(this.pageRef, 'filterChange', this.filters);
    }
    
    handleReset(event) {
        Array.from(this.template.querySelectorAll('lightning-input'))
        .forEach(element => {
            //console.log('element---> ' + element);
            if(element.type === 'search'){
                element.value = '';
             }
            if(element.type === 'checkbox' && element.checked){
                element.checked=false;
             }
        });
        this.template.querySelectorAll('lightning-combobox').forEach(each => {
            each.value = null;
        });
        this.selectedType = null;
        pgTypesFilterArray = [];
        contractCategoriesFilterArray = [];
        this.filters = [];
        fireEvent(this.pageRef, 'filterChange', this.filters);
    }

    delayedFireFilterChangeEvent() {
        // Debouncing this method: Do not actually fire the event as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex
        // method calls in components listening to this event.
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            fireEvent(this.pageRef, 'filterChange', this.filters);
        }, DELAY);
    }
}