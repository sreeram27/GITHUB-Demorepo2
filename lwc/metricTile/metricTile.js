import { LightningElement, api } from 'lwc';

/**
 * A presentation component to display a PG_Catalog_Item__c sObject. The provided
 * PG_Catalog_Item__c data must contain all fields used by this component.
 */
export default class MetricTile extends LightningElement {
    /** Whether the tile is draggable. */
    @api draggable;
    pgtypeinitials;
    _pgcatalogitem;
    /** PG_Catalog_Item__c to display. */
    @api
    get pgcatalogitem() {
        return this._pgcatalogitem;
    }

    set pgcatalogitem(value) {
        this._pgcatalogitem = value;
        this.performancecategory = value.Performance_Category__c;
        this.contractcategory = value.Broad_Contract_Category__c;
        this.pgtype = value.PG_Type__c;
    
        /** Url for logos. */

    }
    renderedCallback(){
        if(this.pgtype === 'Standard'){
            //console.log(this.pgtype);
            this.pgtypeinitials = 'S';
            console.log('clist--> ' + this.template.querySelector('.slds-avatar__initials'));
            this.template.querySelector('.slds-avatar__initials').classList.add('standard')
        }
        else if(this.pgtype === 'Non Standard'){
            //console.log(this.pgtype);
            this.pgtypeinitials = 'NS';
            this.template.querySelector('.slds-avatar__initials').classList.add('non-standard')
        }
        else{
            //console.log(this.pgtype);
            this.pgtypeinitials = 'BP';
        }
   }    

    /** PG_Catalog_Item__c field values to display. */
    
    performancecategory;
    contractcategory;
    pgtype;


    @api
    removeDynamicCSS(){
        this.template.querySelector('.table').classList.remove('dynamicCSS'); 
    }
    @api
    addDynamicCSS(){
        this.template.querySelector('.table').classList.add('dynamicCSS'); 
        
    }
    
    handleClick() {        
        const selectedEvent = new CustomEvent('selected', {
            detail: this.pgcatalogitem.Id,
            
        });
        this.dispatchEvent(selectedEvent);
    }
}