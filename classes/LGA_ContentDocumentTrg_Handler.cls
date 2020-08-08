/**********************************************************************************
Class Name :   LGA_ContentDocumentTrg_Handler
Date Created : 5-August-2019
Created By   : IDC Offshore
@description : Created for Document Upload
*************************************************************************************/
public with sharing class  LGA_ContentDocumentTrg_Handler {
    
    List<Id> tobeCheckedCD = new List<Id>();
    List<Id> tobeCheckedDC = new List<Id>();
    List<Id> tobeCheckedImpCase = new List<Id>();
    List<Application_Document_Checklist__c> toUpdateDC = new List<Application_Document_Checklist__c>();
      Schema.DescribeSobjectResult r = Application_Document_Checklist__c.SobjectType.getDescribe();
      String dckeyPrefix = r.getKeyPrefix();
      public void removeOrderFileDetails(List<ContentDocument> deletedContentDocument){
        Try{
            Application_Document_Checklist__c newDC;
            for(ContentDocument cd :deletedContentDocument ){
                tobeCheckedCD.add(cd.Id);
            }
            for(ContentDocumentLink cdLink: [SELECT Id,LinkedEntityId 
                                             From ContentDocumentLink 
                                             Where ContentDocumentId IN: tobeCheckedCD Limit 50000]){
                                                 String cdLinkedEntityId =  cdLink.LinkedEntityId;
                                                 if(cdLinkedEntityId.startsWith(dckeyPrefix)){
                                                   //if(cdLinkedEntityId.startsWith('a9O')){
                                                     tobeCheckedDC.add(cdLink.LinkedEntityId);
                                                 }
                                             }
                                             
            If(!tobeCheckedDC.isEmpty()){
                For(Application_Document_Checklist__c dc: [SELECT Id,File_Name__c, File_Size__c, 
                                                           File_URL__c, Tech_Content_Document_Id__c 
                                                           From Application_Document_Checklist__c Where Id IN: tobeCheckedDC Limit 50000]){
                                                               //Application_Document_Checklist__c newDC = New Application_Document_Checklist__c();
                                                               newDC = New Application_Document_Checklist__c();
                                                               newDC.Id = dc.Id;
                                                               newDc.File_Name__c = '';
                                                               newDC.File_Size__c = '';
                                                               newDC.File_URL__c = '';
                                                               newDC.Tech_Content_Document_Id__c = '';
                                                               newDC.Status__c = '';
                                                               toUpdateDC.add(newDC);
                                                           }
            }
            
            If(!toUpdateDC.isEmpty()){
                database.update(toUpdateDC, False);
            }
        }
        Catch(Exception ex){
            system.debug('****The following exception has occurred: '+ex.getMessage());
        }
        
    }
    
     public void updateOrderFileFields(List<ContentDocument> newConDocLst){
        Try{
            List<Application_Document_Checklist__c> updateDCLst = new List<Application_Document_Checklist__c>();    
            List<Id> conDocLst = new List<Id>();
            List<Id> conDocDCLst = new List<Id>();
            Map<Id, String> mdocTitle = new Map<Id, String>();
            Map<Id, ContentDocumentLink> mconDcIdLst = new Map<Id, ContentDocumentLink>();
            for(ContentDocument cd :newConDocLst ){
                conDocLst.add(cd.Id);
                mdocTitle.put(cd.Id,cd.Title);
                }
           // list<string>cdLinkedEntityId = new List<string>();
            for(ContentDocumentLink cdLink: [SELECT Id,LinkedEntityId,ContentDocumentId 
                                             From ContentDocumentLink 
                                             Where ContentDocumentId IN: conDocLst Limit 50000]){
                                                
                                                 //cdLinkedEntityId.add(cdLink.LinkedEntityId);
                                                 String cdLinkedEntityId =  cdLink.LinkedEntityId;
                                                 if(cdLinkedEntityId.startsWith(dckeyPrefix)){
                                                     conDocDCLst.add(cdLink.LinkedEntityId);
                                                     mconDcIdLst.put(cdLink.LinkedEntityId,cdLink); 
                                                      // cdLinkedEntityId = '';
                                                 }
                                             }
            Application_Document_Checklist__c newDC;
            If(!conDocDCLst.isEmpty()){
                system.debug('@@entered');
                For(Application_Document_Checklist__c dc: [SELECT Id,File_Name__c, File_Size__c, File_URL__c, Tech_Content_Document_Id__c 
                                                           From Application_Document_Checklist__c Where Id IN: mconDcIdLst.keyset() Limit 50000]){
                                                               for(ContentDocument cd: newConDocLst){
                                                                   if(mconDcIdLst.get(dc.id).ContentDocumentId == cd.id)
                                                                  //if(mconDcIdLst.containskey(cd.id))
                                                                   {
                                                                       //Application_Document_Checklist__c newDC = New Application_Document_Checklist__c();
                                                                       newDC = New Application_Document_Checklist__c();
                                                                      // newDC.Id = mconDcIdLst.get(cd.id);
                                                                      newDC.Id = dc.id;
                                                                      newDc.File_Name__c =cd.Title ;                                                      
                                                                      updateDCLst.add(newDC);
                                                                   }   
                                                               }
                                                           }
            }
           
            If(!updateDCLst.isEmpty()){
                database.update(updateDCLst, False);
            }
        }
        Catch(Exception ex){
            system.debug('****The following exception has occurred: '+ex.getMessage());
        }
    }
    
}