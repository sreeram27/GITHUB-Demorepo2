/**
 * @File Name          : ICRContentDocumentTriggerHandler.cls
 * @Description        : Associating ICR RateSheets with the Account
 * @Author             : Onshore 
 * @Group              : Raptors
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 2/19/2020, 2:23:22 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/12/2020                    Initial Version      
**/
public with sharing class ICRContentDocumentTriggerHandler {
    /**********************************************************************************
Class Name :   ICRContentDocumentLinkTriggerHandler
Date Created : 2/12/2020 
Created By   : Raptor Onshore
@description : Linking ICR RateSheets with the Parent Account
*************************************************************************************/
    public static Boolean isRun = true;

    //Return ICR ID
    public static Set<Id> getOrderId( List<ContentDocumentLink> cdls){
        Set<id>linkId = new Set<id>();
        try{
           
       	    for(ContentDocumentLink cdl :cdls ){
                if(cdl.LinkedEntityId != null && Schema.Order.SObjectType == cdl.LinkedEntityId.getSobjectType()){
				    linkId.add(cdl.LinkedEntityId);
            	    system.debug('This is the link'+linkId);
        	    }
    	    }
        }catch(Exception e){
            System.Debug(LoggingLevel.ERROR, 'Apex Exception: Line# 001' + (string.valueof(e.getLineNumber())).leftPad(5, '_') + ', ' + e.getMessage()); 
        } 
        
        return linkId;

    }
      /**    
      * Associate the content document with the Account associated to the opportunity
      */
    public static void accountContentDocumentLink(Set<id> orderId){
        List<ContentDocumentLink> contentDL2 = new List<ContentDocumentLink>();
        Set<Id>contentDocId =new Set<id>();
        ContentDocumentLink contentDL;
        if(isRun && orderId.size() > 0){
            try{
                List<String>acId = getAccountId(orderId);
                
                //Query for existing contentDocument
                if(acId.size() > 0 && Schema.sObjectType.ContentDocument.isAccessible()){
                    for(ContentDocumentLink cdl3 : [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId in:acId Limit 50000]){
                        contentDocId.add(cdl3.ContentDocumentId);
                    }
                }
                //Create contentDocumentLink for the Parent Account
                for(ContentDocumentLink cd:[SELECT id,ContentDocumentId,LinkedEntityId  FROM ContentDocumentLink 
                                    WHERE LinkedEntityId in:orderId
                                    AND ContentDocument.LatestPublishedVersion.FileType ='EXCEL_X'
                                    AND ContentDocument.title like '%FinalRates%' Limit 50000]){
                    
                    //ContentDocumentLink contentDL = new ContentDocumentLink();
                    contentDL = new ContentDocumentLink();
                    if( !contentDocId.contains(cd.ContentDocumentId)){
                        contentDL.ContentDocumentId = cd.ContentDocumentId;
                        contentDL.ShareType = 'I';
                        contentDL.Visibility = 'AllUsers';

                        if(acId.size()> 0){
                            contentDL.LinkedEntityId = acId[0];
                        }
                        contentDL2.add(contentDL);
                        System.debug('This is the contentDocLink@@@@@@@@@@@@@@'+ contentDL);
                    }

                }
                if(contentDL2.size()> 0 && Schema.sObjectType.ContentDocumentLink.isCreateable() ){
                    insert contentDL2;
                }

            }catch(Exception e){
                System.Debug(LoggingLevel.ERROR, 'Apex Exception: Line# 002' + (string.valueof(e.getLineNumber())).leftPad(5, '_') + ', ' + e.getMessage()); 
            }
            isRun = false;
        }

    }
    //Get AccountId from IRC record
    @TestVisible
    private static List<String> getAccountId(Set<id> orderId){
        List<String>acctId = new List<String>();

        for(Order ordId : [Select id,AccountId from Order where id in:orderId Limit 50000]){
            String id = ordId.AccountId;
            acctId.add(id);
        }
        return acctId;
    }

}