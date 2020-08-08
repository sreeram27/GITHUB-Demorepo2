/*
* @description : This class generates a report for deletion of QLIs based on WGS Sold Contract codes input data 
*/
public without sharing class WGSCCQLIDeleteReport {
    
    static final String SUBJECT_CONST ='WGS QLI Delete Report';
    static final String PARENTQLIDELREASON_CONST = 'Parent Product QLI has no related child plan QLIs';
    static final String CHILDQLIDELREASON_CONST = 'Child Plan QLI has no contract code';
    static final String PRODCT_CATG_CONST = 'Product';
    static final String PLAN_CATG_CONST = 'Plan';
    static final String PRODCT_TYPE_CONST = 'Medical';
    
    /*
* @description : This method processes the input data and returns Quote Ids for all successes and partial successes
* @param List<String> statuses which can be Success and Failures and not equal to Pending
* @param List<Date> effectiveDatesToRun which specifies the month that needs to be run 
* @param List<String> toEmailAddresses : List of email addresses that should receive the success and error files for deletion
*/  
    public static void getdeleteQLIsReport(List<String> statuses, List<Date> effectiveDatesToRun, List<String> toEmailAddresses){
        
        List<String> allSuccessqliInfoRows = new List<String>();
        List<String> errorQliInfoRows = new List<String>();
        Map<String, QuoteLineItem> parentChildQLIMap = new Map<String, QuoteLineItem>();
        List<String>  successQuoteIdList = new List<String>();
        List<String>  ErrorQuoteIdList = new List<String>();
        
        //Call getwgsGrpsToProcess to get the Quote Ids to Process 
        List<List<String>> wgsGrpsToProcess = getwgsGrpsToProcess(statuses, effectiveDatesToRun);
        if(wgsGrpsToProcess.size() == 2){
        successQuoteIdList = wgsGrpsToProcess[0]; //all Success Quote Ids
        ErrorQuoteIdList = wgsGrpsToProcess[1]; //Partial Success Quote Ids 
        }
        
        System.debug('Success Quote Ids List Size : '+ successQuoteIdList.size());
        System.debug('Error QUote Ids List Size: '+ ErrorQuoteIdList.size());
        
        //Get all child Plan line Items that are eligible for delete based on the quote Ids 
        List<QuoteLineItem> childQLisToDelete = [SELECT Id, QuoteId, SFDCLegacyID__c, ProductName__c,Product_Type__c, ProductCategory__c, 
                                                 ParentQuoteLineItem__c, Situs_State_Abbrev__c, OpportunityId__c, OpportunityEffectiveDate__c, associatedAccountId__c, 
                                                 ClientName__c, CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate
                                                 FROM QuoteLineItem 
                                                 WHERE (QuoteId IN : successQuoteIdList
                                                        OR QuoteId IN : ErrorQuoteIdList)
                                                 AND ProductCategory__c =: PLAN_CATG_CONST
                                                 AND Product_Type__c =: PRODCT_TYPE_CONST
                                                 AND vlocity_ins__ContractCode__c = null
                                                 AND Contract_Codes__c = null];
        
        System.debug('Child QLI Delete list size: '+childQLisToDelete.size());
        
        if(childQLisToDelete.size()>0){
            for(QuoteLineItem qli: childQLisToDelete){
                String qliInfo = qli.Id+','+qli.SFDCLegacyID__c+','+qli.ProductName__c.replace(',', '')+','+qli.Product_Type__c+','+qli.ProductCategory__c
                    +','+qli.ParentQuoteLineItem__c+','+qli.Situs_State_Abbrev__c+','+qli.OpportunityId__c+','+qli.OpportunityEffectiveDate__c.format()
                    +','+qli.QuoteId+','+qli.associatedAccountId__c+','+qli.ClientName__c.replace(',', '')+','+qli.CreatedBy.Name+','+qli.CreatedDate.format()
                    +','+qli.LastModifiedBy.Name+','+qli.LastModifiedDate.format()+','+CHILDQLIDELREASON_CONST;
                if(successQuoteIdList.contains(qli.QuoteId)){
                    allSuccessqliInfoRows.add(qliInfo);
                }
                else{
                    errorQliInfoRows.add(qliInfo);
                }
            }
        }
        //Get Parent Product level QLIs that are eligible for delete with no child plans associated 
        List<QuoteLineItem> parentQLisToDelete = [SELECT Id, QuoteId, SFDCLegacyID__c, ProductName__c,Product_Type__c, ProductCategory__c, 
                                                  ParentQuoteLineItem__c, Situs_State_Abbrev__c, OpportunityId__c, OpportunityEffectiveDate__c, 
                                                  associatedAccountId__c, ClientName__c,CreatedBy.Name, CreatedDate, LastModifiedBy.Name, LastModifiedDate
                                                  FROM QuoteLineItem 
                                                  WHERE (QuoteId IN : successQuoteIdList
                                                         OR QuoteId IN : ErrorQuoteIdList)
                                                  AND ProductCategory__c =: PRODCT_CATG_CONST 
                                                  AND Product_Type__c =: PRODCT_TYPE_CONST];
        
        System.debug('Parent QLI Delete list size: '+parentQLisToDelete.size());
        
        if(parentQLisToDelete.size()>0){
            List<QuoteLineItem> childRecsforParentQLIList = [SELECT Id, QuoteId, ParentQuoteLineItem__c 
                                                             FROM QuoteLineItem
                                                             WHERE ParentQuoteLineItem__c IN : parentQLisToDelete];
            if(childRecsforParentQLIList.size()>0){
                for(QuoteLineItem parentChildQLI:childRecsforParentQLIList){
                    parentChildQLIMap.put(parentChildQLI.ParentQuoteLineItem__c, parentChildQLI);
                }
            }
        }
        
        if(parentQLisToDelete.size()>0){
            for(QuoteLineItem parentQLi: parentQLisToDelete){
                if(!parentChildQLIMap.containsKey(parentQLi.Id)){
                    String qliInfo = parentQLi.Id+','+parentQLi.SFDCLegacyID__c+','+parentQLi.ProductName__c.replace(',', '')+','+parentQLI.Product_Type__c+','+parentQLI.ProductCategory__c
                        +','+parentQLi.ParentQuoteLineItem__c+','+parentQLi.Situs_State_Abbrev__c+','+parentQLi.OpportunityId__c +','+parentQLi.OpportunityEffectiveDate__c.format()
                        +','+parentQLi.QuoteId+','+parentQLi.associatedAccountId__c+','+parentQLi.ClientName__c.replace(',', '')+','+parentQLi.CreatedBy.Name
                        +','+parentQLi.CreatedDate.format()+','+parentQLi.LastModifiedBy.Name+','+parentQLi.LastModifiedDate.format()+','+PARENTQLIDELREASON_CONST;
                    
                    if(successQuoteIdList.contains(parentQLi.QuoteId)){
                        allSuccessqliInfoRows.add(qliInfo);
                    }
                    else{
                        errorQliInfoRows.add(qliInfo);
                    }
                }
            }
        }
        
        System.debug('QLI Info rows sent in Email: '+Integer.valueOf(allSuccessqliInfoRows.size()+errorQliInfoRows.size()));
        if(allSuccessqliInfoRows.size()>0 || errorQliInfoRows.size()>0){
            sendEmail(allSuccessqliInfoRows, errorQliInfoRows, toEmailAddresses);
        }
        
    }
    
    /*
* @description : This method processes the input data and returns Quote Ids for all successes and partial successes
* @param List<String> statusList which can be Success and Failures and not equal to Pending
* @param List<Date> effectiveDateInput which specifies the month that needs to be run 
* @return List<List<String>> of both success QuoteIds and Failure QuoteIds
*/   
    public static List<List<String>> getwgsGrpsToProcess(List<String> statusList, List<Date> effectiveDatesInput){
        
        Map<String, List<WGS_Sold_Contract_Codes__c>>  successRecMap = new  Map<String, List<WGS_Sold_Contract_Codes__c>>();
        Map<String, List<WGS_Sold_Contract_Codes__c>>  errorsMap   =  new  Map<String, List<WGS_Sold_Contract_Codes__c>>();
        Set<String> qliIdsInserted = new Set<String>();
        List<String> wgsSuccessGrpList = new List<String>();
        List<String> wgsErrorGrpList = new List<String>();
        List<String> wgsSuccessQuoteIdsList = new List<String>();
        List<String> wgsErrorQuoteIdsList = new List<String>();
        List<List<String>> successErrorQuoteIdsList = new List<List<String>>(); //Output List for both success QuoteIds and partial success QuoteIds to Process
        Map<String, String> grpNumberCCSuccessStatusMap = new Map<String, String>(); // Concatenate grp number and cc as key, status as value in map
        Map<String, String> grpNumberQuoteIdMap = new Map<String, String>();
        Map<String, String> grpNumberCCMap = new Map<String, String>(); // Map that contains all WGS group numbers and related contract code string
        
        //Get the list of all records with Success and errors 
        List<WGS_Sold_Contract_Codes__c> wgsCCRecords = [SELECT Id, WGS_Group_Number__c, Contract_Code__c, QLI_ID_Created__c, 
                                                         Effective_Date__c, Status__c, Status_Message__c 
                                                         FROM WGS_Sold_Contract_Codes__c 
                                                         WHERE Status__c IN : statusList 
                                                         AND Effective_Date__c IN: effectiveDatesInput];
        //Populate successMap and errorMap based on status
        for(WGS_Sold_Contract_Codes__c wgsRec: wgsCCRecords){
            if(wgsRec.Status__c == 'Success'){
                if(!successRecMap.containsKey(wgsRec.WGS_Group_Number__c)){
                    successRecMap.put(wgsRec.WGS_Group_Number__c, new List<WGS_Sold_Contract_Codes__c>{wgsRec});
                }
                else{
                    List<WGS_Sold_Contract_Codes__c> successList = successRecMap.get(wgsRec.WGS_Group_Number__c);
                    successList.add(wgsRec);
                    successRecMap.put(wgsRec.WGS_Group_Number__c,successList);
                } 
                qliIdsInserted.add(wgsRec.QLI_ID_Created__c);
                grpNumberCCSuccessStatusMap.put(wgsRec.WGS_Group_Number__c+wgsRec.Contract_Code__c, wgsRec.Status__c);
            }
            else if(wgsRec.Status__c == 'Error'){
                if(!errorsMap.containsKey(wgsRec.WGS_Group_Number__c)){
                    errorsMap.put(wgsRec.WGS_Group_Number__c, new List<WGS_Sold_Contract_Codes__c>{wgsRec});
                }
                else{
                    List<WGS_Sold_Contract_Codes__c> errorList = errorsMap.get(wgsRec.WGS_Group_Number__c);
                    errorList.add(wgsRec);
                    errorsMap.put(wgsRec.WGS_Group_Number__c,errorList);
                } 
            }   
        }
        
        if(qliIdsInserted.size()>0){
            List<QuoteLineItem> qlisInsertedList = [SELECT Id, QuoteId, Group_Number__c
                                                    FROM QuoteLineItem 
                                                    WHERE Id IN: qliIdsInserted];
            System.debug('Inserted QLI List Size: '+ qliIdsInserted.size());
            
            for(QuoteLineItem qli: qlisInsertedList){
                grpNumberQuoteIdMap.put(qli.Group_Number__c, qli.QuoteId);
            }
        }
        
        //Compare and see if there are any errors for that WGS group       
        if(!successRecMap.isEmpty()){
            for(String wgsGrpNumber: successRecMap.keySet()){
                if(!errorsMap.containsKey(wgsGrpNumber)){
                    wgsSuccessGrpList.add(wgsGrpNumber);
                    wgsSuccessQuoteIdsList.add(grpNumberQuoteIdMap.get(wgsGrpNumber));
                }
                //Check if it's a partial success and errors in this current run have already success records
                else if(errorsMap.containsKey(wgsGrpNumber)){
                    List<WGS_Sold_Contract_Codes__c> errorList = errorsMap.get(wgsGrpNumber);
                    Boolean allSuccess = true; 
                    for(WGS_Sold_Contract_Codes__c wgsErrorRec: errorList){
                        if(!grpNumberCCSuccessStatusMap.containsKey(wgsErrorRec.WGS_Group_Number__c+wgsErrorRec.Contract_Code__c)){
                            allSuccess = false;
                        }
                    } 
                    if(allSuccess){
                        wgsSuccessGrpList.add(wgsGrpNumber);
                        wgsSuccessQuoteIdsList.add(grpNumberQuoteIdMap.get(wgsGrpNumber));
                    }
                    else{
                        wgsErrorGrpList.add(wgsGrpNumber);
                        wgsErrorQuoteIdsList.add(grpNumberQuoteIdMap.get(wgsGrpNumber));
                    }
                }
                
            }
        }
        
        successErrorQuoteIdsList.add(wgsSuccessQuoteIdsList);
        successErrorQuoteIdsList.add(wgsErrorQuoteIdsList);       
        
        System.debug('Result WGS Grps tp Process: '+ wgsSuccessGrpList.size());
        System.debug('Result Error WGS Grps tp Process: '+ wgsErrorGrpList.size());
        
        return  successErrorQuoteIdsList;
    }
    
    /*
* @description : This method sends an email out with success and failure QLIs attachments
* @param List<String> successQliInfoRows Input for success attachment
* @param List<String> errorQLIInfoRows Input for failure attachment
* @param List<String> toEmailAddresses : List of email addresses that should receive the success and error files for deletion
*/
    
    public static void sendEmail(List<String> successQliInfoRows, List<String> errorQLIInfoRows, List<String> toEmailAddresses){
        
        String headerStr = 'QuoteLineItem Id, SFDC Legacy QLIId, Product Name, Product Type, Product Category, Parent QLI Id, State Code, OpportunityId, Opp Effective Date, QuoteId, AccountId, Account Name, Created By, CreatedDate, Last Modified By, Last Modified Date, Delete Reason \n';
        String finalStr;
        List<Messaging.EmailFileAttachment> attchmntsList = new List<Messaging.EmailFileAttachment>();
        
        if(successQliInfoRows.size()>0){
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            finalStr = headerStr + String.join(successQliInfoRows, '\n');
            Blob csvBlob = Blob.valueOf(finalStr);
            string attfileName= 'SuccessQLIDeleteReport'+'_'+DateTime.now()+'.csv';
            csvAttc.setFileName(attfileName);
            csvAttc.setBody(csvBlob);
            attchmntsList.add(csvAttc);
        }
        if(errorQLIInfoRows.size()>0){
            Messaging.EmailFileAttachment csvAttc1 = new Messaging.EmailFileAttachment();
            finalStr = headerStr + String.join(errorQLIInfoRows, '\n');
            Blob csvBlob1 = Blob.valueOf(finalStr);
            string attfileName1= 'ErrorQLIDeleteReport'+'_'+DateTime.now()+'.csv';
            csvAttc1.setFileName(attfileName1);
            csvAttc1.setBody(csvBlob1);
            attchmntsList.add(csvAttc1);
        }
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        email.setSubject(SUBJECT_CONST);
        email.setToAddresses( toEmailAddresses );
        String body = 'Attached is the report of QLIs that can be deleted.' + '<br/>';
        email.setHtmlBody(body);
        email.setFileAttachments(attchmntsList);
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});        
        
    }
    
}