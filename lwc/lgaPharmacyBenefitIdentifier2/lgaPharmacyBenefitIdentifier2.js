import { LightningElement,track,api, wire } from 'lwc';
import UId from '@salesforce/user/Id';
import getPharmacyBenefitData from '@salesforce/apex/LGA_GetPharmacyBenefitData.getPharmacyBenefitData';
import showLWCdata from '@salesforce/apex/LGA_GetPharmacyBenefitData.showLWCdata'; //savePBIData
import savePBIData from '@salesforce/apex/LGA_GetPharmacyBenefitData.savePBIData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


/* eslint-disable no-console */
/* eslint-disable no-alert */


export default class LgaPharmacyBenefitIdentifier2 extends LightningElement {

    @api user_Id = UId;
    @api recordId;
    @track data ;
    @track currentPageData; 
    pageSize = 10;
    @track totalSize;
    @track start;
    @track end;
    @track paginationList  = [];
    @track isLastPage = false;
    @track isFirstPage = true;
    @track usrprofilenames = [];
    @api updateDataQLI = [] ;
    @api updateDataQLIList = [] ;
    @track dataLoadError;
    @track errorMessage = 'Please enter a valid data. (i.e. No Whitespace and should not have more than 10 characters)';

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
            if( this.totalSize === this.pageSize ){
                this.isFirstPage = false;
                this.isLastPage = true;
            }
            for(let i=0; i< this.pageSize; i++){
                //this.paginationList.push(JSON.parse(JSON.stringify(this.data))[i]);
                this.paginationList = (this.data.slice(this.start,this.end)) ;
            }
            console.log('@@@@data Length 114: ' + this.paginationList );
            //console.log('@@@@data Length 114: ' + this.paginationList.sise );
            this.dataLoadError = undefined;
        } else if (error) {
            //alert('error2@@ '+ JSON.stringify (error) );
            this.dataLoadError = error;
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

    // Saving records efter Editing
    updateValues(event){
        console.log('@@@@@@@Inside Save:  ' + event.target.value);
        
        let inputData = JSON.stringify(event.target.value);
        console.log('@@@@@@@Inside Save Length:  ' + inputData.length );
        console.log('@@@@@@@Inside Save Length:  ' + (inputData.length - 2) );
        if(inputData.search(' ') >= 0 || (inputData.length - 2) > 10 ){
            console.log('@@@@@@@@@@Inside If :   ' + inputData.search(' '));
            
            const evt = new ShowToastEvent({
                "title": "Wrong Input",
                "message": this.errorMessage,
                "variant": "error",
            });
            this.dispatchEvent(evt);
        }
        else{
            let foundelement = this.updateDataQLI.find(ele => ele.id === event.target.dataset.id);
            console.log('@@@@@@@@@@foundelement: ' + foundelement);
            if(foundelement===undefined){

                console.log('@@@@@@@@@@foundelement Else: ' + foundelement);
                let ele = {Name: '', Id: ''};
                ele.Id =  event.target.dataset.id;
                ele.Name = event.target.value;
                console.log('@@@@@@@@@@foundelement ele : ' + foundelement);
                this.updateDataQLI.push(ele);
                
            }else{
                console.log('@@@@@@@@@@foundelement Inside If: ' + foundelement);
                foundelement.Name = event.target.value;
                this.updateDataQLI = [...this.updateDataQLI];
            }
        }
        
        

        //console.table('@@@@@@@@@@@tesgsdf:  '+JSON.stringify(this.updateDataQLI));
        console.log('@@@@@@@@@@@tesgsdf:  '+JSON.stringify(this.updateDataQLI));
        //console.log('@@@@@@@@@@@tesgsdf:  '+JSON.stringify(this.updateDataQLI.keys()));
        //console.log('@@@@@@@@@@@tesgsdf:  '+this.updateDataQLI.keys());
    }
    
    handleSave(){
         console.log('@@@@@@@@Inside HandleSave' + JSON.stringify(this.updateDataQLI));
        savePBIData({
            saveData: this.updateDataQLI,
            rxId : this.recordId
        })
        .then((data) => {
            console.log('@@@@@@@If Success:  ' + data);
            this.currentPageData = data;
            this.data =data;
            console.log('@@@@data Success Length: ' + this.currentPageData.length );

            this.totalSize = this.currentPageData.length ;
            this.start =0;
            this.end = (this.pageSize) ;

            for(let i=0; i< this.pageSize; i++){
                //this.paginationList.push(JSON.parse(JSON.stringify(this.data))[i]);
                this.paginationList = (this.data.slice(this.start,this.end)) ;
            }
            console.log('@@@@data Success Length: ' + JSON.stringify(this.paginationList ));
            this.dataLoadError = undefined;
            //return refreshApex(this.pharmacyBenefitDetails);

        })
        .catch((error) => {
            console.log('@@@@@@@@If Error:  ');
            this.message = 'Error received: code' + error.errorCode + ', ' +
                'message ' + error.body.message;
        });
    }

}