/**
* @File Name          : LGA_Group_Number_Request.cls
* @Description        : 
* @Author             : Accenture OffShore 
* @Group              : Raptors
* @Modification Log   : 
* Ver       Date            Author                  Modification
* 1.0    2/11/2020     Accenture OffShore        Initial Version
* 2.0    2/21/2020     Accenture OffShore        PRDCRM2-2210,2212
**/
global  with sharing class LGA_Group_Number_Request implements vlocity_ins.VlocityOpenInterface2 {
    
    //public String accountId;
    
    /**
* @description 
* @author Accenture OffShore | 2/12/2020 
* @param methodName 
* @param inputMap 
* @param outMap 
* @param optns 
* @return Boolean 
**/
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String,Object > outMap, Map < String, Object > optns) {
        //Onshore added try and catch block to handled exceptions 21-02-21
        Boolean invokeStatus = LGA_Constants.TRUEVALUE;
        try{
            if(LGA_Constants.ACCPREFUPDATE.equalsIgnoreCase(methodName)){
                accPreferenceUpdate(inputMap, outMap, optns);
            }
            else if(LGA_Constants.QLIGRPUPDT.equalsIgnoreCase(methodName)){
                qliGroupUpdate(inputMap, outMap, optns);
            }
            else if(LGA_Constants.ACCGRPDETAILS.equalsIgnoreCase(methodName)){
                //system.debug('@@@@@@@@@@@For LGA_Constants.ACCGRPDETAILS:  ' + methodName);
                fetchAccGrpDetails(inputMap, outMap, optns);
            }
            else if(LGA_Constants.QTEGRPUPDATE.equalsIgnoreCase(methodName)){
                //system.debug('@@@@@@@@@@@For QTEGRPUPDATE:    ' + methodName);
                quoteGroupUpdate(inputMap, outMap, optns);
            }  
        }catch(exception e){
            system.debug(LoggingLevel.ERROR, 'Apex Exception: Line# ' + (string.valueof(e.getLineNumber())).leftPad(5, LGA_Constants.UNDERSCORE) + ', ' + e.getMessage());
            outMap.put(LGA_Constants.ERRORKEY,LGA_Constants.ERRORMSG);
            //return false;
            invokeStatus = LGA_Constants.FALSEVALUE;
        } 
        return invokeStatus;   
    }
    
    /**
* @description 
* @author Accenture OffShore | 2/12/2020 
* @param input 
* @param outMap 
* @param optns 
* @return Map<String,Object> 
**/
    global void accPreferenceUpdate (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        
        String quoteId = (String)optns.get(LGA_Constants.QUOTEID);
        //Map<String, Object> requestGroupNumberStepMap = (Map<String, Object>) input.get(LGA_Constants.GRPNOREQSTEP);
        system.debug('@@@@@@@@Checkssssss:  ' + optns.get(LGA_Constants.CHECKBOXVALUE));
        String reqGrpNumber  = '';
        
        // Commented code for AccPref Update as per PRDCRM2-2210
        //
        /*Boolean checkBox;
//onshore enable the sanity check 21-02-2020

if(optns.get(LGA_Constants.CHECKBOXVALUE) == null){
system.debug('@@@@@@@@ Inside checkbox Null Line 62:  '+  optns.get(LGA_Constants.CHECKBOXVALUE));
checkBox = false;
}
else{
checkBox = (boolean)optns.get(LGA_Constants.CHECKBOXVALUE);
}
system.debug('@@@@@@@@Checkssssss:  ' + checkBox );
//Boolean 
//String groupNumber  = '';
if(String.isNotBlank((String)optns.get(LGA_Constants.GROUPNUMBER))){
system.debug('@@@@@@@@ Inside checkbox Null Line 72:  '+  optns.get(LGA_Constants.GROUPNUMBER));
groupNumber = (String)optns.get(LGA_Constants.GROUPNUMBER);
}

system.debug('quoteId'+quoteId);
system.debug('checkBox'+checkBox);
system.debug('groupNumber'+groupNumber);
String accountId;
String reqGrpNumber = '';
if(String.isNotBlank(quoteId) && Schema.sObjectType.Quote.isAccessible()){
for(Quote qte : [SELECT AccountId FROM Quote WHERE Id=: quoteId LIMIT 1]){
//accId = qte.AccountId;
accountId = qte.AccountId;
}
}
system.debug('@@@@@accountId:   '+ accountId);

List<Account_Preferences__c> accPreferenceList = new List<Account_Preferences__c>();
if(String.isNotBlank(accountId) && Schema.sObjectType.Account_Preferences__c.isAccessible()){
accPreferenceList = [SELECT Account_Legal_Name__c, Customer_Requested_Group_Number__c, Id 
FROM Account_Preferences__c WHERE Account_Legal_Name__c=: accountId ];
}
system.debug('accPreferenceList'+accPreferenceList);
List<Account_Preferences__c> accPreferenceListUpdate = new List<Account_Preferences__c>();
// add groupNumber in the criteria
if(checkBox && !accPreferenceList.isempty() && String.isNotBlank(groupNumber) ){
reqGrpNumber = groupNumber;
for(Account_Preferences__c accPref :accPreferenceList ){
Account_Preferences__c newAccPref = New Account_Preferences__c();
newAccPref.Id = accPref.Id;
newAccPref.Customer_Requested_Group_Number__c = groupNumber;
accPreferenceListUpdate.add(newAccPref);
}

}
if(!accPreferenceListUpdate.isempty()){
system.debug('accPreferenceListUpdate'+accPreferenceListUpdate);
database.update(accPreferenceListUpdate,false);
}
system.debug('@@@@@@@reqGrpNumber:  ' + reqGrpNumber);
system.debug('@@@@@@@reqGrpNumber:  ' + quoteId);
system.debug('@@@@@@@reqGrpNumber:  ' + groupNumber);*/
        
        String eventLogId = CMIntegrationService.generateGroupNumber(quoteId,reqGrpNumber);
        system.debug('@@@@@@@eventLogId:  ' + eventLogId);
        
        List<Integration_Error_Log__c> errorLogList = new List<Integration_Error_Log__c>();
        if(String.isNotBlank(eventLogId) && Schema.sObjectType.Integration_Error_Log__c.isAccessible()){
            errorLogList = [SELECT Id, Category__c, Error_Code__c, 
                            Error_Message__c, Integration_Event_Log__c 
                            From Integration_Error_Log__c 
                            Where Integration_Event_Log__c =: eventLogId
                            Limit 50000];
        }
        
        if(errorLogList.isEmpty()){
            system.debug('@@@@@@@if errorLogList  empty');
            /* Specify DataRaptor extract or transform to call */
            String drName = LGA_Constants.MULTIQLIDATARAPT; 
            /* Populate the input JSON */
            Map<String, Object> myTransformData = new Map<String, Object>{'Id'=>quoteId}; 
                /* Call the DataRaptor */
                vlocity_ins.DRProcessResult result = vlocity_ins.DRGlobal.process(myTransformData, drName); 
            /* Deserialize the DataRaptor output for processing in Apex */ 
            List<Map<String, Object>> myTransformResult = (List<Map<String, Object>>)result.toJsonList(); 
            system.debug('-------Extract DR Output------ : '+myTransformResult[0]);
            
            String strJSON = Json.serialize(myTransformResult[0].get(LGA_Constants.QLIGRPNOS));
            system.debug('-------Extract DR Output result------ : '+ strJSON);
            
            outMap.put(LGA_Constants.OUTPUT_QLIDETAILS,strJSON);
            
            
        }
        else if(!errorLogList.isEmpty()){
            system.debug('@@@@@@@if errorLogList not empty');
            outMap.put(LGA_Constants.ERROR,errorLogList[0].Error_Message__c);
            
        }
        
    }
    
    
    /**
* @description 
* @author Accenture OffShore | 2/12/2020 
* @param input 
* @param outMap 
* @param optns 
* @return void 
**/
    global void qliGroupUpdate (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        
        String quoteId = (String)optns.get(LGA_Constants.QUOTEID);
        String accountId = (String)optns.get(LGA_Constants.ACCOUNTID);
        String qliId = LGA_Constants.QLIIDSTR;
        String grpNo = LGA_Constants.GRPNOSTR;
        String claimSys = LGA_Constants.CLAIMSYSSTR;
        //Group__c grp = new Group__c();
        Group__c grp;
        Map<String,List<String>> reqGrpMap = new Map<String,List<String>>();
        //Map<String,String> reqGrpMap2 = new Map<String,String>();
        Map<String,Group__c> grpMap = new Map<String,Group__c>();
        List<QuoteLineItem> qliUpdtList = new List<QuoteLineItem>();
        List<Group__c> newGroups = new List<Group__c>();
        List<String> valList ;
        Map<String,Object> objMap = new Map<String,Object>(); 
        if(!((List<Object>)optns.get(LGA_Constants.QLIGRPDETAILS)).isEmpty() && String.isNotBlank(accountId) && String.isNotBlank(quoteId)){
            for(Object obj : (List<Object>)optns.get(LGA_Constants.QLIGRPDETAILS)){
                
                //Map<String,Object> objMap = (Map<String,Object>)obj;
                objMap = (Map<String,Object>)obj;
                if(String.isNotBlank((String)objMap.get(grpNo)) && String.isNotBlank((String)objMap.get(claimSys)) ){
                    String keyStr = ((String)objMap.get(grpNo) +LGA_Constants.UNDERSCORE+ (String)objMap.get(claimSys));
                    if(reqGrpMap.containskey(keyStr)){
                        reqGrpMap.get(keyStr).add((String)objMap.get(qliId));
                    }
                    else{
                        //List<String> valList = new List<String>();
                        valList = new List<String>();
                        valList.add((String)objMap.get(qliId));
                        reqGrpMap.put(keyStr, valList);
                    }
                }
                
            }
            System.debug('@@@@@@@accountId:   '+ accountId);
            system.debug('@@@@@@@@reqGrpMap:    ' + reqGrpMap);
            if(String.isNotBlank(accountId) && Schema.sObjectType.Group__c.isAccessible() && !reqGrpMap.isEmpty() ){
                QuoteLineItem qli;// = new QuoteLineItem();
                for(Group__c grp1 : [Select Id,Account__c,ClaimSystem__c,Name,IsActive__c 
                                     From Group__c 
                                     Where Account__c =:accountId AND IsActive__c = true 
                                     Limit 50000 ]){
                                         String keyStr = (grp1.Name + LGA_Constants.UNDERSCORE + grp1.ClaimSystem__c );
                                         if(reqGrpMap.containskey(keyStr)){
                                             for(String qliVal : reqGrpMap.get(keyStr)){
                                                 qli = new QuoteLineItem();//QuoteLineItem qli = new QuoteLineItem();
                                                 qli.Id = qliVal;
                                                 qli.Group__c = grp1.Id;
                                                 qliUpdtList.add(qli);
                                             }
                                             reqGrpMap.remove(keyStr);
                                         }
                                         
                                     }
            }
            //system.debug('@@@@@@@@@qliUpdtList  :   ' +qliUpdtList);
            //New Groups Creation part
            if(!reqGrpMap.isEmpty()){
                for(String grpName : reqGrpMap.keySet()){
                    //Group__c grp = new Group__c();
                    grp = new Group__c();
                    grp.Name = grpName.split(LGA_Constants.UNDERSCORE)[0];
                    grp.ClaimSystem__c = grpName.split(LGA_Constants.UNDERSCORE)[1];
                    grp.Account__c = accountId;
                    grp.IsActive__c =true;
                    newGroups.add(grp);
                }
            }
            
            if(!newGroups.isEmpty()){
                system.debug('@@@@@@@@@@@ Inside Update QLI' + newGroups);
                database.insert(newGroups,false);
            }
            
            /*groupsList = [Select Id,Account__c,ClaimSystem__c,Name,IsActive__c 
From Group__c Where Account__c =: accountId 
AND IsActive__c = true ORDER BY LastmodifiedDate DESC]; */
            //Mapping the newly created groups to the requested QLI's
            System.debug('@@@@@@@accountId:   '+ accountId);
            if(String.isNotBlank(accountId) && Schema.sObjectType.Group__c.isAccessible() && !reqGrpMap.isEmpty()){
                QuoteLineItem qli;// = new QuoteLineItem();
                for(Group__c grp2 : [Select Id,Account__c,ClaimSystem__c,Name,IsActive__c 
                                     From Group__c 
                                     Where Account__c =: accountId AND IsActive__c = true
                                     Limit 50000 ]){
                                         //for(Group__c grp : groupsList){
                                         String keyStr = (grp2.Name + LGA_Constants.UNDERSCORE + grp2.ClaimSystem__c );
                                         if(reqGrpMap.containskey(keyStr)){
                                             for(String qliVal : reqGrpMap.get(keyStr)){
                                                 qli = new QuoteLineItem();//QuoteLineItem qli = new QuoteLineItem();
                                                 qli.Id = qliVal;
                                                 qli.Group__c = grp2.Id;
                                                 qliUpdtList.add(qli);
                                             }
                                             reqGrpMap.remove(keyStr);
                                         }
                                         
                                     }
            }
            //system.debug('@@@@@@@@@qliUpdtList  :   ' +qliUpdtList);
        }
        
        //Updating the QLI's with Group Details
        if(!qliUpdtList.isEmpty()){
            system.debug('@@@@@@@@@qliUpdtList  :   ' +qliUpdtList);
            system.debug('@@@@@@@@@qliUpdtList  :   ' +qliUpdtList.size());
            database.update(qliUpdtList,false);
        }
        
    }
    
    
    
    /**
* @description : added as part of : PRDCRM2-2210,2212. This method updates the group no on Quote if required.
* @author Accenture OffShore | 2/22/2020 
* @param input 
* @param outMap 
* @param optns 
* @return void 
**/
    global void quoteGroupUpdate (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        
        String qteId = (String)optns.get(LGA_Constants.QUOTEID);
        String accId = (String)optns.get(LGA_Constants.ACCOUNTID);
        List<Group__c> grpList = [Select Id,Account__c,ClaimSystem__c,Name,IsActive__c 
                                  From Group__c 
                                  Where Account__c =: accId 
                                  AND IsActive__c = true 
                                  ORDER BY LastmodifiedDate DESC Limit 50000]; 
        List<Quote> updtQuote = new List<Quote>();
        Map<String,Group__c> grpMap = new Map<String,Group__c>();
        for(Group__c grp : grpList){
            if(grp.ClaimSystem__c == LGA_Constants.WGS2){
                system.debug('@@@@@@@@@@ Inside If:  '+ grp);
                grpMap.put((String)grp.ClaimSystem__c, grp);
                break;
            }
        }
        
        system.debug('@@@@@@@@@@@grpMap:   ' + grpMap );
        if(grpMap.IsEmpty()){
            for(Group__c grp : grpList){
                system.debug('@@@@@@@@@@ Inside If Empty Map:  '+ grp);
                grpMap.put((String)grp.ClaimSystem__c, grp);
                break;
            }
        }
        String claimSys = (new list<string>(grpMap.keySet()))[0] ;
        //Check for group on quote
        Quote newQTE;
        for(Quote qte : [SELECT Id,GroupNumber__c,
                         GroupNumber__r.ClaimSystem__c,
                         GroupNumber__r.IsActive__c  
                         From Quote Where Id =:qteId Limit 50000]){
                             //Quote newQTE = new Quote();
                             newQTE = new Quote();
                             // Check if quote group No is null
                             if(String.isBlank((String)qte.GroupNumber__c) 
                                && !grpMap.IsEmpty() ){
                                    //Quote newQTE = new Quote();
                                    newQTE.Id = qte.Id;
                                    newQTE.GroupNumber__c = grpMap.get(claimSys).Id;
                                    
                                    updtQuote.add(newQTE);
                                }
                             // Check if quote is  having group but claimsystem is not WGS2.0
                             else if(!grpMap.IsEmpty() 
                                     && (String.isNotBlank((String)qte.GroupNumber__c) 
                                         && (qte.GroupNumber__r.ClaimSystem__c != LGA_Constants.WGS2)) ){
                                             //Quote newQTE = new Quote();
                                             newQTE.Id = qte.Id;
                                             newQTE.GroupNumber__c = grpMap.get(claimSys).Id;
                                             
                                             updtQuote.add(newQTE);
                                         }
                             // Check if quote is  having group but claimsystem is  WGS2.0 but not active
                             else if( !grpMap.IsEmpty() 
                                     && (String.isNotBlank((String)qte.GroupNumber__c) 
                                         && ((qte.GroupNumber__r.ClaimSystem__c == LGA_Constants.WGS2) 
                                             && (!qte.GroupNumber__r.IsActive__c ))) ) {
                                                 //Quote newQTE = new Quote();
                                                 newQTE.Id = qte.Id;
                                                 newQTE.GroupNumber__c = grpMap.get(claimSys).Id;
                                                 
                                                 updtQuote.add(newQTE);
                                             }
                         }
        
        if(!updtQuote.IsEmpty()){
            system.debug('@@@@@@@@@@@updtQuote:    ' + updtQuote);
            database.update(updtQuote,false);
        }
        
    }
    
    /**
* @description 
* @author Accenture OffShore | 2/12/2020  
* @param input 
* @param outMap 
* @param optns 
* @return void 
**/
    global void fetchAccGrpDetails (Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns){
        
        String accId = (String)optns.get(LGA_Constants.ACCOUNTID);
        Map<String,String> accGrpDetails = new Map<String,String>();
        List<String> allClaimsSystems = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Group__c.ClaimSystem__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            allClaimsSystems.add(pickListVal.getLabel());
        }     
        System.debug('@@@@@@@picklistEntryLists:    ' + allClaimsSystems);
        
        if(String.isNotBlank(accId) && Schema.sObjectType.Group__c.isAccessible()){
            for(Group__c grp: [Select Id,Account__c,ClaimSystem__c,Name 
                               From Group__c 
                               Where Account__c =:accId  AND IsActive__c = true 
                               Limit 50000 ]){
                                   if(accGrpDetails.containskey(grp.ClaimSystem__c)){
                                       //accGrpDetails.get(grp.ClaimSystem__c) + ','+ grp.Name;
                                       String grpNames = accGrpDetails.get(grp.ClaimSystem__c);
                                       grpNames = grpNames + LGA_Constants.COMMA +grp.Name; //LGA_Constants.COMMA
                                       accGrpDetails.put(grp.ClaimSystem__c,grpNames);
                                   }else{
                                       String grpName = grp.Name;
                                       accGrpDetails.put(grp.ClaimSystem__c,grpName);
                                       
                                   }
                               }
        }
        System.debug('@@@@@@@@@@accGrpDetails :      ' + accGrpDetails);
        outMap.put(LGA_Constants.ACCCLAIMSYS,allClaimsSystems);
        outMap.put(LGA_Constants.ACCGRPDATA,accGrpDetails);
        
    }
    
}