/****************************
Author : Ravideep Singh
Created Date : 03/09/2020
History : @: 03/10/2020 - PRDCRM-50555 : PRDCRM-50555 : Component code to show iteration PG Ctalog Items based on filters
****************************/
/* eslint-disable no-console */
import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

/** getCatalogItems() method in CatalogController Apex class */
import getPGCatalogItems from '@salesforce/apex/CatalogController.getPGCatalogItems';

/** Pub-sub mechanism for sibling component communication. */
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';

/**
 * Container component that loads and displays a list of PG_Catalog_Item__c records.
 */
export default class MetricTileList extends LightningElement {
    /**
     * Whether to display the search bar.
     * TODO - normalize value because it may come as a boolean, string or otherwise.
     */
    @api searchBarIsVisible = false;

    /**
     * Whether the metrics tiles are draggable.
     * TODO - normalize value because it may come as a boolean, string or otherwise.
     */
    @api tilesAreDraggable = false;

    /** Current page in the metric list. */
    pageNumber = 1;

    /** The number of items on a page. */
    pageSize;

    /** The total number of items matching the selection. */
    totalItemCount = 0;

    /** JSON.stringified version of filters to pass to apex */
    filters = {};

    @wire(CurrentPageReference) pageRef;

    /**
     * Load the list of available metrics.
     */
   
    @wire(getPGCatalogItems, { filters: '$filters', pageNumber: '$pageNumber' })
    pgcatalogitems;
    
    connectedCallback() {
        console.log('Event registered')
        registerListener('filterChange', this.handleFilterChange, this);
        const param = 'c__oppname';
        const paramValue = this.getUrlParamValue(window.location.href, param);
    }

    @api oppname;
    getUrlParamValue(url, key) {
        console.log('param--> '+ new URL(url).searchParams.get(key));
        this.oppname = new URL(url).searchParams.get(key);
    }
    

    handlePGCatalogItemSelected(event) { 
        //console.log('event.detailid---> '+ event.detail);
        
        Array.from(this.template.querySelectorAll('c-metric-tile'))
        .forEach(element => {
            //console.log('element---> ' + element.pgcatalogitem.Id);
            if(element.pgcatalogitem.Id){
                if(element.pgcatalogitem.Id === event.detail){
                    element.addDynamicCSS();
                }
                else{
                    element.removeDynamicCSS();
                }

            }
        });

        fireEvent(this.pageRef, 'pgCatalogItemSelected', event.detail);
    }
    
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleSearchKeyChange(event) {
        this.filters = {
            searchKey: event.target.value.toLowerCase()
        };
        this.pageNumber = 1;
    }

    handleFilterChange(filters) {
        this.filters = { ...filters };
        this.pageNumber = 1;
    }

    handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
    }

    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
    }
    
}