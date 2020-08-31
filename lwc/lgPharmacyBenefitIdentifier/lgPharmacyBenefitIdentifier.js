import { LightningElement,track,api, wire } from 'lwc';
import UId from '@salesforce/user/Id';
import getPharmacyBenefitData from '@salesforce/apex/LGA_GetPharmacyBenefitData.getPharmacyBenefitData';
import showLWCdata from '@salesforce/apex/LGA_GetPharmacyBenefitData.showLWCdata';
/* eslint-disable no-console */
/* eslint-disable no-alert */


 const columns = [
        { label: 'Pharmacy Benefit Identifier', fieldName: 'pharBenefit', initialWidth: 200, editable: true },
        { label: 'Contract Code', fieldName: 'grpContractCode', initialWidth: 200 },
        { label: 'Custom Contract Code', fieldName: 'qliCustContractCode', initialWidth: 200},
        { label: 'HPCC Buy-up', fieldName: 'qliHPCC', initialWidth: 200 },
        { label: 'Suffix', fieldName: 'grpSuffix', initialWidth: 200 },
        { label: 'Plan Name', fieldName: 'grpPlan', initialWidth: 200 },
        { label: 'Plan Type', fieldName: 'grpPlanType', initialWidth: 200 },
        { label: 'Funding Type', fieldName: 'grpFunding', initialWidth: 200 },
        { label: 'Description', fieldName: 'grpDescription', initialWidth: 200 },
        { label: 'Effective Date', fieldName: 'grpEffDate', initialWidth: 200 },
        { label: 'Group Number', fieldName: 'grpName', initialWidth: 200 },
        { label: 'Product Stage', fieldName: 'qliProdStage', initialWidth: 200 },
    ];
export default class LgPharmacyBenefitIdentifier extends LightningElement {
    @api user_Id = UId;
    @api recordId;
    @track data ;
    @track currentPageData;
    @track columns = columns;
    pageSize = 10;
    @track totalSize;
    @track start;
    @track end;
    @track paginationList  = [];
    @track isLastPage = false;
    @track isFirstPage = true;
    @track usrprofilenames = [];
    @api updateDataQLI = {Key: '' } ;
    @api updateDataQLIList = [] ;
    

    @wire(showLWCdata , { userID: '$user_Id' }) showdataLWC({error,data}) {
        console.log('@@@@@@@@@@ This is inside showLWCData 49: ' + data);
        //console.log('@@@@@@@@@@ This is inside showLWCData: ' + JSON.stringify (data[0].userProfileName));
        console.log('@@@@@@@@@@ This is inside showLWCData data: ' + JSON.stringify (data));
        console.log('@@@@@@@@@@ This is inside showLWCData error: ' + JSON.stringify (error));
        this.usrprofilenames = data;
    }
 
    @wire(getPharmacyBenefitData , { recId: '$recordId' }) pharmacyBenefitDetails({ error, data }) {
        
        if (data) {
            this.currentPageData = data;
            this.data =data;
            console.log('@@@@data Length: ' + this.currentPageData.length );
            //this.setPages(this.data);
            //alert('this.pharmacyBenefitDetails@@ '+ JSON.stringify (data) );
            this.totalSize = this.currentPageData.length ;
            this.start =0;
            this.end = (this.pageSize) ;
            console.log('@@@@data Length: ' + this.totalSize );
            console.log('@@@@data Length: ' + this.start );
            console.log('@@@@data Length: ' + this.end );
            console.log('@@@@data Length: ' + this.paginationList );
            for(let i=0; i< this.pageSize; i++){
                //this.paginationList.push(JSON.parse(JSON.stringify(this.data))[i]);
                this.paginationList = (this.data.slice(this.start,this.end)) ;
            }
            console.log('@@@@data Length 114: ' + this.paginationList );
            //console.log('@@@@data Length 114: ' + this.paginationList.sise );
            this.error = undefined;
        } else if (error) {
            alert('error2@@ '+ JSON.stringify (error) );
            this.error = error;
            this.currentPageData = undefined;
        }
    } 


    next(){
        let counter = 0;
        let endRec = this.end;
        let startRec =this.start;
        let recPageSize = this.pageSize;
        console.log('@@@@Counter this.start: ' + startRec);
        console.log('@@@@Counter this.end: ' + endRec);
        for(let i=endRec+1; i<endRec+recPageSize+1; i++){
			if(this.currentPageData.length > endRec){
                console.log('@@@@Counter Inside If: ' + counter);
				this.paginationList = (this.currentPageData.slice(endRec,(endRec+recPageSize))) ;
				counter ++ ;
			}
        }
        console.log('@@@@Counter: ' + counter);
        this.start = startRec + counter;
        this.end = endRec + counter;
        console.log('@@@@Counter this.start: ' + this.start);
        console.log('@@@@Counter this.end: ' + this.end);
        console.log('@@@@Counter this.start: ' + this.start);
        console.log('@@@@Counter this.end: ' + this.end);
        if(this.end >= this.currentPageData.length){
            this.isLastPage = true;
            this.isFirstPage = false;
        }else{
            this.isFirstPage = false;
        }
        console.log('@@@@Counter this.start: ' + this.isLastPage);
        console.log('@@@@Counter this.end: ' + this.isFirstPage);
    }

    previous(){
        let counter = 0;
        let endRec = this.end;
        let startRec =this.start;
        let recPageSize = this.pageSize;
        console.log('@@@@Counter this.start: ' + startRec);
        console.log('@@@@Counter this.end: ' + endRec);
        for(let i=startRec-recPageSize; i<startRec; i++){

			if(i > -1){
                this.paginationList = (this.currentPageData.slice((startRec-recPageSize),startRec)) ;
                counter ++;
            }
            else { 
                startRec++;
            }

        }
        console.log('@@@@Counter: ' + counter);

        this.start = startRec - counter;
        this.end = endRec - counter;
        console.log('@@@@Counter this.start: ' + this.start);
        console.log('@@@@Counter this.end: ' + this.end);
        if(this.start <= 0 ){
            this.isLastPage =false;
            this.isFirstPage = true;
        }
        else{
            this.isLastPage =false;
        }
    }


}