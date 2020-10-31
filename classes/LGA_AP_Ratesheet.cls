/**********************************************************************************
@Class Name :   LGA_AP_RateSheet
@Date Created : 02-AUG-2019
@Created By   : Accenture Offshore
@@Description  : This Class is for Rate sheet uploads for underwriter.
2. This class is used to fetch the documents list and upload files in content version Object.
@Change History : 
*************************************************************************************/
Public with sharing class LGA_AP_Ratesheet {
    
    public List<String> docCheckIdsList{get;set;}
    public List<WrapFileUploadHolder> wrapFileUploadHolderList{get;set;}
    public Map<String,WrapFileUploadHolder> wrapFileUploadHolderMap{get;set;}
    private set<Id> fileIdSet{get;set;}
    public Order ordObj{get;set;}
    public String orderId {get;set;}
    String sbaseUrl = System.URL.getSalesforceBaseUrl().toExternalForm(); 
    /**********************************************************************
@@Method Name :   LGA_AP_RateSheet
@Date Created : 02-AUG-2019
@Created By   : Accenture Offshore
@@Description  : This Class is for Rate sheet uploads for underwriter.
2. This class is used to fetch the documents list and upload files in content version Object.
@Change History : 
Constructor for Class
*************************************************/    
    public LGA_AP_Ratesheet(){
        orderId = LGA_Constants.BLANK;
        try{
            orderId = Apexpages.currentPage().getParameters().get(LGA_Constants.ORDERID_CONSTANT).escapeHtml4();
            system.debug('****** Constructor*****' + orderId);
        }
        catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, LGA_Constants.ORGID, LGA_Constants.APPLICATIONNAME, LGA_Constants.CLS_LGA_FILEUPLOAD, LGA_Constants.CLS_LGA_FILEUPLOAD, LGA_Constants.BLANK, Logginglevel.ERROR);
                            
                           }
        
    }
    /****************************************************************************************************
@Method Name : loadApplicationandDocuments
@Parameters  : String
@Return : List<WrapFileUploadHolder>
@Description : This method is used to retrieve the list documents need to upload.
******************************************************************************************************/  
    public void loadApplicationandDocuments(){
        try{
            ordObj = new Order();
            
            if(String.isNotBlank(orderId)){
                String whereClause = LGA_Constants.SPACE+LGA_Constants.WHERE_CLAUSE+LGA_Constants.ID +LGA_Constants.EQUALS_SLASH+String.escapeSingleQuotes(orderId)+LGA_Constants.BACK_SLASH; 
                Map<ID,Order> orderMap = LGA_Util16_OrderDataAccessHelper.fetchOrderMap(LGA_Constants.LGA_AP_ORDER_OBJ_QUERY, whereClause, LGA_Constants.BLANK, LGA_Constants.LIMIT_1);  
                if(!orderMap.isEmpty()){
                    ordObj = orderMap.get(orderId);
                }
                documentsNeedtoUpload();
            }
        }
        catch(Exception ex){ UTIL_LoggingService.logHandledException(ex, LGA_Constants.ORGID, LGA_Constants.APPLICATIONNAME, LGA_Constants.CLS_LGA_FILEUPLOAD, LGA_Constants.METHOD_LOADAPP, LGA_Constants.BLANK, Logginglevel.ERROR);
                            
                           }
        
    }
    /****************************************************************************************************
@Method Name : documentsNeedtoUpload
@Parameters  : String
@Return : List<WrapFileUploadHolder>
@Description : This method is used to retrieve the list documents need to upload.
******************************************************************************************************/
    public void documentsNeedtoUpload(){
        System.debug('********documentsNeedtoUpload');
        Id brokerProfileId=userinfo.getProfileId();
        try{
            docCheckIdsList = new List<String>();
            wrapFileUploadHolderList = new List<WrapFileUploadHolder>();
            wrapFileUploadHolderMap = new Map<String,WrapFileUploadHolder>();
            Map<ID,Application_Document_Checklist__c> documentMap = new Map<ID,Application_Document_Checklist__c>();
            String whereClause = LGA_Constants.SPACE+LGA_Constants.WHERE_CLAUSE+LGA_Constants.CONDITION+LGA_Constants.ORDER_ID
                +LGA_Constants.EQUALS_SLASH+String.escapeSingleQuotes(orderId)+LGA_Constants.BACK_SLASH;
            
            documentMap = LGA_UTIL12_DCDataAccessHelper.fetchDocumentChecklistMap(LGA_Constants.LGA_AP_DCCHECKLISTQUERY, whereClause, LGA_Constants.LIMIT_100);  
            //System.debug('@@@@@@documentMap'+documentMap);
            WrapFileUploadHolder dcHolderCurr ;
            if(!documentMap.isEmpty()){
                Application_Document_Checklist__c dcObj = null;
                for(String key : documentMap.keySet()){
                    docCheckIdsList.add(key);
                    dcObj = new Application_Document_Checklist__c();
                    dcObj = documentMap.get(key);
                    //system.debug('@@@@@@@@@@@@@@@@@@@@@documentMap.get(key)'+documentMap.get(key));
                    //WrapFileUploadHolder dcHolderCurr = new WrapFileUploadHolder(dcObj);
                    dcHolderCurr = new WrapFileUploadHolder(dcObj);
                    //system.debug('*****************'+dcHolderCurr);
                    wrapFileUploadHolderMap.put(dcObj.Document_Name__c,dcHolderCurr);
                    //system.debug('@@@@@@@@@@wrapFileUploadHolderMap'+wrapFileUploadHolderMap);
                }
                wrapFileUploadHolderList= wrapFileUploadHolderMap.values();
            }
            
        }
        catch(Exception ex){ 
            UTIL_LoggingService.logHandledException(ex, LGA_Constants.ORGID, LGA_Constants.APPLICATIONNAME, LGA_Constants.CLS_LGA_FILEUPLOAD, LGA_Constants.LGA_AP_DOCUMENTNEEDTOUPLOAD, LGA_Constants.BLANK, Logginglevel.ERROR); 
        }
    }
    /****************************************************************************************************
@Method Name : saveFiles
@Parameters  : None
@Return : PageReference
@Description : This method is used to update document checklist records and upload files into content
version object and insert records in contentdocumentLink object.
******************************************************************************************************/
    public PageReference saveFiles(){
        List<Underwriter_Rate_Sheet__mdt> uRateList = new List<Underwriter_Rate_Sheet__mdt>();
        List<Application_Document_Checklist__c> docCheckList = new  List<Application_Document_Checklist__c>();
        
        System.debug('********saveFiles');
        system.debug('@@wrapFileUploadHolderList sle'+wrapFileUploadHolderList);
        List<ContentVersion> filesList = null;
        Map<String, String> documentLinkIdMap = null;
        Set<Id> fileIds = new Set<Id>();
        integer counter = 0;
        List<ContentVersion> updateCVList = new List<ContentVersion>();
        try{
            documentLinkIdMap = new Map<String, String>();
            filesList = new List<ContentVersion>();
            if(!wrapFileUploadHolderList.isEmpty()){
                documentLinkIdMap = retrieveExistingDocs(docCheckIdsList);
                filesList = prepareContentVersionList(wrapFileUploadHolderList);
                List<ContentVersion> contentVersionList = new List<ContentVersion>();
                List<String> sDocName = new List<string>();
                if(!filesList.isEmpty()){                     
                    for(WrapFileUploadHolder wrapObj : wrapFileUploadHolderList){
                        if(wrapObj.fileName != Null){
                            sDocName.add(wrapObj.documentCheckObj.Document_Name__c);
                        }
                    }
                    if(Schema.sObjectType.Underwriter_Rate_Sheet__mdt.isAccessible()){
                        uRateList =  [SELECT Id, Label,UploadedFileName__c 
                                      FROM Underwriter_Rate_Sheet__mdt 
                                      where Label IN:sDocName LIMIT 50000 ];
                    }
                    

                    if(!uRateList.isempty() && filesList[0].Title.endsWithIgnoreCase(uRateList[0].UploadedFileName__c)){
                        contentVersionList.add(filesList[0]);
                        Database.Upsert(filesList);
                     }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.LG_Rate_Sheet_Error_Message));
                    }
                    
                }
                
               
                if(!contentVersionList.isEmpty()){
                    for(ContentVersion cv : contentVersionList){
                        fileIds.add(cv.Id); 
                    } 
                }
                if(Schema.sObjectType.ContentVersion.isAccessible()){
                    updateCVList = [SELECT Id, title, ContentDocumentId FROM ContentVersion WHERE Id IN : fileIds LIMIT 100];
                }
                
                docCheckList = prepareDocumentCheckList(updateCVList, wrapFileUploadHolderList);
                if(!docCheckList.isEmpty()){
                     List<Application_Document_Checklist__c> documentCheckList = LGA_UTIL12_DCDataAccessHelper.dmlDocChecklist(docCheckList, LGA_Constants.UPDATE_OPERATION);  
                    insertContentDocumentLink(documentCheckList, documentLinkIdMap);
                }
                documentsNeedtoUpload();
            }
            
        }
        catch(Exception ex){
            UTIL_LoggingService.logHandledException(ex, LGA_Constants.ORGID, LGA_Constants.APPLICATIONNAME, LGA_Constants.CLS_LGA_FILEUPLOAD, LGA_Constants.LGA_AP_SAVEFILES, LGA_Constants.BLANK, Logginglevel.ERROR);
            
        }
        
        return null;
    }
    /****************************************************************************************************
@Method Name : retrieveExistingDocs
@Parameters  : List<String>
@Return : Map<String, String>
@Description : This method is used to retrieve existing content document Id based on the document
checklist record Id's.
******************************************************************************************************/
    private Map<String, String> retrieveExistingDocs(List<String> dcIdsList){
        System.debug('********documentCheck');
        Map<String, String> docCheckIdMap = new Map<String, String>();
        
        if(!dcIdsList.isEmpty()){
            for(ContentDocumentLink cdLink : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN: docCheckIdsList LIMIT 100]){
                if(cdLink != null){
                    docCheckIdMap.put(cdLink.ContentDocumentId, cdLink.Id);
                }
            } 
        }
        return docCheckIdMap;
    }
    
    /****************************************************************************************************
@Method Name : prepareContentVersionList
@Parameters  : List<WrapFileUploadHolder>, Map<String, String>
@Return : List<ContentVersion>
@Description : This method is used to prepare the contentversion records list.
******************************************************************************************************/
    private List<ContentVersion> prepareContentVersionList(List<WrapFileUploadHolder> wrapperFileList){
        System.debug('********documentCheck');
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        ContentVersion conVer = null;
        
        for(WrapFileUploadHolder wrapObj : wrapperFileList){
            if(String.isNotBlank(wrapObj.fileName) && wrapObj.fileContent != null){
                conVer = new ContentVersion();
                conVer.versionData = wrapObj.fileContent;
                conVer.title = wrapObj.fileName;
                conVer.PathOnClient = wrapObj.fileName;
                if(String.isNotBlank(wrapObj.documentCheckObj.Tech_Content_Document_Id__c)){
                    conVer.ContentDocumentId = wrapObj.documentCheckObj.Tech_Content_Document_Id__c; 
                }
                contentVersionList.add(conVer);
            }
            
            
        }
        return contentVersionList;
    }
    
    /****************************************************************************************************
@Method Name : prepareDocumentCheckList
@Parameters  : List<ContentVersion>, List<WrapFileUploadHolder>
@Return : List<Application_Document_Checklist__c>
@Description : This method is used to prepare the document checklist records list to insert.
******************************************************************************************************/
    private List<Application_Document_Checklist__c> prepareDocumentCheckList(List<ContentVersion> cvList, List<WrapFileUploadHolder> wrapperFHList){
        Application_Document_Checklist__c documentCheck = null;
        List<Application_Document_Checklist__c> docCheckList = new List<Application_Document_Checklist__c>();
        
        fileIdSet = new Set<Id>();
        Set<String> docIdSet = new Set<String>();
        if(!cvList.isEmpty()){
            for(ContentVersion cv : cvList){
                fileIdSet.add(cv.Id);
                for(WrapFileUploadHolder wrapObj : wrapperFHList){
                    if(cv.Title == wrapObj.fileName && !docIdSet.contains(wrapObj.documentCheckObj.Id)){ 
                        documentCheck = new Application_Document_Checklist__c();
                        documentCheck = wrapObj.documentCheckObj;
                        documentCheck.File_Name__c = wrapObj.fileName;
                        documentCheck.File_URL__c = sbaseUrl+'//'+cv.ContentDocumentId;
                        documentCheck.File_Size__c = LGA_Util14_FileUploadHelper.fileSizeConvertion(documentCheck.File_Size__c);
                        documentCheck.Tech_Content_Document_Id__c = cv.ContentDocumentId;
                        docCheckList.add(documentCheck);
                        docIdSet.add(documentCheck.Id);
                    }
                    
                }
            }
        }
        return docCheckList;
    }
    /****************************************************************************************************
@@Method Name : insertContentDocumentLink
@@Parameters  : List<Application_Document_Checklist__c>,  Map<String, String> 
@@Return : void
@@Description : This method is used to create ContentDocumentLin records to map uploaded file to document
checklist record.
******************************************************************************************************/
    private void insertContentDocumentLink(List<Application_Document_Checklist__c> dcRecordList, Map<String, String> cdLinkIdMap){
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        Map<String,String> cvMap = new Map<String,String>();
        ContentDocumentLink cdl = null;
        ContentDocumentLink cdl1 = null;
        Set<Id> docCheckSet = new Set<Id>();
        List<ContentVersion> cdList = new List<ContentVersion>();
        cdList = [SELECT Id, title, ContentDocumentId FROM ContentVersion WHERE Id IN : fileIdSet LIMIT 100];
        if(!cdList.isEmpty()){
            for(ContentVersion cv : cdList){
                cvMap.put(cv.Title, cv.ContentDocumentId);
            }
        }
        
        for(Application_Document_Checklist__c docCheck : dcRecordList){
            system.debug('@@dcRecordList'+dcRecordList);
            if(!cvMap.isEmpty() && cvMap.containsKey(docCheck.File_Name__c)){
                if(!cdLinkIdMap.containsKey(docCheck.Tech_Content_Document_Id__c)){
                    cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cvMap.get(docCheck.File_Name__c);
                    cdl.LinkedEntityId = docCheck.Id;
                    cdl.ShareType = LGA_Constants.SHARE_V_CONSTANT;
                    cdl.Visibility = LGA_Constants.VISIBILITY_ALL_CONSTANT;
                    cdlList.add(cdl);
                    cdl1 = new ContentDocumentLink();
                    cdl1.ContentDocumentId = cvMap.get(docCheck.File_Name__c);
                    cdl1.LinkedEntityId = orderId;
                    cdl1.ShareType = LGA_Constants.SHARE_V_CONSTANT;
                    cdl1.Visibility = LGA_Constants.VISIBILITY_ALL_CONSTANT;
                    cdlList.add(cdl1);
                }
                
            }
            
            
        }
        if(!cdlList.isEmpty()){
            List<ContentDocumentLink> cdlinkList = LGA_UTIL13_FilesDataAccessHelper.dmlContentDCLinklist(cdlList,LGA_Constants.UPSERT_OPERATION);
        }
    }
    
    /****************************************************************************************************
@Class Name  : WrapFileUploadHolder
@Description : This is wrapper class to display document checklist object and fileContent, contentType 
and fleName variables in SGA_VF04_FileUpload page.
******************************************************************************************************/
    public with sharing class WrapFileUploadHolder{
        public transient blob fileContent{get;set;}
        public String fileName { get; set; }
        public Application_Document_Checklist__c documentCheckObj{get;set;}
        /****************************************************************************************************
@@Method Name  : WrapFileUploadHolder for WrapFileUploadHolder 
@Description : This is used to assign document checklist object.
******************************************************************************************************/
        public WrapFileUploadHolder(Application_Document_Checklist__c docCheckObj){
            documentCheckObj = new Application_Document_Checklist__c();
            documentCheckObj = docCheckObj;
        }
    }
}