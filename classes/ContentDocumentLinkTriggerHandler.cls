/**********************************************************************************
Class Name :   ContentDocumentLinkTriggerHandler
Date Created : 18-November-2019
Created By   : IDC Offshore
@description : Created for Document Upload functionality
*************************************************************************************/
public with sharing class ContentDocumentLinkTriggerHandler {
    
/*******************************************************************************************
@method Name  : createCDLink
@description : This method updates the Document Checklist Fields bassed on Content Document Link data.
@param : cdlList
********************************************************************************************/
    public void createCdLink(List<ContentDocumentlink> cdlList){
        List<ContentDocument> cdList= new List<ContentDocument>();
        Set<Id> cdIdList= new Set<Id>();
        List<Application_Document_Checklist__c> dcList= new List<Application_Document_Checklist__c>();
        List<Application_Document_Checklist__c> dcListFinal= new List<Application_Document_Checklist__c>();
        Schema.DescribeSobjectResult result = Application_Document_Checklist__c.SobjectType.getDescribe();
        map<Id,ContentDocument> mapContDocument = new map<Id,ContentDocument>();
        String dcKeyPrefix = result.getKeyPrefix();
        String sbaseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        
        for(ContentDocumentlink cdl:cdlList){
            cdIdList.add(cdl.ContentDocumentId);
        }
        system.debug('cdIdList:'+cdIdList);
        system.debug('cdIdList:'+cdIdList.size());
        if(Schema.sObjectType.ContentDocument.isAccessible()){
            cdList= [SELECT Id, ParentId, Title, FileType,ContentSize, FileExtension
                     FROM ContentDocument where ID IN:cdIdList];
        }
        for(ContentDocument cd:cdList){
            mapContDocument.put(cd.Id, cd);
        }
        for(ContentDocumentlink cdl:cdlList){
            if(mapContDocument.containskey(cdl.ContentDocumentId)){
                String cdLinkedEntityId =  cdl.LinkedEntityId;
                if(cdLinkedEntityId.startsWith(dcKeyPrefix)){
                    Application_Document_Checklist__c dc = new Application_Document_Checklist__c();
                    dc.Id=cdLinkedEntityId;
                    dc.File_Name__c=mapContDocument.get(cdl.ContentDocumentId).Title;
                    dc.File_Size__c=String.valueof(mapContDocument.get(cdl.ContentDocumentId).ContentSize);
                    dc.File_URL__c= sbaseUrl+'//'+cdl.ContentDocumentId;
                    dcList.add(dc);
                }}
        }
        if(!dcList.isEmpty())
        {
            database.update(dcList, False); 
        }
    }
}