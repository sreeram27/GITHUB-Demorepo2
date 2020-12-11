/*******************************************************************************************
@class Name  : LGA_DC_FileMapping
@created By  : IDC Offshore
@createdDate : 8/01/2019
@description : This Class is for file mapping and versioning
********************************************************************************************/
global with sharing class LGA_DC_FileMapping  implements vlocity_ins.VlocityOpenInterface {
    
    
    public List<ContentDocument> listofUploadedDocs = new List<ContentDocument>();
    public map<id,list<id>> mImpCaseCDLink = new map<id,list<id>>();
    public list<id> contendDocId = new list<id> ();
    public list<id> existingContendDocIdList = new list<id> ();
    public list<id> allDCList = new list<id> ();
    set<id> autoMatchDCID = new set<id> ();
    public list<id> selectedDCIdList = new list<id> (); // Added for versioning
    //public List<Application_Document_Checklist__c> listofDC = new List<Application_Document_Checklist__c>();
    public map<id,List<Application_Document_Checklist__c>> mImpCaseDC = new map<id,List<Application_Document_Checklist__c>>();
    List<ContentDocumentLink> insCDLink = new List<ContentDocumentLink>();
    List<Application_Document_Checklist__c> cdListToUpdate = New List<Application_Document_Checklist__c>();
    List<ContentVersion> insCV = new List<ContentVersion>();
    List<Application_Document_Checklist__c> updateDClst = new List<Application_Document_Checklist__c>();
    Map<id, Application_Document_Checklist__c> mupdatelst = new Map<id, Application_Document_Checklist__c>();
    String sbaseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
    // public map<id,List<ContentDocumentLink>> existingCDLinksMap = new map<id,List<ContentDocumentLink>>(); // Added for versioning
    public map<id,List<id>> existingCDLinksMap = new map<id,List<id>>(); // Added for versioning
    public map<id,ContentVersion> newCVMap = new map<id,ContentVersion>(); // Added for versioning
    List<string> selectedItems = new List<string>();
    List<string> uploadedfilename = new List<string>();
    List<string> allDCNames = new List<string>();
    Set<Id> uContentIds = new Set<Id>();
    List<Application_Document_Checklist__c> allDCLists = new List<Application_Document_Checklist__c>();
    
    
    public List<Application_Document_Checklist__c> selectedDClist = new List<Application_Document_Checklist__c>();
    /*******************************************************************************************
@method Name  : invokeMethod
@description : Get the data from Omni Script 
@return : Boolean
@param : methodName,inputMap,outMap,optns
********************************************************************************************/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        try{
            if (LGA_Constants.ATTACHFILES_METHOD.equalsIgnoreCase(methodName))
            {
                
                //system.debug('Hiii' + (String)options.get(LGA_Constants.AUTO_MATCH));
                Boolean dcAutoMatch = (Boolean)options.get(LGA_Constants.AUTO_MATCH);
                if(options.get(LGA_Constants.SELECTEDDC) != '' ){
                    for(Object sObj :  (List<Object>)options.get(LGA_Constants.SELECTEDDC)){
                        selectedItems.add((String)sObj);
                    }
                }
                
                for(Object sObj :  (List<Object>)options.get(LGA_Constants.UFILENAME)){
                    uploadedfilename.add((String)sObj);
                }
                
                return attachFilestoDC((String)options.get(LGA_Constants.IMPLCASEID) , selectedItems, uploadedfilename,dcAutoMatch, outMap);  //(List<string>)
            }
        }Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return true;
    }
    /*******************************************************************************************
@method Name  : attachFilestoDC
@description : This is test method for LGA_CreateDocumentChecklist
@return : boolean
@param : inputMap,outMap,optns
********************************************************************************************/ 
    public boolean attachFilestoDC(String impCaseid, List<string> selectedDC, List<string> upldFileNameList,Boolean autoMatchDC , Map<String,Object> outputMap){
        
        try {
            for(ContentDocumentLink cd : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink 
                                          where LinkedEntityId =: impCaseid ORDER BY SystemModstamp DESC NULLS LAST LIMIT 50000]){
                                              //mImpCaseCDLink.put(cd.LinkedEntityId,cd.ContentDocumentId); 
                                              contendDocId.add(cd.ContentDocumentId);  
                                              
                                          }
            
                        
            if (Schema.sObjectType.ContentDocument.isAccessible() ){
                listofUploadedDocs = [SELECT Id, Title, ParentId, FileType 
                                      FROM ContentDocument where Id IN: contendDocId AND Title IN: upldFileNameList 
                                      ORDER BY CreatedDate DESC NULLS LAST LIMIT 50000 ];
            }
                for(ContentVersion cv: [Select Id,  VersionData,Title ,ContentDocumentId From ContentVersion Where ContentDocumentId =:listofUploadedDocs[0].Id LIMIT 50000]) {
                newCVMap.put(cv.ContentDocumentId,cv);
            }     
                if (Schema.sObjectType.Application_Document_Checklist__c.isAccessible() ){
                selectedDClist = [SELECT Id, Implementation_Case__c, 
                                  Document_Name__c, Status__c 
                                  FROM Application_Document_Checklist__c 
                                  where Id IN: selectedDC   limit 50000];}
                        
            if (!autoMatchDC) {
                //mImpCaseCDLink.put(ImpCaseId,contendDocId); 
                //system.debug('hiiiii mImpCaseCDLink'+ mImpCaseCDLink);
                if (Schema.sObjectType.Application_Document_Checklist__c.isAccessible() ){
                    selectedDClist = [SELECT Id, Implementation_Case__c, 
                                      Document_Name__c, Status__c 
                                      FROM Application_Document_Checklist__c 
                                      where Id IN: selectedDC   limit 50000];}
                
                // Adding this part for versioning
                For(Application_Document_Checklist__c dc : selectedDClist ){
                    selectedDCIdList.add(dc.Id);
                }
                List<Id> existingCDLinks;
                //ContentVersion cv;
                for(ContentDocumentLink cdlink : [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink 
                                                  where LinkedEntityId IN: selectedDCIdList Limit 50000]){
                                                      if(existingCDLinksMap.containskey(cdlink.LinkedEntityId)){
                                                          //if(!existingCDLinksMap.get(cdlink.LinkedEntityId).contains(cdlink.ContentDocumentId)){
                                                          existingCDLinksMap.get(cdlink.LinkedEntityId).add(cdlink.ContentDocumentId); 
                                                          // }
                                                          // existingCDLinksMap.get(cdlink.LinkedEntityId).add(cdlink.ContentDocumentId);
                                                      }else{
                                                          existingCDLinks = new List<Id>();//List<Id> existingCDLinks = new List<Id>();
                                                          existingCDLinks.add(cdlink.ContentDocumentId);
                                                          existingCDLinksMap.put(cdlink.LinkedEntityId , existingCDLinks);
                                                      }
                                                  }
                
                List<ContentVersion> cvlst = new List<ContentVersion>();
                if (Schema.sObjectType.ContentVersion.isAccessible() ){
                    cvlst = [SELECT Id, ContentDocumentId, Title, ContentUrl,ContentSize 
                             FROM ContentVersion where ContentDocumentId IN: contendDocId LIMIT 500];}
                ContentDocumentLink cdlink = new ContentDocumentLink();
                Application_Document_Checklist__c upadteDC;
                id cdId;
                for(Application_Document_Checklist__c selectDC:selectedDClist){
                    for(ContentDocument cd:listofUploadedDocs){
                        if(!existingCDLinksMap.containsKey(selectDC.Id)){
                            // ContentDocumentLink cdlink = new ContentDocumentLink();
                            //cdlink = new ContentDocumentLink();
                            cdlink.ContentDocumentId = cd.id;
                            cdlink.LinkedEntityId = selectDC.Id;
                            cdlink.ShareType = LGA_Constants.SHARE_V_CONSTANT;
                            cdlink.Visibility = LGA_Constants.VISIBILITY_ALL_CONSTANT;
                            insCDLink.add(cdlink); 
                            for(ContentVersion cv: cvlst){
                                if(cv.ContentDocumentId == cdlink.ContentDocumentId){
                                    system.debug('Inside cvlst' + (cv.ContentDocumentId == cdlink.ContentDocumentId));
                                    upadteDC = new Application_Document_Checklist__c();//Application_Document_Checklist__c upadteDC = new Application_Document_Checklist__c();
                                    upadteDC.Id = selectDC.Id;
                                    upadteDC.File_Name__c = cv.Title;
                                    upadteDC.File_URL__c = sbaseUrl+'//'+cv.ContentDocumentId;
                                    upadteDC.Tech_Content_Document_Id__c = cv.ContentDocumentId;
                                    mupdatelst.put(upadteDC.Id, upadteDC);
                                }
                            } 
                        }
                        else if(existingCDLinksMap.containsKey(selectDC.Id)){
                            //id cdId;
                            for(id conDocLink : existingCDLinksMap.get(selectDC.Id)){
                                uContentIds.add(conDocLink);
                                }
                            
                        }
                        
                    }
                }
                ContentVersion cv;
                for(ContentDocument cd:listofUploadedDocs){
                    for(id contentId: uContentIds){
                        //ContentVersion cv = New ContentVersion();
                        cv = New ContentVersion();//ContentVersion cv = New ContentVersion();
                        cv.ContentDocumentId = contentId;
                        cv.Title = cd.Title;
                        cv.PathOnClient = cd.Title;
                        cv.VersionData = newCVMap.get(cd.Id).VersionData;
                        // cdId=cv.ContentDocumentId;    
                        insCV.add(cv);   
                         // }
                    }
                    
                }
                
                
            }
            //ContentDocumentLink cdlink;
            //Application_Document_Checklist__c dcUpdate;
            else if(autoMatchDC){
                if (Schema.sObjectType.Application_Document_Checklist__c.isAccessible() ){
                    allDCLists = [SELECT Id, Implementation_Case__c, Document_Name__c 
                                  FROM Application_Document_Checklist__c 
                                  where Implementation_Case__c =: impCaseid   limit 50000];
                }
                ContentDocumentLink cdlink;
                Application_Document_Checklist__c dcUpdate;
                
                for (ContentDocument cd: listofUploadedDocs) {
                    for (Application_Document_Checklist__c dcCheckList: allDCLists) {
                        //system.debug('########dcCheckList.Document_Name__c.toLowerCase(): ' + dcCheckList.Document_Name__c.toLowerCase());
                        //system.debug('########dcCheckList.Document_Name__c.toLowerCase(): ' +cd.Title.toLowerCase());
                        //system.debug('########dcCheckList.Document_Name__c.toLowerCase(): ' + cd.Title.indexOf('.'));
                        String docTitle = cd.Title.substring(0, cd.Title.indexOf('.')); //  cd.Title.indexOf('.')
                        if (dcCheckList.Document_Name__c.containsIgnoreCase(docTitle)) {
                            //ContentDocumentLink cdlink = new ContentDocumentLink();
                            cdlink = new ContentDocumentLink();//ContentDocumentLink cdlink = new ContentDocumentLink();
                            cdlink.ContentDocumentId = cd.id;
                            cdlink.LinkedEntityId = dcCheckList.Id;
                            cdlink.ShareType = LGA_Constants.SHARE_V_CONSTANT;
                            cdlink.Visibility = LGA_Constants.VISIBILITY_ALL_CONSTANT;
                            insCDLink.add(cdlink); // cdListToUpdate
                            //Application_Document_Checklist__c dcUpdate = new Application_Document_Checklist__c();
                            dcUpdate = new Application_Document_Checklist__c();
                            dcUpdate.Id = dcCheckList.Id;
                            dcUpdate.Status__c = LGA_Constants.DC_STATUS_AUTO_MATCH;
                            cdListToUpdate.add(dcUpdate);
                            autoMatchDCID.add(dcUpdate.id);
                        }
                    }
                }
                Application_Document_Checklist__c updateDC ;
                if(!selectedDClist.isEmpty()){
                    for(Application_Document_Checklist__c  dcUpdates:selectedDClist){
                        if(String.isBlank(dcUpdates.Status__c) && !autoMatchDCID.contains(dcUpdates.Id)){
                            updateDC = new Application_Document_Checklist__c();//Application_Document_Checklist__c updateDC = new Application_Document_Checklist__c();
                            updateDC.Id = dcUpdates.Id;
                            updateDC.Status__c = LGA_Constants.DC_STATUS_SELF_INPUT;
                            cdListToUpdate.add(updateDC);
                        }
                    }
                }
                
            }
            
            if(!insCDLink.isEmpty()){
                Database.insert(insCDLink, false); 
            }
            
            if(!mupdatelst.values().isEmpty()){
                Database.update(mupdatelst.values(), false); 
            }
            
            if(!cdListToUpdate.isEmpty()){
                Database.update(cdListToUpdate, false);
            }
            
            if(!insCV.isEmpty()){
                 Database.insert(insCV, false);
            }
            
            /* Specify DataRaptor extract or transform to call */
            String drName = 'Get_DCList_IMP_Info'; 
            /* Populate the input JSON */
            Map<String, Object> myTransformData = new Map<String, Object>{'Id'=>impCaseid}; 
                /* Call the DataRaptor */
                vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.process(myTransformData, drName); 
            /* Deserialize the DataRaptor output for processing in Apex */ 
            List<Map<String, Object>> myTransformResult = (List<Map<String, Object>>)result.toJsonList(); 
            
            system.debug('-------Extract DR Output------'+myTransformResult[0].get('DCList'));
            //system.debug('-------Extract DR Output result------'+result[0]);
            system.debug('-------Extract DR Output result------'+myTransformResult[0].get('allObjectInfos'));
            system.debug('-------Extract DR Output result------'+ Json.serialize(myTransformResult[0].get('DCList')) );
            //system.debug('-------Extract DR Output result------'+myTransformResult[0].get('allObjectInfos').toJson());
            String strJSON = Json.serialize(myTransformResult[0].get('DCList'));
                       
            outputMap.put(LGA_Constants.OUTPUT_DCLIST,strJSON);
            
            return true;
        } catch (Exception ex) {
            System.debug('****The following exception has occurred: '+ex.getMessage());
            return true;
        }
        
    }    
    
}