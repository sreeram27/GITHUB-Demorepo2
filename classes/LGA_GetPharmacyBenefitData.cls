/**
* @File Name          : LGA_GetPharmacyBenefitData.cls
* @Description        : 
* @Author             : Accenture OffShore 
* @Group              : Raptors
* @Modification Log   : 
* Ver       Date            Author      		        Modification
* 1.0    1/14/2020     Accenture OffShore              Initial Version
**/
public with sharing class LGA_GetPharmacyBenefitData {
    
    /**
    * @description : This metods returns the wrapperdata to be shown on the LWC component
    * @author Accenture Offshore | 1/24/2020 
    * @param qliID 
    * @return List<wrapPharmacyBenefitData> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<WrapPharmacyBenefitData> getPharmacyBenefitData(String recId){
        List<WrapPharmacyBenefitData> wrapPharmacyBenefitDataList = New List<WrapPharmacyBenefitData>();
        try {
            system.debug('@@@@@@@Inside The Apex Class' + recId );
            //String param = '%' + qliID + '%' ;
            String grpID;
            //String implCaseID;
            Implementation_Tracking__c impleTrack;
            impleTrack = [SELECT Id,Group_Number__c from Implementation_Tracking__c Where Id IN (Select Implementation_Tracking_ID__c From Rx__c where Id = :recId) LIMIT 50000 ];
            //system.debug('@@@@impleTrack : ' + impleTrack);
            //system.debug('@@@@impleTrack : ' + impleTrack.Group_Number__c);
            
            /*QuoteLineItem qliDetails= [Select Id,QuoteId, Quote.GroupNumber__c,Contract_Code_ASF__c,
                                    HPCC_Code__c,ProductStage__c FROM QuoteLineItem Where Id =: recId] ;
            
            system.debug('@@@@@@ Group Id: ' +qliDetails.Quote.GroupNumber__c );*/
            //grpID = qliDetails.Quote.GroupNumber__c;
            grpID = impleTrack.Group_Number__c;
            List<Group_Plan_Design__c> gpdDetailsList= [SELECT Id,Group__c,Group__r.Name,Group_Suffix__c,
                                                        QLI_Plan_Contract_Code__c,Plan_or_Product_Name__c,QLI_Funding__c,
                                                        Group_Plan_Description__c,Group_Suffix_Effective_Date__c,
                                                        QuoteLineItem_Record_ID__c,QuoteLineItem_Record_ID__r.Contract_Code_ASF__c,
                                                        QuoteLineItem_Record_ID__r.HPCC_Code__c, QuoteLineItem_Record_ID__r.ProductStage__c,
                                                        QuoteLineItem_Record_ID__r.ProductLOB__c, QuoteLineItem_Record_ID__r.ProductCategory__c,
                                                        QuoteLineItem_Record_ID__r.Pharmacy_Benefit_Identifier__c,
                                                    QuoteLineItem_Record_ID__r.Plan_Type__c
                                                        From Group_Plan_Design__c Where Group__c =:grpID 
                                                        AND QuoteLineItem_Record_ID__r.ProductLOB__c = :LGA_Constants.MEDICAL_LOB
                                                        AND QuoteLineItem_Record_ID__r.ProductCategory__c = :LGA_Constants.PLAN
                                                        AND (QuoteLineItem_Record_ID__r.ProductStage__c =: LGA_Constants.QLI_PRODUCT_STAGE_SOLD OR QuoteLineItem_Record_ID__r.ProductStage__c =: LGA_Constants.QLI_PRODUCT_STAGE_IGAPSOLD)
                                                        AND (QuoteLineItem_Record_ID__r.Plan_Type__c =:LGA_Constants.CUSTOM OR QuoteLineItem_Record_ID__r.Plan_Type__c =:LGA_Constants.MODIFIED ) LIMIT 50000 ];
            
            //system.debug('@@@@@gpdDetailsList: ' + gpdDetailsList);
            //system.debug('@@@@@gpdDetailsList: ' + gpdDetailsList.size());
            if(!gpdDetailsList.isEmpty()){
                for(Group_Plan_Design__c gpd : gpdDetailsList){
                    wrapPharmacyBenefitDataList.add(new WrapPharmacyBenefitData(gpd));
                }
                
            }
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }
        
        //system.debug('@@@@@@wrapPharmacyBenefitDataList' + wrapPharmacyBenefitDataList);
        //system.debug('@@@@@@wrapPharmacyBenefitDataList' + wrapPharmacyBenefitDataList.Size());
        //system.debug('@@@@@@wrapPharmacyBenefitDataList' + wrapPharmacyBenefitDataList[0].gpdDetails);
        return wrapPharmacyBenefitDataList;
    }
    
    
    public with sharing class WrapPharmacyBenefitData {
        // This is the wrappaer class used populate the LWC Table.
        //@AuraEnabled public QuoteLineItem qliData {get;set;}
        @AuraEnabled public Group_Plan_Design__c gpdDetails {get;set;}
        @AuraEnabled public String grpName {get;set;}
        @AuraEnabled public String grpSuffix {get;set;}
        @AuraEnabled public String grpContractCode {get;set;}
        @AuraEnabled public String qliCustContractCode {get;set;}
        @AuraEnabled public String qliHPCC {get;set;}
        @AuraEnabled public String grpPlan {get;set;}
        @AuraEnabled public String grpPlanType {get;set;}
        @AuraEnabled public String grpFunding {get;set;}
        @AuraEnabled public String qliProdStage {get;set;}
        @AuraEnabled public String grpDescription {get;set;}
        @AuraEnabled public Date grpEffDate {get;set;}
        @AuraEnabled public String pharBenefit {get;set;}
        @AuraEnabled public String qliID {get;set;}
        @AuraEnabled public String gpdID {get;set;}
        
        public WrapPharmacyBenefitData(Group_Plan_Design__c gpdList){    
            grpName = gpdList.Group__r.Name;
            grpSuffix = gpdList.Group_Suffix__c;
            grpContractCode = gpdList.QLI_Plan_Contract_Code__c;
            qliCustContractCode = gpdList.QuoteLineItem_Record_ID__r.Contract_Code_ASF__c; //qli.Contract_Code_ASF__c;
            qliHPCC = gpdList.QuoteLineItem_Record_ID__r.HPCC_Code__c; //qli.HPCC_Code__c;
            grpPlan = gpdList.Plan_or_Product_Name__c;
            grpFunding = gpdList.QLI_Funding__c;
            qliProdStage = gpdList.QuoteLineItem_Record_ID__r.ProductStage__c; //qli.ProductStage__c;
            grpDescription = gpdList.Group_Plan_Description__c;
            
            /*if(gpdList.Group_Suffix_Effective_Date__c != null){
                system.debug('@@@@@@@@@gpdList.Group_Suffix_Effective_Date__c:    '+ string.valueOf(gpdList.Group_Suffix_Effective_Date__c).Split('T')[0]);
                grpEffDate = string.valueOf(gpdList.Group_Suffix_Effective_Date__c).Split('T')[0];
            }else{
                grpEffDate = gpdList.Group_Suffix_Effective_Date__c; //gpdList.Group_Suffix_Effective_Date__c date(
            } */
            grpEffDate = gpdList.Group_Suffix_Effective_Date__c;
            
            pharBenefit = gpdList.QuoteLineItem_Record_ID__r.Pharmacy_Benefit_Identifier__c;//Pharmacy_Benefit_Identifier__c
            qliID = gpdList.QuoteLineItem_Record_ID__c;
            grpPlanType = gpdList.QuoteLineItem_Record_ID__r.Plan_Type__c;
            gpdID = gpdList.Id;
        }
    }

   
    /**
    * @description : This method retunrs the current user's profile name.
    * @author Accenture Offshore | 1/31/2020 
    * @param userID 
    * @return List<UserProfileDetails> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<UserProfileDetails> showLWCdata(String userID){ //String userID
        List<UserProfileDetails> usrPrfDetails = New List<UserProfileDetails>();
        try {
            system.debug('@@@Inside showLWCdata: ' + userID );
            
            String usrProfileName;
            for(Profile pf : [SELECT Id,Name FROM Profile Where Id in (Select ProfileId FROM User Where Id =:userID ) LIMIT 1]){
                //system.debug('@@@Inside For: ' + pf );
                //system.debug('@@@Inside For 2: ' + showData );
                usrProfileName = pf.Name;
            }
            //if(usrProfileName != Null && usrProfileName != '' ){
            if(String.isNotBlank(usrProfileName)){
                //system.debug('@@@@@@ Inside If: ' + usrProfileName);
                usrPrfDetails.add(new UserProfileDetails(usrProfileName));
            }
            
            //system.debug('@@@@@@usrPrfDetails: ' + usrPrfDetails);
            system.debug('@@@@@@usrPrfDetails: ' + usrPrfDetails.size());
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }        

        return usrPrfDetails;
    }

    public with sharing class UserProfileDetails{
        
        //@AuraEnabled public String userId {get;set;}
        @AuraEnabled public Boolean userProfileName {get;set;}

        public UserProfileDetails(String profileName){    
            if (profileName == LGA_Constants.SME || profileName == LGA_Constants.SME_DUAL || profileName == LGA_Constants.SYSTEM_ADMINISTRATOR ){
                userProfileName = true;
            }
            else{
                userProfileName =false;
            }
            //userProfileName = profileName;
        }
    }


    /**
    * @description : This method updates Pharmacy Benefit Identifier data on QLI and passes the updated data to LWC Component.
    * @author Accenture Offshore | 2/4/2020 
    * @param saveData 
    * @param rxId   
    * @return List<WrapPharmacyBenefitData> 
    **/
    @AuraEnabled
    public static List<WrapPharmacyBenefitData> savePBIData(List<Map<String,String>> saveData,String rxId){ //List<WrapPharmacyBenefitData>

        try {
            system.debug('@@@@@@@@@Inside savePBIData: ' + saveData);
            //system.debug('@@@@@@@@@Inside savePBIData: ' + rxId);
            List<QuoteLineItem> qliList = New List<QuoteLineItem>();
            Map<String,QuoteLineItem> qliMap = New Map<String,QuoteLineItem>();
            QuoteLineItem qli;
            for(Map<String,String> obj : saveData ){
                //system.debug('@@@@@@@@@Inside savePBIData For: ' + obj);
                //system.debug('@@@@@@@@@Inside savePBIData For: ' + obj.get(LGA_Constants.ID));
                //QuoteLineItem qli = new QuoteLineItem();
                qli = new QuoteLineItem();
                qli.Id = obj.get(LGA_Constants.ID);
                qli.Pharmacy_Benefit_Identifier__c = obj.get(LGA_Constants.NAME);
                qliMap.put(obj.get(LGA_Constants.ID),qli );
                //system.debug('@@@@@@@@@Inside savePBIData For: ' + qliMap);
                //qliList.add(qli);
    
            }
            for(String qliIds:qliMap.keySet() ){
                //system.debug('@@@@@@@@@Inside savePBIData For 164: ' + qliMap);
                qliList.add(qliMap.get(qliIds));
            }
            if(!qliList.isEmpty()){
                //system.debug('@@@@@@@@@Inside savePBIData If 167: ' + qliList);
                database.update(qliList,false);
            }   
    
        } catch (Exception ex) {
            system.debug('****The following exception has occurred: ' + ex.getMessage());
        }
 
        return getPharmacyBenefitData(rxId);
        
    }


}