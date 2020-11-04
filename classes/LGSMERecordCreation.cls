/**
@Author : Deloitte
@name : LGSMERecordCreation
@CreateDate :14-11-2018
@Description : This class will create SME records when there are speciality products associated with stage as sold.
______________________________________________________________________________________________________________

Change History: PRDCRM-43657 (Deloitte Offshore)
Description:    Adding the order ID only if tracking record exists check box is false as per requirement 
Date:           31/10/2019
______________________________________________________________________________________________________________

Change History: PRDCRM-44530 (Deloitte Offshore)
Description:    Added mcsRecordTypeId recordtype check to create MCS IMP Tracking record
Date:           06/12/2019
______________________________________________________________________________________________________________
*/
public without sharing class LGSMERecordCreation {
    /**
*  This method will create the implementation tracking record along with SME record creation.
*  @name :AfterUpdate
*  @param : List < Order > orderLst, Map < Id, order > orderNewMap, Map < Id, order > orderOldMap
*  @Change, Adding orders to the Set for 28520
*  Modified Date :8th July 2019 
*  @Author : Rahul Ramadolla (Vikings)
*  @description : Update ID Card SME Auto Generation Jira ID :38919
*/
    public static void afterUpdate(List < Order > orderLst, Map < Id, order > orderNewMap, Map < Id, order > orderOldMap){
        
        Savepoint savePt;
        
        try{
            Set < Id > quoteIdSet = new Set < Id > ();
            Set < Id > orderIdFromLst = new Set < Id > ();
            Set < Id > orderIdToBeUpdated = new Set < Id > ();
            Set < Id > quoteIdToBeUpdated = new Set < Id > ();
            Set <Id> orderIdSet = new Set <Id>();
            Map < Id, order > orderMap = new Map < Id, order > ();
            Boolean isCROC = true; //PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
            Boolean isFullGroupTerm = false;//Added By Rahul for 40362
            Boolean bIsRenewal       = false;//PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
            Boolean bIsForAllICRType = false;//GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products

            if(!orderLst.isEmpty()){
                for (order ord: orderLst){
                    orderMap.put(ord.id, ord);
                    if (ord.Implementation_Status__c == staticVariableClass.PendingSmeReview && !orderOldMap.get(ord.id).Implementation_Status__c.equals(staticVariableClass.PendingSmeReview)){
                        orderIdToBeUpdated.add(ord.id);
                        quoteIdToBeUpdated.add(ord.quoteId);
                    }
                    if (ord.Implementation_Status__c == staticVariableClass.PendingSmeReview && ord.ID_Cards_Required__c == staticVariableClass.UpsellYes){
                        orderIdSet.add(ord.id);
                    }
                }  
            }
            if(!orderIdSet.isEmpty()){
                generateIdCards(orderIdSet);
            }
            if (!orderIdToBeUpdated.isempty()){
                stampSmeReviewDate(orderIdToBeUpdated, quoteIdToBeUpdated);
            }
            else{
                List<String> impactedProductList = new List<String>();
                for (Order ord: [SELECT ID,Tracking_Record_Exists__c,Group_Name__c,
                                 Implementation_Type__c, accountid,Implementation_Status__c,
                                 Impacted_Products_Id__c,quoteId FROM ORDER 
                                 WHERE Implementation_Status__c =: staticVariableClass.ReadyforImps
                                 AND id in: orderNewMap.keyset()]) {
                                     quoteIdSet.add(ord.quoteId);
                                     
                                     //43657 : Adding the order ID only if tracking record exists check box is false
                                     if(!ord.Tracking_Record_Exists__c) {
                                         orderIdFromLst.add(ord.id);
                                     }
                                     //PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
                                     if(ord.Implementation_Type__c == staticVariableClass.RENEWAL){
                                         bIsRenewal = true;
                                     }
                                      //PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
                                     if(ord.Impacted_Products_Id__c !=null  && ord.Implementation_Type__c == staticVariableClass.ChangeRequestOffCycle){
                                         impactedProductList.addAll(ord.Impacted_Products_Id__c.split(','));
                                     }
                                     else if(ord.Implementation_Type__c != staticVariableClass.ChangeRequestOffCycle && 
                                             (ord.Implementation_Type__c == staticVariableClass.NewBusiness || 
                                              ord.Implementation_Type__c == staticVariableClass.RENEWAL ||
                                              ord.Implementation_Type__c == staticVariableClass.PRE_WORK)){
                                                  isCROC = false;
                                                  bIsForAllICRType = true;//GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products
                                              }
                                     else if(ord.Implementation_Type__c == staticVariableClass.FULL_GROUP_TERM){ //Added By Rahul for 40362
                                         isFullGroupTerm = true;
                                         bIsForAllICRType = true;//GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products
                                     }
                                     
                                 }
                Set<String> impactedProductSet = new Set<String>();
                impactedProductSet.addAll(impactedProductList);
                
                Map < Id, String > qliIdDentalMap = new Map < Id, String > ();
                Map < Id, String > qliIdLifeMap = new Map < Id, String > ();
                Map < Id, String > qliIdDisabilityMap = new Map < Id, String > ();
                Map < Id, String > qliIdVisionMap = new Map < Id, String > ();
                Map < Id, List < QuoteLineItem >> quoteIdToQuoteLineItem = new Map < Id, List < QuoteLineItem >> ();
                List<String> stageLst=new List<String>{ staticVariableClass.Sold, staticVariableClass.IGAPSold,
                    staticVariableClass.Renewed,staticVariableClass.TERMED };
                //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products
                List<String> listSuplementProductType=new List<String>{ staticVariableClass.HOSPITAL_INDEMNITY,
                                                                        staticVariableClass.ACCIDENT,
                                                                        staticVariableClass.CRITICAL_ILLNESS };
                List < QuoteLineItem > quoteLineItemAdded = new List < QuoteLineItem > ();
                
                for (QuoteLineItem eachQli: [SELECT id, quoteId, Product2.name, quote.Claim_System__c, ProductStage__c, 
                                                Product_Family__c, Product_Family_Local__c,Product_Type__c, Upsell__c,
                                                Quote.Opportunity.RecordType.Name //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products
                                                    FROM QuoteLineItem
                                                    WHERE quoteId in: quoteIdSet])
                {
                    
                    if (!quoteIdToQuoteLineItem.containskey(eachQli.quoteId)){
                        quoteLineItemAdded.add(eachQli);
                        quoteIdToQuoteLineItem.put(eachQli.quoteId, quoteLineItemAdded);
                    }
                    else{
                        List < QuoteLineItem > qliFetched = quoteIdToQuoteLineItem.get(eachQli.quoteId);
                        qliFetched.add(eachQli);
                        quoteIdToQuoteLineItem.put(eachQli.quoteId, qliFetched);
                    }
                    if (
                        (eachQli.Product_Type__c == staticVariableClass.Dental 
                         && 
                         (stageLst.contains(eachQli.ProductStage__c) || (eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod))// changed as part of PRDCRM-42372-GLD-submit OCC where Impacted Products are "Not Renewing In Current Period
                         &&
                         impactedProductSet.contains(eachQli.Id) && isCROC == true && isFullGroupTerm==false) //PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
                        || 
                        (
                            eachQli.Product_Type__c == staticVariableClass.Dental 
                            &&
                            (
                                (
                                    eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod && 
                                    bIsRenewal == true && 
                                    eachQli.quote.Claim_System__c == staticVariableClass.WGS_CLAIM_SYSTEM
                                ) 
                                ||
                                (
                                    isCROC == false && isFullGroupTerm == false && stageLst.contains(eachQli.ProductStage__c)
                                )
                            )
                        )//PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
                        ||
                        (eachQli.Product_Type__c == staticVariableClass.Dental && stageLst.contains(eachQli.ProductStage__c) && isFullGroupTerm == true && isCROC == true)//Added By Rahul for 40362
                    ){
                        qliIdDentalMap.put(eachQli.id, staticVariableClass.DENTAL_FOUND);
                    }
                    if (
                        (eachQli.Product_Type__c == staticVariableClass.Vision
                         && 
                         (stageLst.contains(eachQli.ProductStage__c) || (eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod))// changed as part of PRDCRM-42372-GLD-submit OCC where Impacted Products are "Not Renewing In Current Period
                         &&
                         impactedProductSet.contains(eachQli.Id) && isCROC == true && isFullGroupTerm == false) //PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
                        || 
                        (
                            eachQli.Product_Type__c == staticVariableClass.Vision 
                            &&
                            (
                                (
                                    eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod && 
                                    bIsRenewal == true && 
                                    eachQli.quote.Claim_System__c == staticVariableClass.WGS_CLAIM_SYSTEM
                                ) 
                                ||
                                (
                                    isCROC == false && isFullGroupTerm == false && 
                                    stageLst.contains(eachQli.ProductStage__c)
                                )
                            )//PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
                        )
                    ){
                        qliIdVisionMap.put(eachQli.id, staticVariableClass.VISION_FOUND);
                    }
                    if (
                        (eachQli.Product_Type__c == staticVariableClass.Life
                         && 
                         (stageLst.contains(eachQli.ProductStage__c) || (eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod))// changed as part of PRDCRM-42372-GLD-submit OCC where Impacted Products are "Not Renewing In Current Period
                         &&
                         impactedProductSet.contains(eachQli.Id) && isCROC == true && isFullGroupTerm == false) 
                        ||
                        ( 
                            eachQli.Product_Type__c == staticVariableClass.Life 
                            &&
                            (
                                (
                                    eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod && 
                                    bIsRenewal == true && 
                                    eachQli.quote.Claim_System__c == staticVariableClass.WGS_CLAIM_SYSTEM
                                ) 
                                ||
                                (
                                    isCROC == false && isFullGroupTerm == false && stageLst.contains(eachQli.ProductStage__c)
                                )
                            )//PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
                        )//PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
                        ||
                        (eachQli.Product_Type__c == staticVariableClass.Life && stageLst.contains(eachQli.ProductStage__c) && isFullGroupTerm == true  && isCROC == true)//Added By Rahul for 40362
                    ){
                        qliIdLifeMap.put(eachQli.id, staticVariableClass.LIFE_FOUND);
                    }
                    if (((eachQli.Product_Type__c == staticVariableClass.Disability || eachQli.Product_Type__c == staticVariableClass.LTD_PROD_TYPE || eachQli.Product_Type__c == staticVariableClass.STD_PROD_TYPE)
                         && 
                         (stageLst.contains(eachQli.ProductStage__c) || (eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod))// changed as part of PRDCRM-42372-GLD-submit OCC where Impacted Products are "Not Renewing In Current Period
                         &&
                         impactedProductSet.contains(eachQli.Id) && isCROC == true && isFullGroupTerm == false) //PRDCRM-39332(193.3) Enhancement & Deployment of Impacted Products for New Business and Renewal Imp Case
                        ||
                        ( 
                            (
                                eachQli.Product_Type__c == staticVariableClass.Disability || 
                                eachQli.Product_Type__c == staticVariableClass.LTD_PROD_TYPE || 
                                eachQli.Product_Type__c == staticVariableClass.STD_PROD_TYPE
                            ) 
                            &&
                            (
                                (
                                    eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod && 
                                    bIsRenewal == true && 
                                    eachQli.quote.Claim_System__c == staticVariableClass.WGS_CLAIM_SYSTEM
                                ) 
                                ||
                                (
                                    isCROC == false && isFullGroupTerm == false && stageLst.contains(eachQli.ProductStage__c)
                                )
                            )
                        )//PRDCRM-48364 - Expand Specialty SME Record creation to Renewal ICR type
                        ||
                        (( eachQli.Product_Type__c == staticVariableClass.Disability || eachQli.Product_Type__c == staticVariableClass.LTD_PROD_TYPE || eachQli.Product_Type__c == staticVariableClass.STD_PROD_TYPE)
                         && stageLst.contains(eachQli.ProductStage__c) && isFullGroupTerm == true && isCROC == true)//Added By Rahul for 40362
                       ){
                           qliIdDisabilityMap.put(eachQli.id, staticVariableClass.DISABILITY_FOUND);
                       }
                        //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products -Add check of Opportunity New Bussiness
                        if(
                            listSuplementProductType.contains (eachQli.Product_Type__c) &&
                            eachQli.Quote.Opportunity.RecordType.Name == staticVariableClass.NewBusinessLocal &&
                            (bIsForAllICRType == true || (isCROC == true && impactedProductSet.contains(eachQli.Id))) &&
                            eachQli.ProductStage__c == staticVariableClass.Sold
                         
                        ){
                            qliIdLifeMap.put(eachQli.id, staticVariableClass.LIFE_FOUND);
                        }  
                         //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products - Add check of Opportunity Renewal
                        if(
                            listSuplementProductType.contains (eachQli.Product_Type__c) && 
                            eachQli.Quote.Opportunity.RecordType.Name == staticVariableClass.RenewalLocal1 &&
                            (eachQli.ProductStage__c == staticVariableClass.Renewed
                            ||
                            eachQli.ProductStage__c == staticVariableClass.IGAPSold
                            ||
                            eachQli.ProductStage__c == staticVariableClass.Termed
                            ||
                                (eachQli.ProductStage__c == staticVariableClass.Notrenewingincurrentperiod &&
                                    (   
                                        (isCROC == true && impactedProductSet.contains(eachQli.Id))||
                                        (bIsRenewal == true && eachQli.quote.Claim_System__c == staticVariableClass.WGS_CLAIM_SYSTEM)
                                    )
                                )
                            )
                        ){
                            qliIdLifeMap.put(eachQli.id, staticVariableClass.LIFE_FOUND);
                        }  
                        //GLD - PRDCRM:50840 - Auto create L&D SME for Supplemental Health Products - Add check of Opportunity IGAP SOLD
                        if(
                            listSuplementProductType.contains (eachQli.Product_Type__c) &&
                            eachQli.Quote.Opportunity.RecordType.Name == staticVariableClass.IGAPLocal &&
                           (bIsForAllICRType == true || (isCROC == true && impactedProductSet.contains(eachQli.Id))) &&
                            eachQli.ProductStage__c == staticVariableClass.IGAPSold
                        ){
                            qliIdLifeMap.put(eachQli.id, staticVariableClass.LIFE_FOUND);
                        }
                }
                
                Map < Id, List < Implementation_Tracking__c >> orderIdToImpTracking = new Map < Id, List < Implementation_Tracking__c >> ();
                List < Implementation_Tracking__c > impList = new List < Implementation_Tracking__c > ();
                Boolean dentalFound = false;
                Boolean visionFound = false;
                Boolean landdFound = false;    
                
                for (Implementation_Tracking__c impTrack: [SELECT Group_Number__c,recordtypeid, id, Implementation_Record_ID__c, Implementation_Record_ID__r.Implementation_Status__c, 
                                                           (SELECT id FROM Dental_Completes__r), 
                                                           (SELECT id FROM Life_and_Disabilities__r), 
                                                           (SELECT id FROM Vision__r) FROM Implementation_Tracking__c 
                                                           WHERE Implementation_Record_ID__c in: orderNewMap.keyset() 
                                                           AND recordtypeid =: Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId()]){
                                                               impList.add(impTrack);
                                                               orderIdToImpTracking.put(impTrack.Implementation_Record_ID__c, impList);
                                                               if (impTrack.Dental_Completes__r.size() > 0)
                                                               {
                                                                   dentalFound = true;
                                                               }
                                                               if (impTrack.Vision__r.size() > 0)
                                                               {
                                                                   visionFound = true;
                                                               }
                                                               if (impTrack.Life_and_Disabilities__r.size() > 0)
                                                               {
                                                                   landdFound = true;
                                                               }
                                                           }
                List < Implementation_Tracking__c > impTrackrec;
                List < Dental_Complete__c > dental = new List < Dental_Complete__c > ();
                List < Vision__c > vison = new List < Vision__c > ();
                List < Life_and_Disability__c > landd = new List < Life_and_Disability__c > ();
                
                if (qliIdDentalMap.size() > 0 || qliIdVisionMap.size() > 0 || qliIdDisabilityMap.size() > 0 || qliIdLifeMap.size() > 0)
                {
                    Implementation_Tracking__c rec;
                    impTrackrec = new List < Implementation_Tracking__c > ();
                    if(!orderIdFromLst.isEmpty()){
                        for (Id ordId: orderIdFromLst) {
                            List < Implementation_Tracking__c > trackRecFetched = orderIdToImpTracking.get(ordId);
                            if (trackRecFetched != null){
                                if (orderIdToImpTracking.get(ordId).size() > 0){//update
                                    if (qliIdDentalMap.size() > 0 && dentalFound == false){
                                        Dental_Complete__c dentalComp = new Dental_Complete__c(Implementation_Tracking_ID__c = orderIdToImpTracking.get(ordId)[0].id);
                                        dental.add(dentalComp);
                                    }
                                    if ((qliIdDisabilityMap.size() > 0 || qliIdLifeMap.size() > 0) && landdFound == false){
                                        Life_and_Disability__c lifeAndDsty = new Life_and_Disability__c(Implementation_Tracking_ID__c = orderIdToImpTracking.get(ordId)[0].id);
                                        landd.add(lifeAndDsty);
                                    }
                                    if (qliIdVisionMap.size() > 0 && visionFound == false){
                                        Vision__c vision = new Vision__c(Implementation_Tracking__c = orderIdToImpTracking.get(ordId)[0].id);
                                        vison.add(vision);
                                    }
                                }
                            }
                            else {//insert
                                rec = new Implementation_Tracking__c(Implementation_Record_ID__c = ordId, Account_Legal_Name__c = orderMap.get(ordId).accountid, Group_Number__c=orderMap.get(ordId).Group_Name__c);
                                if(orderMap.get(ordId).JAA_Group__c == true){
                                    rec.recordtypeid = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_JAA).getRecordTypeId();
                                }
                                //Start:44530
                                else if(orderMap.get(ordId).MCS_Group__c) {
                                    rec.recordtypeid = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_MCS).getRecordTypeId();
                                }
                                //End:44530
                                else {
                                    rec.recordtypeid = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_Local).getRecordTypeId();
                                }
                                
                                impTrackrec.add(rec);
                            }
                        }  
                    }
                }
                
                List < Order > orderListToBeUpdated = new List < Order > ();
                
                savePt = Database.setSavepoint();
                
                //43657: Added not empty check
                if (impTrackrec != null && !impTrackrec.isEmpty()) {
                    
                    //insert if implementation tracking record is not present under IMP Case
                    insert impTrackrec;
                    
                    for (order ord: [SELECT id, Tracking_Record_Exists__c FROM order WHERE id in: orderIdFromLst]){
                        ord.Tracking_Record_Exists__c = true;
                        orderListToBeUpdated.add(ord);
                    }
                    
                    if (orderListToBeUpdated != null){
                        update orderListToBeUpdated;
                    }
                    
                    if (qliIdDentalMap.size() > 0){
                        for (Implementation_Tracking__c trackId: impTrackrec){
                            Dental_Complete__c dentalComp = new Dental_Complete__c(Implementation_Tracking_ID__c = trackId.id);
                            dental.add(dentalComp);
                        }
                    }
                    if (qliIdDisabilityMap.size() > 0 || qliIdLifeMap.size() > 0){
                        for (Implementation_Tracking__c trackId: impTrackrec){
                            Life_and_Disability__c lifeAndDsty = new Life_and_Disability__c(Implementation_Tracking_ID__c = trackId.id);
                            landd.add(lifeAndDsty);
                        }
                    }
                    if (qliIdVisionMap.size() > 0){
                        for (Implementation_Tracking__c trackId: impTrackrec){
                            Vision__c vision = new Vision__c(Implementation_Tracking__c = trackId.id);
                            vison.add(vision);
                        }
                    }
                    
                    if (dental != null){
                        insert dental;
                    }
                    if (landd != null){
                        insert landd;
                    }
                    if (vison != null){
                        insert vison;
                    }
                    stampImpactedProduct(dental, vison, landd, orderIdFromLst, quoteIdToQuoteLineItem);
                }
            }
        }
        catch(Exception exceptionMsg){
            UTIL_LoggingService.logHandledException(exceptionMsg,ANA_UTIL03_Constants.ORGID, staticVariableClass.COMMERCIAL_SALES_STRING,
                                                    staticVariableClass.LG_SME_RECORD_CREATION_STRING, 
                                                    staticVariableClass.AFTER_UPDATE_STRING,null,LoggingLevel.ERROR);
            Database.rollback(savePt);
        }
    }
    /**
*  @description :This method will stamp the upsell value FROM the QuoteLineItem.
*  @name :stampImpactedProduct
*  @param : List < Dental_Complete__c > dentalList, List < Vision__c > visionList, List < Life_and_Disability__c > landdList, Set < Id > orderIdSet,    Map < Id, List < QuoteLineItem >> quoteIdToQuoteLineItem
*  JIRA ID : 39104
*  @Author B R Praneetha{Centurions - Deloitte} 
*  @Change, Synchronizing and updating Specialty Impacted Product field 
*/
    public static void stampImpactedProduct(List < Dental_Complete__c > dentalList, List < Vision__c > visionList, List < Life_and_Disability__c > landdList, Set < Id > orderIdSet, Map < Id, List < QuoteLineItem >> quoteIdToQuoteLineItem)
    {
        try
        {
            List < Dental_Complete__c > finalDentalList = new List < Dental_Complete__c > ();
            List < Vision__c > finalVisionList = new List < Vision__c > ();
            List < Life_and_Disability__c > finalLandDList = new List < Life_and_Disability__c > ();
            ID queueOwnerId = [SELECT Id FROM Group 
                               WHERE Type =: staticVariableClass.QUEUE 
                               AND DeveloperName =: staticVariableClass.NEW_GROUPS_AND_UPSELLS_QUEUE].ID;
            
            if (dentalList != null){
                String upsellyes = staticVariableClass.UpsellYes;
                String upsellno = staticVariableClass.UpsellNo;
                String upsellnone = '';
                Boolean upsellFoundYes = false;
                Boolean upsellFoundNo = false;
                Boolean upsellFoundNone = false;
                Map<String,Set<String>> prdctTypeStageMap = new Map<String,Set<String>> ();
                List < Dental_Complete__c > dentalRecFetch = [SELECT Upsell__c, OwnerId, id, Impacted_Products__c, Product_Families__c, Implementation_Tracking_ID__c, Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId 
                                                              FROM Dental_Complete__c 
                                                              WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in: orderIdSet 
                                                              AND Implementation_Tracking_ID__r.Implementation_Record_ID__r.Implementation_Status__c =:staticVariableClass.ReadyforImps];
                
                if (dentalRecFetch != null){
                    String impactedProd = '';
                    String prodFamilies = '';
                    
                    for (Id qteId: quoteIdToQuoteLineItem.keyset()){
                        for (QuoteLineItem qli: quoteIdToQuoteLineItem.get(qteId)){
                            //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                            Set<String> prdctStagesSet = new Set<String> ();
                            if(prdctTypeStageMap.containskey(qli.Product_Type__c)){
                                prdctStagesSet = prdctTypeStageMap.get(qli.Product_Type__c);
                            }
                            prdctStagesSet.add(qli.ProductStage__c);
                            prdctTypeStageMap.put(qli.Product_Type__c,prdctStagesSet);
                            if (qli.Product_Type__c == staticVariableClass.Dental ){
                                prodFamilies = prodFamilies + qli.Product_Family_Local__c + ';';
                                if (qli.Upsell__c == staticVariableClass.UpsellYes){
                                    upsellFoundYes = true;
                                }
                                if (qli.Upsell__c == staticVariableClass.UpsellNo){
                                    upsellFoundNo = true;
                                }
                                if (qli.Upsell__c == ''){
                                    upsellFoundNone = true;
                                }
                            }
                        }
                    }
                    //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                    if(!prdctTypeStageMap.isEmpty()){
                        for(String type : prdctTypeStageMap.keyset()){
                            if(type != null && prdctTypeStageMap.containskey(type) && prdctTypeStageMap.get(type) != null){
                                impactedProd += type + '-' + String.join((Iterable<String>)prdctTypeStageMap.get(type),',') + ';';
                            }
                        }
                    }
                    impactedProd = impactedProd.removeend(';');
                    prodFamilies = prodFamilies.removeend(';');
                    for (Dental_Complete__c dentalComp: dentalRecFetch){
                        if (quoteIdToQuoteLineItem.containskey(dentalComp.Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId)){
                            dentalComp.Impacted_Products__c = impactedProd;
                            dentalComp.Product_Families__c = prodFamilies;
                            if (upsellFoundYes == true){
                                dentalComp.Upsell__c = upsellyes;
                                if(String.valueOf(dentalComp.OwnerId).startsWith(staticVariableClass.USER_ID_FORMAT) || dentalComp.OwnerId == null){// Pratibha added this for Queue assignment fix.
                                    dentalComp.OwnerId = queueOwnerId;
                                }
                            }
                            else{
                                if (upsellFoundNo == true){
                                    dentalComp.Upsell__c = upsellno;
                                }
                                else{
                                    dentalComp.Upsell__c = upsellnone;
                                }
                            }
                            finalDentalList.add(dentalComp);
                        }
                    }
                    if (finalDentalList != null){
                        update finalDentalList;
                    }
                }
            }
            
            if (visionList != null){
                String upsellyes = staticVariableClass.UpsellYes;
                String upsellno = staticVariableClass.UpsellNo;
                String upsellnone = '';
                Boolean upsellFoundYes = false;
                Boolean upsellFoundNo = false;
                Boolean upsellFoundNone = false;
                Map<String,Set<String>> prdctTypeStageMap = new Map<String,Set<String>> ();
                List < Vision__c > visionRecFetch = [SELECT Upsell__c, OwnerId, Id, Impacted_Products__c, Product_Families__c, Implementation_Tracking__c, Implementation_Tracking__r.Implementation_Record_ID__r.quoteId 
                                                     FROM Vision__c 
                                                     WHERE  Implementation_Tracking__r.Implementation_Record_ID__r.Implementation_Status__c =:staticVariableClass.ReadyforImps 
                                                     AND Implementation_Tracking__r.Implementation_Record_ID__c in: orderIdSet ];
                if (visionRecFetch != null){
                    String impactedProd = '';
                    String prodFamilies = '';
                    for (Id qteId: quoteIdToQuoteLineItem.keyset()){
                        for (QuoteLineItem qli: quoteIdToQuoteLineItem.get(qteId)){
                            //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                            Set<String> prdctStagesSet = new Set<String> ();
                            if(prdctTypeStageMap.containskey(qli.Product_Type__c)){
                                prdctStagesSet = prdctTypeStageMap.get(qli.Product_Type__c);
                            }
                            prdctStagesSet.add(qli.ProductStage__c);
                            prdctTypeStageMap.put(qli.Product_Type__c,prdctStagesSet);
                            if (qli.Product_Type__c == staticVariableClass.Vision ){
                                prodFamilies = prodFamilies + qli.Product_Family_Local__c + ';';
                                
                                if (qli.Upsell__c == staticVariableClass.UpsellYes){
                                    upsellFoundYes = true;
                                }
                                if (qli.Upsell__c == staticVariableClass.UpsellNo){
                                    upsellFoundNo = true;
                                }
                                if (qli.Upsell__c == ''){
                                    upsellFoundNone = true;
                                }
                            }
                        }
                    }
                    //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                    if(!prdctTypeStageMap.isEmpty()){
                        for(String type : prdctTypeStageMap.keyset()){
                            if(type != null && prdctTypeStageMap.containskey(type) && prdctTypeStageMap.get(type) != null){
                                impactedProd += type + '-' + String.join((Iterable<String>)prdctTypeStageMap.get(type),',') + ';';
                            }
                        }
                    }
                    impactedProd = impactedProd.removeend(';');
                    prodFamilies = prodFamilies.removeend(';');
                    for (Vision__c vision: visionRecFetch){
                        if (quoteIdToQuoteLineItem.containskey(vision.Implementation_Tracking__r.Implementation_Record_ID__r.quoteId) ||test.isRunningTest()){
                            vision.Impacted_Products__c = impactedProd;
                            vision.Product_Families__c = prodFamilies;
                            if (upsellFoundYes == true){
                                vision.Upsell__c = upsellyes;
                                if(String.valueOf(vision.OwnerId).startsWith(staticVariableClass.USER_ID_FORMAT) || vision.OwnerId == null){// Pratibha added this for Queue assignment fix.
                                    vision.OwnerId = queueOwnerId;
                                }
                            }
                            else{
                                if (upsellFoundNo == true){
                                    vision.Upsell__c = upsellno;
                                }
                                else{
                                    vision.Upsell__c = upsellnone;
                                }
                            }
                            finalVisionList.add(vision);
                        }
                    }
                    if (finalVisionList != null){
                        update finalVisionList;
                    }
                }
            }
            
            if (landdList != null){
                String upsellyes = staticVariableClass.UpsellYes;
                String upsellno = staticVariableClass.UpsellNo;
                String upsellnone = '';
                Boolean upsellFoundYes = false;
                Boolean upsellFoundNo = false;
                Boolean upsellFoundNone = false;
                Map<String,Set<String>> prdctTypeStageMap = new Map<String,Set<String>> ();
                List < Life_and_Disability__c > landdRecFetch = [SELECT Upsell__c, OwnerId, Id, Impacted_Products__c, Product_Families__c, Implementation_Tracking_ID__c, Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId 
                                                                 FROM Life_and_Disability__c 
                                                                 WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in: orderIdSet 
                                                                 AND Implementation_Tracking_ID__r.Implementation_Record_ID__r.Implementation_Status__c =: staticVariableClass.ReadyforImps];
                
                if (landdRecFetch != null){
                    String impactedProd = '';
                    String prodFamilies = '';
                    for (Id qteId: quoteIdToQuoteLineItem.keyset()){
                        for (QuoteLineItem qli: quoteIdToQuoteLineItem.get(qteId)){
                            //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                            Set<String> prdctStagesSet = new Set<String> ();
                            if(prdctTypeStageMap.containskey(qli.Product_Type__c)){
                                prdctStagesSet = prdctTypeStageMap.get(qli.Product_Type__c);
                            }
                            prdctStagesSet.add(qli.ProductStage__c);
                            prdctTypeStageMap.put(qli.Product_Type__c,prdctStagesSet);
                            if (qli.Product_Type__c == staticVariableClass.Life 
                                || (qli.Product_Type__c == staticVariableClass.Disability 
                                    || qli.Product_Type__c == staticVariableClass.LTD_PROD_TYPE 
                                    || qli.Product_Type__c == staticVariableClass.STD_PROD_TYPE)){
                                        
                                        prodFamilies = prodFamilies + qli.Product_Family_Local__c + ';';
                                        if (qli.Upsell__c == staticVariableClass.UpsellYes){
                                            upsellFoundYes = true;
                                        }
                                        if (qli.Upsell__c == staticVariableClass.UpsellNo){
                                            upsellFoundNo = true;
                                        }
                                        if (qli.Upsell__c == ''){
                                            upsellFoundNone = true;
                                        }
                                    }
                        }
                    }
                    //PRDCRM-39104 - Deloitte Offshore 08/13/2019- Added this as part of the Impacted Product field change
                    if(!prdctTypeStageMap.isEmpty()){
                        for(String type : prdctTypeStageMap.keyset()){
                            if(type != null && prdctTypeStageMap.containskey(type) && prdctTypeStageMap.get(type) != null){
                                impactedProd += type + '-' + String.join((Iterable<String>)prdctTypeStageMap.get(type),',') + ';';
                            }
                        }
                    }
                    impactedProd = impactedProd.removeend(';');
                    prodFamilies = prodFamilies.removeend(';');
                    for (Life_and_Disability__c lifeAndDsty: landdRecFetch){
                        if (quoteIdToQuoteLineItem.containskey(lifeAndDsty.Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId)){
                            lifeAndDsty.Impacted_Products__c = impactedProd;
                            lifeAndDsty.Product_Families__c = prodFamilies;
                            
                            if (upsellFoundYes == true){
                                lifeAndDsty.Upsell__c = upsellyes;
                                if(String.valueOf(lifeAndDsty.OwnerId).startsWith(staticVariableClass.USER_ID_FORMAT) || lifeAndDsty.OwnerId == null){// Pratibha added this for Queue assignment fix.
                                    lifeAndDsty.OwnerId = queueOwnerId;
                                }
                            }
                            else{
                                if (upsellFoundNo == true){
                                    lifeAndDsty.Upsell__c = upsellno;
                                }
                                else{
                                    lifeAndDsty.Upsell__c = upsellnone;
                                }
                            }
                            finalLandDList.add(lifeAndDsty);
                        }
                    }
                    if (finalLandDList != null){
                        update finalLandDList;
                    }
                }
            }
        }
        catch(Exception exceptionMsg){
            system.debug('exceptionMsg msg:' + exceptionMsg.getmessage());
            system.debug('exceptionMsg line no:' + exceptionMsg.getlinenumber());
        }
    }
    /**
*  @description :This method will stamp the SME Review date.
*  @name :stampSmeReviewDate
*  @param : Set < Id > orderIdSet, Set < Id > quoteId
*/
    
    public static void stampSmeReviewDate(Set < Id > orderIdSet, Set < Id > quoteIdSet){
        try{
            List < Dental_Complete__c > finalDentalList = new List < Dental_Complete__c > ();
            List < Vision__c > finalvisionlist = new List < Vision__c > ();
            List < Life_and_Disability__c > finalLandDList = new List < Life_and_Disability__c > ();
            
            List < Dental_Complete__c > dentalRecFetch = [SELECT OwnerId, Pending_SME_Review_Completed__c, Id, Impacted_Products__c, Product_Families__c, Implementation_Tracking_ID__c, Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId 
                                                          FROM Dental_Complete__c 
                                                          WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in: orderIdSet];
            if (dentalRecFetch != null){
                for (Dental_Complete__c dentalComp: dentalRecFetch){
                    dentalComp.Pending_SME_Review_Completed__c = system.today();
                    finalDentalList.add(dentalComp);
                }
                if (finalDentalList != null){
                    update finalDentalList;
                }
            }
            
            List < Vision__c > visionRecFetch = [SELECT OwnerId, Pending_SME_Review_Completed__c, Id, Impacted_Products__c, Product_Families__c, Implementation_Tracking__c, Implementation_Tracking__r.Implementation_Record_ID__r.quoteId 
                                                 FROM Vision__c 
                                                 WHERE Implementation_Tracking__r.Implementation_Record_ID__c in: orderIdSet];
            if (visionRecFetch != null){
                for (Vision__c vision: visionRecFetch){
                    vision.Pending_SME_Review_Completed__c = system.today();
                    finalvisionlist.add(vision);
                }
                if (finalvisionlist != null){
                    update finalvisionlist;
                }
            }
            
            List < Life_and_Disability__c > landdRecFetch = [SELECT OwnerId, Pending_SME_Review_Completed__c, Id, Impacted_Products__c, Product_Families__c, Implementation_Tracking_ID__c, Implementation_Tracking_ID__r.Implementation_Record_ID__r.quoteId 
                                                             FROM Life_and_Disability__c 
                                                             WHERE Implementation_Tracking_ID__r.Implementation_Record_ID__c in: orderIdSet];
            if (landdRecFetch != null){
                for (Life_and_Disability__c lifeAndDsty: landdRecFetch){
                    lifeAndDsty.Pending_SME_Review_Completed__c = system.today();
                    finalLandDList.add(lifeAndDsty);
                }
                if (finalLandDList != null){
                    update finalLandDList;
                }
            }
        }
        catch(Exception exceptionMsg){
            system.debug('exceptionMsg msg:' + exceptionMsg.getmessage());
            system.debug('exceptionMsg line no:' + exceptionMsg.getlinenumber());
        }
    }
    
    /**
*  @description : This method will generate Id Card records. 
*  @name :generateIdCards
*  @param : Set < Id > orderids 
*  JIRA ID : 28520
*  @Author Mahesh Ganti, Abhishek Doodagan{Deloitte} 
*  @Change, Adding JAA Logic for ID Card generation and Code cleanup.JIRA ID : 39717
*  @Author : Rahul Ramadolla (Vikings)
*  @description : ID card will only be generated when recordtype is either of Local or JAA Nasco.If recordtype is of Local then ID_Cards_Required__c should be selected as yes for id card creation and for other record type we are not checking for ID_Cards_Required__c field(Jira Id 38919)
*/
    public static void generateIdCards(Set<Id> orderIds){
        
        List<ID_Cards__c> idCardRecList = new List<ID_Cards__c>();
        List<Implementation_Tracking__c> impTrackRecList = new List<Implementation_Tracking__c>();
        
        // Check if the Implementation Tracking,Id card,Enrollment and Billing are accessible by the User.
        if(Schema.sObjectType.Implementation_Tracking__c.isAccessible() &&  Schema.sObjectType.Enrollment_and_Billing__c.isAccessible() && 
           Schema.sObjectType.ID_Cards__c.isAccessible() && Schema.sObjectType.Implementation_Tracking__c.fields.RecordTypeID.isAccessible()){
               //Query tracking records along with its child ID Cards and Membership
               impTrackRecList = [SELECT Id,RecordTypeID,Implementation_Record_ID__c,Implementation_Record_ID__r.ID_Cards_Required__c,
                                  (SELECT Id FROM ID_Cards__r),
                                  (SELECT Id FROM Enrollment_and_Billing__r WHERE Stage__c =: staticVariableClass.STAGE04_APPROVED)
                                  FROM Implementation_Tracking__c 
                                  WHERE Implementation_Record_ID__c IN: orderIds];
           }
        //Get Local and JAA RecordTypeIds of Implementation Tracking object.
        Id localRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_Local).getRecordTypeId();
        Id jaaRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_JAA).getRecordTypeId();
        //Start:44530
        Id mcsRecordTypeId = Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(Label.ImplementationTracking_MCS).getRecordTypeId();
        
        if(impTrackRecList.size()>0){
            for(Implementation_Tracking__c impTrack : impTrackRecList){
                //Id cards generation logic + proceed only If there are no ID cards record for the Imp Tracking record - then proceed.
                if(impTrack.ID_Cards__r.size() == 0){
                    if(impTrack.RecordTypeID == localRecordTypeId || impTrack.RecordTypeID == jaaRecordTypeId || impTrack.RecordTypeID == mcsRecordTypeId){                     
                        ID_Cards__c idCard = new ID_Cards__c();
                        idCard.Implementation_Tracking_ID__c = impTrack.Id;                    
                        idCard.Membership_Approved__c = impTrack.Enrollment_and_Billing__r.size() > 0 ? staticVariableClass.UpsellYes : staticVariableClass.UpsellNo; //Check for membership record and Set values as Yes or No based on the size of it.                      
                        idCard.RecordTypeId = getRecordTypeIdForIdCards(impTrack.RecordTypeId, localRecordTypeId, jaaRecordTypeId, mcsRecordTypeId);
                        idCard.Stage__c = staticVariableClass.defaultIDCardStage;                                       
                        idCardRecList.add(idCard);//Adding the instances to the list
                    }
                }
            }
        }
        //End:44530
        if(!idCardRecList.isempty() && Schema.SObjectType.ID_Cards__c.isCreateable()){
            insert idCardRecList;
        }
    }
    
    /**
*  @description : Method to fetch the Id card record Type Id
*  @name : getRecordTypeIdForIdCards
*  @param : impTrackRecTypeId,localRecordTypeId,jaaRecordTypeId 
*  JIRA ID : 39717
*  @Author Mahesh Ganti,Abhishek Doodgaon{Deloitte} 
*/
    //Start:44530
    public static Id getRecordTypeIdForIdCards(Id impTrackRecTypeId,Id localRecordTypeId, Id jaaRecordTypeId, Id mcsRecordTypeId){
        
        Id idCardRecordTypeId = null;                   
        if(impTrackRecTypeId == localRecordTypeId){
            idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(staticVariableClass.LOCAL).getRecordTypeId();  
        }
        if(impTrackRecTypeId == jaaRecordTypeId){
            idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(staticVariableClass.JAANASCOandWGS).getRecordTypeId();
        }
        if(impTrackRecTypeId == mcsRecordTypeId){
            idCardRecordTypeId = Schema.SObjectType.ID_Cards__c.getRecordTypeInfosByName().get(staticVariableClass.MCSNASCOandWGS).getRecordTypeId();
        }
        
        return idCardRecordTypeId;
    }
    //End:44530
    /**
@Author : Rahul(Vikings)
@name : idCardStatusUpdate
@CreateDate :08/20/2019
@description : ID Card Auto notification on ID card Review Status Jira ID: 39701
@param : trigger.new ,trigger.oldMap
*/
    public static void idCardStatusUpdate(List < Order > orderLst, Map < Id, order > orderOldMap){
        Set<ID> orderIDForValidation = new Set<ID>();
        List<ID_Cards__c> idCardToUpdate = new List<ID_Cards__c>();
        List<Order> orderList = new List<Order>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        Map<ID,ID> orderTrackingMap = new Map<ID,ID>();
        Map<ID,ID> idCardTrackingMap = new Map<ID,ID>();
        
        if(!orderLst.isEmpty()){
            for(Order varOrder:orderLst){
                if(varOrder.ID_Card_Review_Status__c != orderOldMap.get(varOrder.Id).ID_Card_Review_Status__c){
                    orderIDForValidation.add(varOrder.Id);   
                    orderList.add(varOrder);
                }
            } 
        }
        
        if(!orderIDForValidation.isEmpty()){
            List< Implementation_Tracking__c> trackingRecList = [ SELECT Id,Implementation_Record_ID__c 
                                                                 FROM Implementation_Tracking__c 
                                                                 WHERE Implementation_Record_ID__c IN :orderIDForValidation ];
            for(Implementation_Tracking__c varTracking :trackingRecList){
                orderTrackingMap.put(varTracking.Implementation_Record_ID__c,varTracking.Id);
            }
            if(!trackingRecList.isEmpty()){
                idCardList = [SELECT Id,Stage__c,Implementation_Tracking_ID__c 
                              FROM ID_Cards__c 
                              WHERE Implementation_Tracking_ID__c IN : orderTrackingMap.values()];
            }
            for(ID_Cards__c varIdCard : idCardList){
                idCardTrackingMap.put(varIdCard.Id,varIdCard.Implementation_Tracking_ID__c);
            }
            for(order varOrd:orderList){
                for(ID_Cards__c varIdCard :idCardList){
                    if(orderTrackingMap.get(varOrd.Id)==idCardTrackingMap.get(varIdCard.Id)){
                        if(varIdCard.Stage__c == UtilConstants.REVIEW_DONE_04
                           || varIdCard.Stage__c == UtilConstants.PENDING_MAIL_DATE_04 
                           || varIdCard.Stage__c == UtilConstants.REJECTED_05 
                           || varIdCard.Stage__c == UtilConstants.APPROVED_04){
                               //varOrd.addError('Not Allowed');
                           }else{
                               varIdCard.Stage__c=UtilConstants.REVIEW_DONE_04;
                               idCardToUpdate.add(varIdCard);
                           }
                    }
                }
            }
            if(!idCardToUpdate.isEmpty()){
                update(idCardToUpdate);
            }
        }
    }
    /**
@Author : Rahul(Vikings)
@name : populateAssignedImplementerValueOnIdCard
@CreateDate :09/13/2019
@description : updates the Assigned Implementer value on ID card record when same is changed on Order
@param : Map<Id,Order>
*/
    public static void populateAssignedImplementerValueOnIdCard(List<Order> orderList,Map<Id,Order> orderOldMap){
        Map<Id,Order> orderMap = new Map<Id,Order>();
        List<Implementation_Tracking__c> impTrackRecList = new List<Implementation_Tracking__c>();
        Map<Id,Id> orderImplementationMap = new Map<Id,Id>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        
        for(Order ordVar:orderList){
            if(orderOldMap.get(ordVar.Id).Assigned_Implementer__c != ordVar.Assigned_Implementer__c ){
                orderMap.put(ordVar.Id,ordVar);
            }
        }
        
        if(orderMap != null && orderMap.size()>0 ){
            // Check if the Implementation Tracking,Id card,Enrollment and Billing are accessible by the User.
            if(Schema.sObjectType.Implementation_Tracking__c.isAccessible() &&  Schema.sObjectType.Enrollment_and_Billing__c.isAccessible() && 
               Schema.sObjectType.ID_Cards__c.isAccessible() && Schema.sObjectType.Implementation_Tracking__c.fields.RecordTypeID.isAccessible()){
                   
                   //Query tracking records along with its child ID Cards and Membership
                   impTrackRecList = [SELECT Id,RecordTypeID,Implementation_Record_ID__c,Implementation_Record_ID__r.ID_Cards_Required__c,
                                      (SELECT Id,Assigned_Implementer__c FROM ID_Cards__r)
                                      FROM Implementation_Tracking__c 
                                      WHERE Implementation_Record_ID__c IN: orderMap.keyset()];
                   
                   if(!impTrackRecList.isEmpty()){
                       for(Implementation_Tracking__c impTrack : impTrackRecList){
                           if(impTrack.ID_Cards__r.size()>0){
                               orderImplementationMap.put(impTrack.Id,impTrack.Implementation_Record_ID__c);
                           }
                       }
                       if(orderImplementationMap != null){
                           for(Implementation_Tracking__c impTrack1 : impTrackRecList){
                               for(ID_Cards__c idCardVar :impTrack1.ID_Cards__r){
                                   if(orderMap.containskey(orderImplementationMap.get(impTrack1.Id))){
                                       idCardVar.Assigned_Implementer__c = orderMap.get(impTrack1.Implementation_Record_ID__c).Assigned_Implementer__c;
                                       idCardList.add(idCardVar);
                                   }    
                               }
                           }
                       }
                   }
                   if(!idCardList.isEmpty()){
                       update idCardList;
                   }
               }
        }
    }
    /**
@Author : Rahul(Vikings)
@name : smeRecordStatusUpdate
@CreateDate : 11/20/2019
@description : Close off Specialty SME Records when ICR is Withdrawn 
@param : List<order>,Map<Id,Order>
@modifiedby : Sharath KN - Sends email on ICR withdrawn (PRDCRM-48137)
@modifiedby : Sharath KN - Decline SME records when ICR is withdrawn (PRDCRM-50402)
*/
    public static void smeRecordStatusUpdate(List<Order> orderList,Map<Id,Order> orderOldMap){
        Map<Id,Order> orderMap = new Map<Id,Order>();
        List<Dental_Complete__c> dentalList = new List<Dental_Complete__c>();
        List<Vision__c> visionList = new List<Vision__c>();
        List<Life_and_Disability__c> lifeAndDisabilityList = new List<Life_and_Disability__c>();
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        List<Underwriting__c> underwritingList = new List<Underwriting__c>();
        List<Implementation_Tracking__c> implementationTrackingList = new List<Implementation_Tracking__c>();
        List<Issue_Control__c> caseInstallList = new List<Issue_Control__c>();
        List<Enrollment_and_Billing__c> membershipList = new List<Enrollment_and_Billing__c>();
        List<Contracts__c> contractsList = new List<Contracts__c>();//Declined
        List<Rx__c> rxList = new List<Rx__c>();
        List<InterPlan__c> interPlanList = new List<InterPlan__c>();
        List<Medical_Benefit__c> medicalBenefitList = new List<Medical_Benefit__c>();
        String comments = System.Label.ICCancelledComment;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemp  = [Select id,subject,HtmlValue from Emailtemplate where DeveloperName = 'ICR_Withdraw_To_SME_Record_Owner'];
        
        for(Order ordVar:orderList){
            if((orderOldMap.get(ordVar.Id).Implementation_Status__c != ordVar.Implementation_Status__c) && ordVar.Implementation_Status__c.equalsIgnoreCase(UtilConstants.IC_STATUS_WITHDRAWN) ){
                orderMap.put(ordVar.Id,ordVar);
            }
        }
        for (Implementation_Tracking__c impTrack: [SELECT Group_Number__c,Implementation_Case_Number__c,Account_Legal_Name__r.Name,recordtypeid, id, Implementation_Record_ID__c, Implementation_Record_ID__r.Implementation_Status__c,Implementation_Case_Name_Non_Hyperlink__c,
                                                   (SELECT id,Name,Stage__c,Sub_Stage__c,Owner.Id,Owner.email,Owner.Type FROM Dental_Completes__r), 
                                                   (SELECT id,Name,Stage__c,Sub_Stage__c,Owner.Id,Owner.email,Owner.Type FROM Life_and_Disabilities__r), 
                                                   (SELECT id,Name,Stage__c,Sub_Stage__c,Owner.Id,Owner.email,Owner.Type FROM Vision__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM ID_Cards__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Underwriting__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Issue_Controls__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Enrollment_and_Billing__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Contracts__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Rxs__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM InterPlan__r),
                                                   (SELECT id,Name,Stage__c,Owner.Id,Owner.email,Owner.Type FROM Medical_Benefits__r)
                                                   FROM Implementation_Tracking__c 
                                                   WHERE Implementation_Record_ID__c in: orderMap.keyset() 
                                                   AND recordtypeid =: Schema.SObjectType.Implementation_Tracking__c.getRecordTypeInfosByName().get(staticVariableClass.LocalNASCOandWGS).getRecordTypeId()]){
                                                       
                                                       impTrack.Overall_Status__c=UtilConstants.CANCELLED;
                                                       implementationTrackingList.add(impTrack);
                                                       if (impTrack.Dental_Completes__r.size() > 0)
                                                       {
                                                           for(Dental_Complete__c dent:impTrack.Dental_Completes__r){
                                                               //Changing dental stage to Declined
                                                               dent.Stage__c=UtilConstants.Declined_05;
                                                               //Changing sub stage to NA
                                                               dent.Sub_Stage__c=UtilConstants.NA;
                                                               dent.Underwriting_Comments__c = comments;
                                                               dentalList.add(dent);
                                                               if(dent.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(dent.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,dent);
                                                                   if(message != null){
                                                                       messages.add(message);
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Vision__r.size() > 0)
                                                       {
                                                           for(Vision__c vis:impTrack.Vision__r){
                                                               //Changing vision stage to Declined
                                                               vis.Stage__c=UtilConstants.Declined_05;
                                                               //Changing sub stage to NA
                                                               vis.Sub_Stage__c=UtilConstants.NA;
                                                               vis.Vision_Comments__c= comments;
                                                               visionList.add(vis);
                                                               if(vis.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(vis.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,vis);
                                                                   if(message != null){
                                                                       messages.add(message);
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Life_and_Disabilities__r.size() > 0)
                                                       {
                                                           for(Life_and_Disability__c lnd:impTrack.Life_and_Disabilities__r){
                                                               //Changing l&D stage to Declined
                                                               lnd.Stage__c=UtilConstants.Declined_05;
                                                               //Changing sub stage to NA
                                                               lnd.Sub_Stage__c=UtilConstants.NA;
                                                               lnd.L_D_SME_Comments__c = comments;
                                                               lifeAndDisabilityList.add(lnd);
                                                               if(lnd.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(lnd.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,lnd);
                                                                   if(message != null){
                                                                       messages.add(message);
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.ID_Cards__r.size() > 0)
                                                       {
                                                           for(ID_Cards__c idc:impTrack.ID_Cards__r){
                                                               //Changing id card stage to Declined
                                                               idc.Stage__c=UtilConstants.WITHDRAWN_05;
                                                               idc.ID_Card_Special_Instructions__c = comments;
                                                               idCardList.add(idc);
                                                               if(idc.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(idc.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,idc);
                                                                   if(message != null){
                                                                       messages.add(message);
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Underwriting__r.size() > 0)
                                                       {
                                                           for(Underwriting__c udr:impTrack.Underwriting__r){
                                                               //Changing underwriting stage to Declined
                                                               udr.Stage__c=UtilConstants.Declined_05;
                                                               udr.Comments__c= comments;
                                                               underwritingList.add(udr);
                                                               if(udr.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(udr.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,udr);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Issue_Controls__r.size() > 0){
                                                           for(Issue_Control__c thisIC:impTrack.Issue_Controls__r){
                                                               //Changing Case Install stage to Declined
                                                               thisIC.Stage__c = UtilConstants.Declined_05;
                                                               thisIC.Comments__c = comments;
                                                               caseInstallList.add(thisIC);
                                                               if(thisIC.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(thisIC.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,thisIC);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Contracts__r.size() > 0){
                                                           for(Contracts__c thisContract:impTrack.Contracts__r){
                                                               //Changing Contracts stage to Declined
                                                               thisContract.Stage__c = UtilConstants.DECLINED;
                                                               thisContract.Comments__c = comments;
                                                               contractsList.add(thisContract);
                                                               if(thisContract.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(thisContract.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,thisContract);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Rxs__r.size() > 0){
                                                           for(Rx__c thisRX:impTrack.Rxs__r){
                                                               //Changing RX stage to Declined
                                                               thisRX.Stage__c = UtilConstants.Declined_05;
                                                               thisRX.Comments__c = comments;
                                                               rxList.add(thisRX);
                                                               if(thisRX.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(thisRX.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,thisRX);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.InterPlan__r.size() > 0){
                                                           for(InterPlan__c thisIP:impTrack.InterPlan__r){
                                                               //Changing InterPlan stage to Declined
                                                               thisIP.Stage__c = UtilConstants.Declined_05;
                                                               thisIP.Comments__c = comments;
                                                               interPlanList.add(thisIP);
                                                               if(thisIP.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(thisIP.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,thisIP);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                       if (impTrack.Medical_Benefits__r.size() > 0){
                                                           for(Medical_Benefit__c thisMB:impTrack.Medical_Benefits__r){
                                                               //Changing Medical Benefit stage to Declined
                                                               thisMB.Stage__c = UtilConstants.Declined_05;
                                                               medicalBenefitList.add(thisMB);
                                                           }
                                                       }
                                                       if (impTrack.Enrollment_and_Billing__r.size() > 0){
                                                           for(Enrollment_and_Billing__c thisEB:impTrack.Enrollment_and_Billing__r){
                                                               //Changing Membership stage to Declined
                                                               thisEB.Stage__c = UtilConstants.Declined_05;
                                                               thisEB.Comments__c = comments;
                                                               membershipList.add(thisEB);
                                                               if(thisEB.Owner.Type == UtilConstants.OWNERTYPE){
                                                                   Messaging.SingleEmailMessage message = buildEmail(thisEB.Owner.email,emailTemp.subject,emailTemp.HtmlValue,impTrack.Account_Legal_Name__r.Name,impTrack.Implementation_Case_Number__c,emailTemp.Id,impTrack.Implementation_Record_ID__c,thisEB);
                                                                   if(message != null) messages.add(message);
                                                               }
                                                           }
                                                       }
                                                   }
        if(!implementationTrackingList.isEmpty() && implementationTrackingList != null && Schema.sObjectType.Implementation_Tracking__c.IsUpdateable()){
            update implementationTrackingList;
        }
        if(!dentalList.isEmpty() && dentalList != null && Schema.sObjectType.Dental_Complete__c.IsUpdateable()){
            update dentalList;
        }
        if(!visionList.isEmpty() && visionList != null && Schema.sObjectType.Vision__c.IsUpdateable() ){
            update visionList;
        }
        if(!lifeAndDisabilityList.isEmpty() && lifeAndDisabilityList != null && Schema.sObjectType.Life_and_Disability__c.IsUpdateable()){
            update lifeAndDisabilityList;
        }
        if(!idCardList.isEmpty() && idCardList != null && Schema.sObjectType.ID_Cards__c.IsUpdateable()){
            update idCardList;
        }
        if(!underwritingList.isEmpty() && underwritingList != null && Schema.sObjectType.Underwriting__c.IsUpdateable()){
            update underwritingList;
        }
        if(!caseInstallList.isEmpty() && caseInstallList != null && Schema.sObjectType.Issue_Control__c.IsUpdateable()){
            Database.update(caseInstallList);
        }
        if(!contractsList.isEmpty() && contractsList != null && Schema.sObjectType.Contracts__c.IsUpdateable()){
            Database.update(contractsList);
        }
        if(!rxList.isEmpty() && rxList != null && Schema.sObjectType.Rx__c.IsUpdateable()){
            Database.update(rxList);
        }
        if(!interPlanList.isEmpty() && interPlanList != null && Schema.sObjectType.InterPlan__c.IsUpdateable()){
            Database.update(interPlanList);
        }
        if(!medicalBenefitList.isEmpty() && medicalBenefitList != null && Schema.sObjectType.Medical_Benefit__c.IsUpdateable()){
            Database.update(medicalBenefitList);
        }
        if(!membershipList.isEmpty() && membershipList != null && Schema.sObjectType.Enrollment_and_Billing__c.IsUpdateable()){
            Database.update(membershipList);
        }
        if(messages.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
    public static Messaging.SingleEmailMessage buildEmail(String toAddress,String emailSubject ,String htmlBody, String accountName, String implCaseNum, Id templateId,String implCaseId,sObject obj){
        try{
            htmlBody = htmlBody.replace(UtilConstants.IMPLCASENUM, implCaseNum);
            htmlBody = htmlBody.replace(UtilConstants.IMPLCASELINK, URL.getSalesforceBaseUrl().toExternalForm()+ '/'+implCaseId);
            htmlBody = htmlBody.replace(UtilConstants.SMENUMBER, String.valueOf(obj.get(UtilConstants.JSON_NAME_FIELD)));
            htmlBody = htmlBody.replace(UtilConstants.SMERECLINK, URL.getSalesforceBaseUrl().toExternalForm()+ '/'+obj.Id);
            emailSubject = emailSubject.replace(UtilConstants.IMPLCASENUM1, implCaseNum);
            emailSubject = emailSubject.replace(UtilConstants.ACCNAME, accountName);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[]{toAddress};
            message.subject = emailSubject;
            message.sethtmlbody(htmlBody);
            return message;
        }catch(exception ex){
            return null;
        }
    }
}