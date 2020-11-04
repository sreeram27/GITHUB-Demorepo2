/*******************************************************************************************
@class Name  : LGA_AccountStructureOSRemoteService
@created By  : Accenture Panthers Offshore
@createdDate : 10/18/2019
@description : This class Is used to create Group Plan Designs (PRDCRM-43568) and 
Employee categoty selection retrieval and Post Back (PRDCRM-43938)
********************************************************************************************/
global with sharing class LGA_AccountStructureOSRemoteService  implements vlocity_ins.VlocityOpenInterface {
    
    
    /*******************************************************************************************
@method Name  : invokeMethod
@description : This method gets called  by Vlocity Framework to execute APEX Remote Action
@return : Boolean
@param : methodName,inputMap,outMap,optns
********************************************************************************************/
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        Boolean executedSuccessfully = false;
        if (LGA_UTIL_Constants.CREATE_GROUP_PLAN_REMOTE_METHOD_NAME.equalsIgnoreCase(methodName)) 
        {   
            try{
                createGroupPlan((String)options.get(LGA_UTIL_Constants.CREATE_GROUP_PLAN_OPTIONS_ATTR_IMPLCASE)); 
                executedSuccessfully = true;
            }Catch(Exception ex){
                executedSuccessfully = false;
                System.debug('****The following exception has occurred in createGroupPlan method of LGA_AccountStructureOSRemote : '+ex);
            }             
        }else if(LGA_UTIL_Constants.FETCH_EMP_CATEGORY_OPTIONS.equalsIgnoreCase(methodName)){           
            String selectedEmpCategoryInGroup =  (String)inputMap.get(LGA_UTIL_Constants.SELECTED_EMP_CATEGORY);
            if(selectedEmpCategoryInGroup != null){
                List<EmployeeCategory> empcategoryList = fetchEmpCategory(selectedEmpCategoryInGroup);            
                executedSuccessfully = true;
                outMap.put(LGA_UTIL_Constants.EMP_CATEGORY_NODE_NAME, empcategoryList);
            }else {
                executedSuccessfully = false;
            }
            
        }else if (LGA_UTIL_Constants.DELETE_EMP_CLASS_METHODNAME.equalsIgnoreCase(methodName)) 
        {   
            try{
                String deltedEmpClass =  (String)inputMap.get(LGA_UTIL_Constants.DELETED_EMPLOYEE_CLASS );
                //system.debug('@@@@@@@@@@@@@Inside Delete Invoke:   ' + inputMap);
                //system.debug('@@@@@@@@@@@@@Inside Delete Invoke:   ' + deltedEmpClass);
                //system.debug('@@@@@@@@@@@@@Inside Delete Invoke:   ' + inputMap.get(LGA_UTIL_Constants.DELETED_EMPLOYEE_CLASS));
                deleteEmployeeClasses (deltedEmpClass); 
                executedSuccessfully = true;
            }Catch(Exception ex){
                executedSuccessfully = false;
                System.debug('****The following exception has occurred in deleteEmployeeClasses method of LGA_AccountStructureOSRemote : '+ex);
            }
        }else if(LGA_UTIL_Constants.FETCH_BILLING_OPTIONS.equalsIgnoreCase(methodName)){               
            String selectedBillingInGroup =  (String)inputMap.get(LGA_UTIL_Constants.SELECTED_BILLING );
            if(selectedBillingInGroup != null){
                List<Billing> billingList = fetchBillingArrangement(selectedBillingInGroup);            
                executedSuccessfully = true;
                outMap.put(LGA_UTIL_Constants.BILLING_NODE_NAME, billingList);
                outMap.put(LGA_UTIL_Constants.BILLING_PATTERN_SELECTED, false);
            }
            else{
                executedSuccessfully = false;
            }            
        }else if(LGA_UTIL_Constants.FETCH_QLI_DEMOSTIC_PARTNER_NEW_HIRE.equalsIgnoreCase(methodName)){
            List<PicklistVals> domesticParnerList = fetchQLIDemesticPartner();
            List<PicklistVals> newHireProbList = fetchQLINewHireProbation();
            outMap.put(LGA_UTIL_Constants.DOMESTIC_PARTNER_VALS, domesticParnerList);
            outMap.put(LGA_UTIL_Constants.NEW_HIRE_PROB_VALS, newHireProbList);
            executedSuccessfully = true;               
        } else if(LGA_UTIL_Constants.ATTACH_BILLING_INVOICE_ACCTSTRUC.equalsIgnoreCase(methodName)){               
            String selectedAccountId =  (String)options.get(LGA_UTIL_Constants.ACCOUNT_LEGAL_NAME_ID);
            String selectedGroupId =  (String)options.get(LGA_UTIL_Constants.SELECTED_GROUP_ID);
            String selectedBillingOption = (String)inputMap.get(LGA_UTIL_Constants.SELECTED_BILLING);
            List<Object> selectedBillingArrngNodeList = null;
            String selectedBillingArrngNode = null;
            Boolean isBillingPatternChanged = false;
            if(!String.isEmpty((String)options.get(LGA_UTIL_Constants.SELECTED_BILLING_ARRANGEMENT_NODE))){
                
                selectedBillingArrngNode = (String)options.get(LGA_UTIL_Constants.SELECTED_BILLING_ARRANGEMENT_NODE);
                System.debug('preselectedBillingOption : ' + selectedBillingOption + ' , selectedBillingArrngNode : ' + selectedBillingArrngNode);
                if(!selectedBillingOption.equalsIgnoreCase(selectedBillingArrngNode)){                    
                    deleteInvoicesForSelectedAccount(selectedAccountId); 
                    isBillingPatternChanged = true; 
                }
            }else{
                selectedBillingArrngNode = (String)options.get(LGA_UTIL_Constants.SELECTED_BILLING_ARRANGEMENT_NODE);
            }
            System.debug('isBillingPatternChanged : ' + isBillingPatternChanged);
            if(String.isBlank(selectedBillingArrngNode)){
                selectedBillingArrngNode = selectedBillingOption;
            }
            if(selectedAccountId != null && selectedGroupId != null){
                executedSuccessfully = attachInvoiceToBillingArrangement(options,selectedBillingArrngNode,isBillingPatternChanged);  
                
            }else{
                executedSuccessfully = false;
            }
        }else if(LGA_UTIL_Constants.UPDATE_EMP_CATEGORY_DEL_GPDS.equalsIgnoreCase(methodName)){
            executedSuccessfully = updateEmpCatGPDs(inputMap);  
        }
        return executedSuccessfully;
    }
    
    
    /*******************************************************************************************
@method Name  : updateEmpCatGPDs
@description : PRDCRM-1254 : This method updates Employee Category Global Picklist values as per user selection
and deletes related GPDS under that group
@param : inputMap
********************************************************************************************/
    private boolean updateEmpCatGPDs(Map<String,Object> inputMap){
        boolean updatesSuccess = false;
        try{  
            String preSelectedEmpCategory =  (String)inputMap.get(LGA_UTIL_Constants.PRESELCTED_EMP_CATEGORY);
            String selectedEmpCategory =  (String)inputMap.get(LGA_UTIL_Constants.SELECTED_EMP_CATEGORY);
            String relatedAccountId =  (String)inputMap.get(LGA_UTIL_Constants.ACCOUNT_ID);
            String relatedGroupId =  (String)inputMap.get(LGA_UTIL_Constants.GROUP_ID);
            List<String> preSelectedEmpCatList = preSelectedEmpCategory.split(';');
            List<String> selectedEmpCatList = selectedEmpCategory.split(';');        
            Set<String> deletedEmpCatSet = new Set<String>();
            for(String preSelEmpCat:preSelectedEmpCatList){
                if(!selectedEmpCatList.contains(preSelEmpCat)){
                    deletedEmpCatSet.add(preSelEmpCat);
                }
            }
            List<Group_Plan_Design__c> attachedGPDList = null;
            
            if(deletedEmpCatSet != null && deletedEmpCatSet.size() > 0){
                
                attachedGPDList = [SELECT ID from Group_Plan_Design__c 
                                   WHERE Group__c = :relatedGroupId 
                                   AND Account_Legal_Name__c = :relatedAccountId
                                   AND Employee_Category__c IN :deletedEmpCatSet
                                   WITH SECURITY_ENFORCED LIMIT 50000];           
            }  
            
            Group__c selectedGroup = [SELECT ID,Employee_Category__c from Group__c 
                                      WHERE Id = :relatedGroupId LIMIT 50000];
            selectedGroup.Employee_Category__c = selectedEmpCategory;
           database.update (selectedGroup) ; 
            if(attachedGPDList != null && attachedGPDList.size()>0){
               database.delete (attachedGPDList); 
            }
           // System.debug('gpds are deletd successfully');   
            updatesSuccess = true;
        }catch(Exception ex){
            //System.debug(' Exception in updateEmpCatGPDs : ' + ex);
            updatesSuccess = false;
        }
        
        return updatesSuccess;        
    }
    
    /*******************************************************************************************
@method Name  : fetchEmpCategory
@description : PRDCRM-43938 : This method pulls Employee Category Global Picklist values and corresponding Multiselect Picklist values of Group
@param : selectedEmpCategoryInGroup
********************************************************************************************/
    private List<EmployeeCategory> fetchEmpCategory(String selectedEmpCategoryInGroup){   
        List<String> selectedEmpCategoryInGroupList = selectedEmpCategoryInGroup.split(';');        
        Schema.DescribeFieldResult descResult = Group__c.Employee_Category__c.getDescribe();
        Schema.SObjectField employeeCategoryPicklist =  descResult.getSObjectField();
        List<PicklistEntry> empCategoryEntries = employeeCategoryPicklist.getDescribe().getPicklistValues();
        
        List<EmployeeCategory> employeeCategoryList = new List<EmployeeCategory>();
        
        for(PicklistEntry empCategoryPicklistEntry : empCategoryEntries){
            
            String picklistVal = empCategoryPicklistEntry.getValue();
            String picklistLabel = empCategoryPicklistEntry.getLabel();
            
            if(selectedEmpCategoryInGroupList.contains(picklistVal)){
                
                EmployeeCategory empCategory = new EmployeeCategory(true,picklistLabel);
                employeeCategoryList.add(empCategory);
            }
            else{
                EmployeeCategory empCategory = new EmployeeCategory(false,picklistLabel);
                employeeCategoryList.add(empCategory);
            }
        }
        return employeeCategoryList;
    }
    
    
    public with sharing class EmployeeCategory{
        
        public Boolean vlcSelected {get;private set;}
        public String employeeCategory {get;private set;}
        
        EmployeeCategory(Boolean vlcSelected , String employeeCategory){
            this.vlcSelected = vlcSelected;
            this.employeeCategory = employeeCategory;
        }
        
    }
    
    /*******************************************************************************************
@method Name  : fetchBillingArrangement
@description : PRDCRM-45916 : This method pulls Billing Arrangement Picklist values from Group.
@param : selectedBillingInGroup
********************************************************************************************/
    private List<Billing> fetchBillingArrangement(String selectedBillingInGroup){    
        
        
        
        String selectedBillingInGroupList = selectedBillingInGroup; 
        
        Schema.DescribeFieldResult descResult = Group__c.Billing__C.getDescribe();
        Schema.SObjectField billingPicklist =  descResult.getSObjectField();
        List<PicklistEntry> billingEntries = billingPicklist.getDescribe().getPicklistValues();
        
        List<Billing> billingList = new List<Billing>();
        for(PicklistEntry billingPicklistEntry : billingEntries){
            
            String picklistVal = billingPicklistEntry.getValue();
            String picklistLabel = billingPicklistEntry.getLabel();
            
            if(selectedBillingInGroupList.contains(picklistVal)){
                
                Billing billingArr = new Billing(true,picklistLabel);
                billingList.add(billingArr);
            }
            else{
                Billing billingArr = new Billing(false,picklistLabel);
                billingList.add(billingArr);
            }
        }
        return billingList;
    }
    
    
    
    
    public with sharing class Billing{
        
        public Boolean vlcSelected;
        public String billing;
        
        Billing (Boolean vlcSelected , String billing){
            this.vlcSelected = vlcSelected;
            this.billing = billing;
        }
        
    }
    
    
    
    /*******************************************************************************************
@method Name  : createGroupPlan
@description :  PRDCRM-46568 We are creating GroupPlanDesign Records after Employee Class Reocrds created
@param : inputMap,outMap,optns
********************************************************************************************/
    public void createGroupPlan(String implCaseId){        
        
        List<Group_Plan_Design__c> gpdToInsertList = new List<Group_Plan_Design__c>();
        List<String> existingGPDList = new List<String>();      
        Order implCase = [Select Id,QuoteId,Group_Name__c FROM Order WHERE Id =: implCaseId WITH SECURITY_ENFORCED];         
        List<Group__C> grp = [select id,name,Employee_Category__c,Account__c from Group__c where ID =:implCase.Group_Name__c LIMIT 50000 ];
        List<QuoteLineItem> qliList = [Select Id, GPDSoldRenewedProducts__c,QuoteId , Quote.GroupNumber__c From Quotelineitem Where QuoteId  =: implCase.QuoteId AND GPDSoldRenewedProducts__c  = True limit 50000];
        List<Employee_Class__c>  employeeClassList = [Select Id, Employee_Class_Type__c ,Name,Group__c,Account_Legal_Name__c,Employee_Class_Name__c,Group__r.Employee_Category__c,Group__r.Account__c  From Employee_Class__c Where Group__c =: implCase.Group_Name__c limit 50000];
        
        Set<Id> qliIds = (new Map<Id,QuotelineItem>(qliList)).keySet();
        Set<Id> ecIds = (new Map<Id,Employee_Class__c>(employeeClassList)).keySet();        
        for(Group_Plan_Design__c gpd :[Select Id,Employee_Class_Record_ID__c,QuoteLineItem_Record_ID__c,Group__c,Employee_Category__c,Account_Legal_Name__c From Group_Plan_Design__c Where Employee_Class_Record_ID__c IN: ecIds AND QuoteLineItem_Record_ID__c IN: qliIds limit 50000]){
            
            String uniqueGPDStr = string.valueOf(gpd.QuoteLineItem_Record_ID__c) + '-' + string.valueOf(gpd.Employee_Class_Record_ID__c) + '-' +  string.valueOf(gpd.Employee_Category__c);
            existingGPDList.add(uniqueGPDStr); 
        } 
        List<String> strQLIIdEmpClassId = new List<String>();
        String strTemp = '';
        for(Quotelineitem qli :qliList ){
            
            for(Employee_Class__c es :employeeClassList ){
                strTemp = qli.id + '-' + es.id;
                strQLIIdEmpClassId.add(strTemp);
            }
        }
        List<string> listEmpCategory = grp[0].Employee_Category__c.split(';');
        List<String> strQLIIdEmpClassIdEmpCategoty = new List<String>();
        String strTemp1 = '';
        for(String strKey :strQLIIdEmpClassId ){
            for(String strCat :listEmpCategory ){
                strTemp1 = strKey + '-' + strCat;                                               
                strQLIIdEmpClassIdEmpCategoty.add(strTemp1);                                              
            }
        }
        
        
        for(String key :strQLIIdEmpClassIdEmpCategoty )
        {
            if(!existingGPDList.contains(key))
            {
                List<string> listVal =  key.split('-');
                if(listVal.size() >= 3){
                    Group_Plan_Design__c gpd = new Group_Plan_Design__c();                            
                    gpd.Employee_Class_Record_ID__c = listVal[1];
                    gpd.QuoteLineItem_Record_ID__c  = listVal[0];
                    gpd.Group__c = grp[0].id;
                    gpd.Employee_Category__c = listVal[2];
                    gpd.Account_Legal_Name__c = grp[0].Account__c;
                    gpdToInsertList.add(gpd);
                } 
            }
        }
        
        
        
        if(!gpdToInsertList.IsEmpty()){
            database.Insert(gpdToInsertList,false);
        }
        
        
    }
    
    /*******************************************************************************************
@method Name  : deltedEmployeeClass
@description : PRDCRM-43938 : This method is to Delete the EmployeeClass from the Backend
@param : deltedEmpClass
********************************************************************************************/
    private void deleteEmployeeClasses(string DelempID) {
         List<Group_Plan_Design__c> gpdToDelete = new List<Group_Plan_Design__c>();
        if (DelempID!= Null || DelempID!= '') {
         gpdToDelete =[select id,name from Group_Plan_Design__c where Employee_Class_Record_ID__c =: DelempID LIMIT 50000 ];
            //outputMap.put(LGA_Constants.OUTPUT_DCLIST,LGA_Constants.EMPTY_STRING);
            Database.delete(DelempID,false);
            Database.delete(gpdToDelete,false);
            
        }   
        
    }
    /*******************************************************************************************
@method Name  : fetchQLIDemesticPartner
@description : PRDCRM-47442 : This method pulls QLI's Domestic Partner
Indicator Picklist values | Accenture Panthers Team
@return : List<PicklistVals>
********************************************************************************************/
    private List<PicklistVals> fetchQLIDemesticPartner(){   
        
        Schema.DescribeFieldResult domesticPartnerDescResult = QuoteLineItem.Domestic_Partner_Indicator__c.getDescribe();
        List<PicklistVals> domPartnerList = fetchPicklistValues(domesticPartnerDescResult);
        return domPartnerList;
    }
    
    /*******************************************************************************************
@method Name  : fetchQLINewHireProbation
@description : PRDCRM-47442 : This method pulls QLI's New Hire Probationary Period Picklist values | Accenture Panthers Team
@return : List<PicklistVals>
********************************************************************************************/
    private List<PicklistVals> fetchQLINewHireProbation(){   
        
        Schema.DescribeFieldResult newHireProbDescResult = QuoteLineItem.New_Hire_Probationary_Period__c.getDescribe();
        List<PicklistVals> newHireProbList = fetchPicklistValues(newHireProbDescResult);
        return newHireProbList;
    }
    
    /*******************************************************************************************
@method Name  : fetchPicklistValues
@description : PRDCRM-47442 : This method pulls Picklist values | Accenture Panthers Team
@return : List<PicklistVals>
********************************************************************************************/
    private List<PicklistVals> fetchPicklistValues(Schema.DescribeFieldResult descResult){
        Schema.SObjectField descPicklist =  descResult.getSObjectField();
        List<PicklistEntry> picklistEntries = descPicklist.getDescribe().getPicklistValues();            
        List<PicklistVals> picklistValsList = new List<PicklistVals>();     
        
        /* Added below 2 lines to add --None-- as picklist values */
        PicklistVals blankPicklistVal = new PicklistVals(' ',LGA_UTIL_Constants.NONE_PICKLIST_LABEL);
        picklistValsList.add(blankPicklistVal);
        
        for(PicklistEntry picklistEntry : picklistEntries){
            String picklistVal = picklistEntry.getValue();
            String picklistLabel = picklistEntry.getLabel();            
            PicklistVals domPartner = new PicklistVals(picklistVal,picklistLabel);
            picklistValsList.add(domPartner);
        }
        
        return picklistValsList;
        
    }
    
    
    public with sharing class PicklistVals{
        
        String value;
        String apiName;
        
        PicklistVals(String value , String apiName){
            this.value = value;
            this.apiName = apiName;
        }
        
    }
    
    /*******************************************************************************************
@method Name  : attachInvoiceToBillingArrangement
@description : PRDCRM-49070 : This method automates creation of Billing Arrangement record, association to of BA to GPDs and invoice| Accenture Panthers Team
@param : Map<String,Object> options,String selectedBillingOption, Boolean isBillingPatternChanged
@return : Boolean
********************************************************************************************/
    private Boolean attachInvoiceToBillingArrangement(Map<String,Object> options,String selectedBillingOption, Boolean isBillingPatternChanged){   
        
        Boolean attachInvoice = false;
        String selectedAccountId =  (String)options.get(LGA_UTIL_Constants.ACCOUNT_LEGAL_NAME_ID);
        String selectedGroupId =  (String)options.get(LGA_UTIL_Constants.SELECTED_GROUP_ID);
        if(LGA_UTIL_Constants.SELECTED_BILLING_OPTION_SINGLE_INVOICE_ALL.equals(selectedBillingOption)){
            attachInvoice = attachSingleInvoiceToBilling(selectedAccountId,selectedGroupId);
            
        }else if(LGA_UTIL_Constants.SELECTED_BILLING_OPTION_PER_EMP_CLASS.equals(selectedBillingOption)){
            attachInvoice = attachInvPerEmpClass(selectedAccountId,selectedGroupId,isBillingPatternChanged);  
            
        }        
        return attachInvoice;
        
    }
    
    /*******************************************************************************************
@method Name  : attachSingleInvoiceToBilling
@description : PRDCRM-49070 : This method automates creation of Billing Arrangement record, association to of BA to GPDs for Single invoice| Accenture Panthers Team
@param : String selectedAccountId
@return : Boolean
********************************************************************************************/
    private Boolean attachSingleInvoiceToBilling(String selectedAccountId, String selectedGroupId){   
       
        Boolean attachedSuccessfully = false;     
        Invoices_Local__c invoiceRec = null;
        Billing_Arrangement_Local__c singleBillingArr = null;
        try{ 
            
            Integer activeGPDCount = [SELECT count() from Group_Plan_Design__c WHERE Group__c = :selectedGroupId AND Is_Active_Indicator__c = true  WITH SECURITY_ENFORCED LIMIT 50000];
            List<Group_Plan_Design__c> notAttachedGPDList = [SELECT ID,Billing_Arrangement_Record_ID__c,Is_Active_Indicator__c from Group_Plan_Design__c WHERE Group__c = :selectedGroupId AND Is_Active_Indicator__c = true AND Billing_Arrangement_Record_ID__c = null  WITH SECURITY_ENFORCED LIMIT 50000];
            
            if(notAttachedGPDList != null && notAttachedGPDList.size() > 0 && activeGPDCount == notAttachedGPDList.size()) {
                if(Schema.sObjectType.Invoices_Local__c.isAccessible() && Schema.sObjectType.Invoices_Local__c.isCreateable()){
                    invoiceRec = new Invoices_Local__c(Account_Legal_Name__c = selectedAccountId);
                    database.insert (invoiceRec);
                }
                
                
                
                if(Schema.sObjectType.Billing_Arrangement_Local__c.isAccessible() && Schema.sObjectType.Billing_Arrangement_Local__c.isCreateable()){
                    singleBillingArr = new Billing_Arrangement_Local__c(Invoice_Record_ID__c = invoiceRec.Id);
                    database.insert (singleBillingArr);
                }
                
                 
                
                if(Schema.sObjectType.Group_Plan_Design__c.isAccessible() && Schema.sObjectType.Group_Plan_Design__c.isUpdateable()){
                    for(Group_Plan_Design__c gpd: notAttachedGPDList){
                        gpd.Billing_Arrangement_Record_ID__c = singleBillingArr.ID;
                    }
                    
                    database.update (notAttachedGPDList);
                    
                }
                
                attachedSuccessfully = true; 
            } else if(notAttachedGPDList != null && notAttachedGPDList.size() > 0 && activeGPDCount > notAttachedGPDList.size()){
                
                
                if(Schema.sObjectType.Group_Plan_Design__c.isAccessible() && Schema.sObjectType.Group_Plan_Design__c.isUpdateable()){
                    List<Group_Plan_Design__c> attachedGPDList = [SELECT ID,Billing_Arrangement_Record_ID__c,Is_Active_Indicator__c from Group_Plan_Design__c WHERE Group__c = :selectedGroupId AND Is_Active_Indicator__c = true AND Billing_Arrangement_Record_ID__c != null  WITH SECURITY_ENFORCED LIMIT 50000 ];
                    Id attachedBillingId = attachedGPDList != null && attachedGPDList.size() > 0 ? attachedGPDList.get(0).Billing_Arrangement_Record_ID__c : null;
                    for(Group_Plan_Design__c gpd: notAttachedGPDList){
                        gpd.Billing_Arrangement_Record_ID__c =  attachedBillingId; 
                    }
                    Database.update (notAttachedGPDList);
                   
                }
                attachedSuccessfully = true; 
            }else{
                attachedSuccessfully = true; 
            }
             System.debug('EXIT -> attachSingleInvoiceToBilling  ');
        }catch(Exception ex){
            System.debug('Exception in attachSingleInvoiceToBilling : ' + ex);
            attachedSuccessfully = false;
        }
        
        return attachedSuccessfully;
    }
    
    /*******************************************************************************************
@method Name  : deleteInvoicesForSelectedAccount
@description : PRDCRM2-1090 : This method deletes all invoices for selected Account if billing pattern selection is changed | Accenture Panthers Team
@param : String selectedAccountId
@return : Boolean
********************************************************************************************/
    
    private Boolean deleteInvoicesForSelectedAccount(String selectedAccountId){
        Boolean isInvoiceDeleted = false;
        try{        
            if(!String.isEmpty(selectedAccountId)){
                List<Invoices_Local__c> invoiceList = [SELECT ID FROM Invoices_Local__c 
                                                       WHERE Account_Legal_Name__c = :selectedAccountId
                                                       WITH SECURITY_ENFORCED LIMIT 50000 ];
                System.debug('invoiceList to be deleted : ' + invoiceList);
                database.delete (invoiceList);    
                isInvoiceDeleted = true;
                //System.debug('isInvoiceDeleted : ' + isInvoiceDeleted);
            }
        }catch(Exception ex){
            isInvoiceDeleted = false;
        }
        return isInvoiceDeleted;
    }
    
    
    
    /*******************************************************************************************
@method Name  : attachInvPerEmpClass
@description : PRDCRM2-1090 : This method automates creation of Billing Arrangement record, association to of BA to GPDs for per Employee class| Accenture Panthers Team
@param : String selectedAccountId, String selectedGroupId, Boolean isBillingPatternChanged
@return : Boolean
********************************************************************************************/
    private Boolean attachInvPerEmpClass(String selectedAccountId, String selectedGroupId, Boolean isBillingPatternChanged){   
        Boolean attachedSuccessfully = false;     
     //   System.debug('ENTRY -> attachInvPerEmpClass ');
        try{
            List<Group_Plan_Design__c> activeGPDList = [SELECT ID,Is_Active_Indicator__c,Employee_Class_Record_ID__c,Billing_Arrangement_Record_ID__c from Group_Plan_Design__c 
                                                        WHERE Group__c = :selectedGroupId 
                                                        AND Is_Active_Indicator__c = true 
                                                        AND Employee_Class_Record_ID__c != null
                                                        WITH SECURITY_ENFORCED LIMIT 50000 ];
            Map<Id,List<Group_Plan_Design__c>> activeGPDMap = new Map<Id,List<Group_Plan_Design__c>>();            
            for(Group_Plan_Design__c activeGpd : activeGPDList){
                if(activeGPDMap.containsKey(activeGpd.Employee_Class_Record_ID__c)){
                    activeGPDMap.get(activeGpd.Employee_Class_Record_ID__c).add(activeGpd);
                }else{
                    List<Group_Plan_Design__c> gpdList = new List<Group_Plan_Design__c>();
                    gpdList.add(activeGpd);
                    activeGPDMap.put(activeGpd.Employee_Class_Record_ID__c, gpdList);
                }                
            } 
            if(isBillingPatternChanged) {                
                attachedSuccessfully = createInvoiceBAStampGPD(selectedAccountId,activeGPDMap);              
            } else{         
                Map<Id,List<Group_Plan_Design__c>> activeGPDNoBAMap = new Map<Id,List<Group_Plan_Design__c>>();    
                List<Group_Plan_Design__c> noBAAttachedActiveGPDList = new List<Group_Plan_Design__c>();
                for(Id empClassIdKey:activeGPDMap.keySet()){                    
                    List<Group_Plan_Design__c> activeGpdPerEmpClassList = activeGPDMap.get(empClassIdKey);  
                    Id billingArrangementId = null;
                    for(Group_Plan_Design__c gpd: activeGpdPerEmpClassList){
                        if(gpd.Billing_Arrangement_Record_ID__c != null){
                            billingArrangementId = gpd.Billing_Arrangement_Record_ID__c;
                            break;
                        }
                    }
                    
                    Integer gpdNoBACount = 0;
                    for(Group_Plan_Design__c gpd: activeGpdPerEmpClassList){
                        if(gpd.Billing_Arrangement_Record_ID__c == null){
                            gpdNoBACount++;
                            gpd.Billing_Arrangement_Record_ID__c = billingArrangementId;
                            noBAAttachedActiveGPDList.add(gpd);
                        }   
                    }
                    
                    if(gpdNoBACount == activeGpdPerEmpClassList.size()){
                        activeGPDNoBAMap.put(empClassIdKey,activeGpdPerEmpClassList);
                    }
                }
              
                if(activeGPDNoBAMap.size()>0){
                    attachedSuccessfully = createInvoiceBAStampGPD(selectedAccountId,activeGPDNoBAMap);
                }
                if(noBAAttachedActiveGPDList.size() > 0){
                    database.update (noBAAttachedActiveGPDList);   
                    attachedSuccessfully = true; 
                }
            }
        }catch(Exception ex){
            System.debug('Exception in attachSingleInvoiceToBilling : ' + ex);
            attachedSuccessfully = false;
        }
        
        return attachedSuccessfully;
    }
    
    
    private boolean createInvoiceBAStampGPD(String selectedAccountId, Map<Id,List<Group_Plan_Design__c>> activeGPDMap){
        Boolean invCreated = false;  
        Invoices_Local__c invoiceRec = null;
        Billing_Arrangement_Local__c singleBillingArr = null;
        for(Id empClassIdKey:activeGPDMap.keySet()){            
            List<Group_Plan_Design__c> activeGpdList = activeGPDMap.get(empClassIdKey);            
            if(Schema.sObjectType.Invoices_Local__c.isAccessible() && Schema.sObjectType.Invoices_Local__c.isCreateable()){
                invoiceRec = new Invoices_Local__c(Account_Legal_Name__c = selectedAccountId);
                database.insert (invoiceRec);
            }            
            if(Schema.sObjectType.Billing_Arrangement_Local__c.isAccessible() && Schema.sObjectType.Billing_Arrangement_Local__c.isCreateable()){
                singleBillingArr = new Billing_Arrangement_Local__c(Invoice_Record_ID__c = invoiceRec.Id);
                database.insert (singleBillingArr);
            }            
            if(Schema.sObjectType.Group_Plan_Design__c.isAccessible() && Schema.sObjectType.Group_Plan_Design__c.isUpdateable()){
                for(Group_Plan_Design__c gpd: activeGpdList){
                    gpd.Billing_Arrangement_Record_ID__c = singleBillingArr.ID;
                }                
                database.update (activeGpdList);
            }    
        }
            invCreated = true;
            return invCreated;
        
    }
    
}