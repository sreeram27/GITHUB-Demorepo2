/**
@Author : Accenture Offshore Dev team
@name : AP19_RevisionSMEApproval
@Description :This class creates 'SME Revision Approval' records based on 'Manually-ENgaged' departments.
*/
global without sharing class AP19_RevisionSMEApproval implements vlocity_ins.VlocityOpenInterface2  {
     
    private static Map<String,Set<Object>> STAutoDepartmentFinal = new Map<String,Set<Object>>();
    private static final string CLASS_NAME=UtilConstants.CLASS_NAME;
    private static final String TEST_CLASS =UtilConstants.TEST_CLASS;
    private static String RevisionText ='REVISION ';
    
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global static Boolean invokeMethod(String methodName,Map<String,Object> inputMap,
                                        Map<String,Object> outMap,Map<String,Object> optns)
    {                              
                                     
            String  otherDptVal = '';               
            if(UtilConstants.SAVE_SME_DEPARTMENT.equalsIgnoreCase(methodName))
            {           
                 Map<String,String> deptJSONMap = new Map<String,String>{
                                                 UtilConstants.ST_AUTO_DEPARTMENT => UtilConstants.SI_AUTO_DEPARTMENT
                                                 ,UtilConstants.ST_MANUAL_DEPARTMENT => UtilConstants.SI_MANUAL_DEPARTMENT    
            };                        
                          
              Set<Object> finalizedDepts = new Set<Object>();                                                         
                System.debug('inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT)'+inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT));    
                
                
                
                if(inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT) != null)
                {
                 
                     Set<Object> manualDepts = new Set<Object>{inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT)}; 
                     
                     Map<String,Object> engageManualDeptMap = new Map<String,Object>();    
                        
                                
                          for(Object tempObj : manualDepts)               
                            engageManualDeptMap = (Map<String,Object>) tempObj;                     
                         
                                                                         
                         if(engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT) != null)
                         {  
                        
                             List<Object> engageManualDeptMap2 = (List<Object>) engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT);
                             for(Object tempEngage : engageManualDeptMap2)
                             {
                                 Map<String,Object> engageDeptMap = (Map<String,Object>) tempEngage; 
                                 
                                 if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) != null) {
                                    if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) == UtilConstants.OTHER)
                                     {                                        
                                        otherDptVal = string.valueof(engageDeptMap.get(UtilConstants.JSON_OTHER_DEPT));
                                     }                                  
                                     finalizedDepts.add(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD));   
                                 }                            
                                 
                             } 
                                                           
                         }
                        
                    System.debug('finalizedDepts'+finalizedDepts);      
                    

                     if(finalizedDepts != null)
                     {                     
                         createSMEApprovals(inputMap,finalizedDepts,outMap,OtherDptVal);                            
                     }   
                
                     
                       
                 }                                  
            }    
            else if(UtilConstants.CREATE_SME_DEPARTMENT.equalsIgnoreCase(methodName))
            {            
                createSMEApprovalOutmap(inputMap, outMap, optns);    
            }                        
            else if(UtilConstants.GENERATE_SME_DEPARTMENT.equalsIgnoreCase(methodName))
            {            
                GenerateSMEApprovalOutmap(inputMap, outMap, optns);    
            }
        return true; 
    }
  
     /*
    Method Name: createSMEApprovalOutmap
    Method Signature:public static Set<String> createSMEApprovalOutmap(Map<String,Object> outMap,String departmentout,Map<String,String> SIAutoDepartmenttMap,
                             Set<Object> SIAutoDepartment,Map<String,Set<Object>> STAutoDepartment,Set<String> actualDept)
    Method Return Type: Set<String>
    Method Description: This method is called from return value method to autoengageDepartmentList and send it back to OmniScript
    */
    public static void createSMEApprovalOutmap(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns)
    { 
        String contextId  =  String.valueOf(inputMap.get(UtilConstants.IMP_ID));
        System.debug('inputMap.get(UtilConstants.IMP_ID)'+inputMap.get(UtilConstants.IMP_ID));             
        Set<SME_Approvals__c> relatedSMEAprovals = new Set<SME_Approvals__c>([SELECT Id,SME_Department__c,If_Other_List_Department__c FROM SME_Approvals__c WHERE Implementation_Record_ID__c = :contextId 
            order by SME_Department__c  ]);  //  PRDCRM-24502 cmh  
        //---- extract 'Other' department ;  PRDCRM-24502 cmh ; PRDCRM-42480 , see the dept Benefit Booklets/Contracts in old IMPL
        String BeBoCo = 'Benefit Booklets/Contracts';
        Boolean isBeBoCO_existsInIMPL = false;
        Map<Id,SME_Approvals__c> relatedSMEAprovalsOtherMap = new Map<Id,SME_Approvals__c>(); 
        for(SME_Approvals__c o : relatedSMEAprovals){ 
            if(o.SME_Department__c == 'Other'){relatedSMEAprovalsOtherMap.put(o.id, o); }
            if(o.SME_Department__c == BeBoCo){isBeBoCO_existsInIMPL = true; }  // PRDCRM-42480
        }
        //--PRDCRM-42480
        Set<SMEDepartment__c> relatedSMEDepartment = new Set<SMEDepartment__c>([SELECT Department_Name__c,Omni_Script_Help_Text__c,Active__c FROM SMEDepartment__c order by Department_Name__c  ]);    
        Set<String> departmentSet = new Set<String>();
        // PRDCRM-42480                               
        Set<String> departmentSetNotActive = new Set<String>();    
        for (SMEDepartment__c o :relatedSMEDepartment) { if (!o.Active__c) departmentSetNotActive.add(o.Department_Name__c) ;  }   
                              
        Set<Object> SIManualDepartment=  new Set<Object>();
        Map<String,Set<Object>> STManualDepartment= new Map<String,Set<Object>>();        
        Integer cntOther = 0;
        
        
        for(SME_Approvals__c tempSMEApproval : relatedSMEAprovals)
        {
            if( relatedSMEAprovalsOtherMap.get(tempSMEApproval.Id) == NULL ) 
                departmentSet.add(tempSMEApproval.SME_Department__c);
        }
        
        
        //List<SMEDepartment__c> relatedDeptHelptext = [SELECT Department_Name__c,Omni_Script_Help_Text__c FROM SMEDepartment__c where  Department_Name__C IN :departmentSet];  
        Map<String,String> deptHelpTextMap = new Map<String,String>();
        for(SMEDepartment__c tempSMEDept : [SELECT Department_Name__c,Omni_Script_Help_Text__c FROM SMEDepartment__c where  Department_Name__C IN :departmentSet])
        {
            deptHelpTextMap.put(tempSMEDept.Department_Name__c,tempSMEDept.Omni_Script_Help_Text__c);
        }
        if(!relatedSMEAprovals.isEmpty())
        {            
            for(SME_Approvals__c tempSMEApproval : relatedSMEAprovals)
            {

                String helpText = ''; String deptNm = 'N/A';
                if(deptHelpTextMap.containsKey(tempSMEApproval.SME_Department__c)) {
                    helpText = String.valueOf(deptHelpTextMap.get(tempSMEApproval.SME_Department__c));
                    deptNm =   tempSMEApproval.SME_Department__c;}
                else if( relatedSMEAprovalsOtherMap.get(tempSMEApproval.Id) <> NULL ) {
                    helpText = tempSMEApproval.If_Other_List_Department__c ;
                    deptNm =   tempSMEApproval.SME_Department__c+'  ';}

                
                Map<String,String> SIManualDepartmentMap= new Map<String,String>();                                                                   
                try
                {
                    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,deptNm);
                    SIManualDepartmentMap.put(UtilConstants.HELP_TEXT,helpText);
                    SIManualDepartmentMap.put(UtilConstants.VLC_SELECTED,UtilConstants.TRUE_VAL );
                    SIManualDepartment.add(SIManualDepartmentMap);
                
                }                    
                catch(Exception excp)
                { 
                UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                       CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
                }                 
                          
             }                    
       }    
                  
        if(!relatedSMEDepartment.isEmpty()) 
        {
             for(SMEDepartment__c tempSMEApproval : relatedSMEDepartment)
             {
                 //--PRDCRM-42480 , if old beboco in IMPL, do not add Contracts dept in manully dept, cmh
                 Boolean okToAddDept = true;
                 okToAddDept = (isBeBoCO_existsInIMPL && tempSMEApproval.Department_Name__c == 'Contracts') ? false: true;
                 if(okToAddDept && !departmentSet.Contains(tempSMEApproval.Department_Name__c) && !departmentSetNotActive.Contains(tempSMEApproval.Department_Name__c))
                 {
                      Map<String,String> SIManualDepartmentMap= new Map<String,String>(); 
                      try
                      {
                        SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,tempSMEApproval.Department_Name__c);
                        SIManualDepartmentMap.put(UtilConstants.VLC_SELECTED,UtilConstants.FALSE_VAL);
                        SIManualDepartmentMap.put(UtilConstants.HELP_TEXT,tempSMEApproval.Omni_Script_Help_Text__c);
                        SIManualDepartment.add(SIManualDepartmentMap);                                  
                                                                                         
                      }  
                      catch(Exception excp)
                      { 
                          UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                                   CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
                      }                          
                  
                  }
              }   
        }
        
        STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment); 
        outMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment );        
                 
     }
     
    public static void GenerateSMEApprovalOutmap(Map<String,Object> inputMap, Map<String,
                                   Object> outMap,Map<String,Object> optns)
    {       
        
        String contextId  =  String.valueOf(inputMap.get(UtilConstants.CONTEXT_ID)); 
        System.debug('===COntextId=='+contextId);  
        List<SME_Approvals__c> existingSMEDept = [SELECT SME_Department__c,id,Status__c  FROM SME_Approvals__c WHERE Implementation_Record_ID__c = :contextId];  
        List<SME_Approvals__c> existingSMEDeptNew = new List<SME_Approvals__c>();
        List<Order> impCase = [Select Id,Are_there_changes_to_Rates__c,Impact_To_HPCC__c,Account_Group_Size__c from Order where Id = :contextId limit 1];
        System.debug('===ImpCase==='+impCase);
       //Added 4 more new departmrnt labels 
        Set<String> departmentSet = new Set<String>{UtilConstants.DENTAL,UtilConstants.Vision,UtilConstants.ENROLLBILL,UtilConstants.MEDICAL_BENEFITS,UtilConstants.ID_CARDS,UtilConstants.BENEFIT_DEPT,UtilConstants.PHARMACY,UtilConstants.INTER_PLAN,UtilConstants.SBC,UtilConstants.Issue_Control,
        UtilConstants.UNDERWRITING_MEDICAL,UtilConstants.UNDERWRITING_LIFE ,UtilConstants.UNDERWRITING_DENTAL ,UtilConstants.UNDERWRITING_VISION };
        Set<Object> SIManualDepartment=  new Set<Object>();
        Map<String,Set<Object>> STManualDepartment= new Map<String,Set<Object>>();           
        Set<string> existingDeptSet = new Set<String>();
        if(existingSMEDept.size()>0)
        {
        for(SME_Approvals__c tempDept : existingSMEDept)
            existingDeptSet.add(tempDept.SME_Department__c);
        }   
        if(existingSMEDept.size()>0){
            for(SME_Approvals__c tempDept : existingSMEDept){
                tempDept.Status__c ='Initiated';
                existingSMEDeptNew.add(tempDept);                         
            }                      
            update  existingSMEDeptNew;            
        }
        
        for(String tempDept : departmentSet)
        {
            Map<String,String> SIManualDepartmentMap= new Map<String,String>();                                                                   
            try
            {
                if((tempDept == UtilConstants.ENROLLBILL && impCase[0].Are_there_changes_to_Rates__c == UtilConstants.YES))                         
                {  
                    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,tempDept);                            
                    SIManualDepartmentMap.put(UtilConstants.VLC_SELECTED,UtilConstants.TRUE_VAL);
                    SIManualDepartment.add(SIManualDepartmentMap);
                    
                }
                else if((tempDept == UtilConstants.MEDICAL_BENEFITS && impCase[0].Impact_To_HPCC__c == UtilConstants.YES))
                {
                    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,tempDept);                            
                    SIManualDepartmentMap.put(UtilConstants.VLC_SELECTED,UtilConstants.TRUE_VAL);
                    SIManualDepartment.add(SIManualDepartmentMap);
                }   
                else        
                {
                    SIManualDepartmentMap.put(UtilConstants.JSON_NAME_FIELD,tempDept);                            
                    SIManualDepartment.add(SIManualDepartmentMap);
                }                 
             }                    
             catch(Exception excp)
             { 
                 UTIL_LoggingService.logHandledException(excp, UtilConstants.ORGID, UtilConstants.APPNAME, 
                                                           CLASS_NAME, UtilConstants.CANCEL,TEST_CLASS,LoggingLevel.ERROR); 
             }
             System.debug(SIManualDepartment);
             STManualDepartment.put(UtilConstants.SI_MANUAL_DEPARTMENT,SIManualDepartment); 
             outMap.put(UtilConstants.ST_MANUAL_DEPARTMENT, STManualDepartment );                                    
        } 
    } 

 /*
    Method Name: createSMEApprovals
    Method Signature: public static void createSMEApprovals(Map<String,Object> inputMap, Set<Object> deptList, Map<String,Object> outMap)
    Method Return Type: void
    Method Description: This method is called from 'invoke' method.
    */
   public static void createSMEApprovals(Map<String,Object> inputMap, 
        Set<Object> deptList, Map<String,Object> outMap,String OtherDptVal)    
    {          
        String contextId; 
        //ID recrdtypeID = '';
        //String groupcheck;      
        Impl_Revision__c currentRevision;       
        if(String.valueOf(inputMap.get(UtilConstants.IMP_ID)) !=null)
        {
            contextId                =  String.valueOf(inputMap.get(UtilConstants.IMP_ID));
            currentRevision = [Select Id,Status_Capture__c,Revision_Record_Status__c from Impl_Revision__c where Implementation_Case_Id__c = :contextId AND Revision_Record_Status__c =: UtilConstants.APPROVED Order By lastModifiedDate DESC limit 1];
        }
        else
        {
            contextId                =  String.valueOf(inputMap.get(UtilConstants.CONTEXT_ID));
        }        
        String implementationType       =  String.valueOf(inputMap.get(UtilConstants.IMPLEMENTATION_TYPE));  
        String productEffectiveDate     =  String.valueOf(inputMap.get(UtilConstants.PRODUCT_EFFECTIVE_DATE));
        //String otherTextFromOmniscript     =  String.valueOf(inputMap.get(UtilConstants.OTHERTEXT));
        
        Order currentOrder              =  [Select Id,SME_Service_Operations__c,Account.Group_Size__c,Revision_Text__c,Revision_Sequence_UpdatingTrigger__c,No_Rev_Email__c from Order where Id = :contextId limit 1];  
        Integer currentOrderValue;                          
        /*groupcheck = currentOrder.Account_Group_Size__c;
        if(groupcheck== '51 - 99') {
            recrdtypeID = System.Label.Account_Group_Size_ID;
        }*/
        Set<String> existingSMEAPDepartmentsCheck = new Set<String>();
        for(Object settemp: deptList){
            existingSMEAPDepartmentsCheck.add(String.valueof(settemp));
        }
    
        System.debug('deptList'+deptList);
        
        if (!deptList.isEmpty())
        {        
            //Fetching Quote Line Items related to present Order.
            System.debug('contextId'+contextId);
            List<SME_Approvals__c> relatedSMEAprovals = [SELECT Id,SME_Department__c FROM SME_Approvals__c WHERE Implementation_Record_ID__c = :contextId];
            System.debug('relatedSMEAprovals'+relatedSMEAprovals);
            Set<String> existingSMEAPDepartments = new Set<String>(); //We store all the existeng 'SME Approval' records departments related to the Implementation Case.   
            Map<String,String> SIAutoDepartmenttMap= new Map<String,String>();
            Set<Object> SIAutoDepartment =  new Set<Object>();
            Map<String,Set<Object>> STAutoDepartment  = new Map<String,Set<Object>>();   
            
            if(!relatedSMEAprovals.isEmpty())
            {            
                for(SME_Approvals__c tempSMEApproval : relatedSMEAprovals)
                {
                    existingSMEAPDepartments.add(tempSMEApproval.SME_Department__c); 
                        
                     if(inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT) != null)
                      {
                     Set<Object> manualDepts = new Set<Object>{inputMap.get(UtilConstants.ST_MANUAL_DEPARTMENT)};   
                     Map<String,Object> engageManualDeptMap = new Map<String,Object>();       
                      for(Object tempObj : manualDepts)               
                        engageManualDeptMap = (Map<String,Object>) tempObj;     
                        
                         if(engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT) != null)
                         {
                             List<Object> engageManualDeptMap2 = (List<Object>) engageManualDeptMap.get(UtilConstants.SI_MANUAL_DEPARTMENT);
                             for(Object tempEngage : engageManualDeptMap2)
                             {
                                 Map<String,Object> engageDeptMap = (Map<String,Object>) tempEngage;                                 
                                 if(engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) != null && 
                                    engageDeptMap.get(UtilConstants.JSON_NAME_FIELD) == tempSMEApproval.SME_Department__c)
                                    {
                                       if(String.valueOf(inputMap.get(UtilConstants.IMP_ID)) !=null)
                                           tempSMEApproval.Status__c = UtilConstants.STAT_PENDING ;                                        
                                 
                                    }                                                                    
                             }    
                                             
                         } 
                        
                     }                                                             
                }                
            } 
            
           //comented as part of defect 23590  
           if(inputmap.containsKey('DRId_Impl_Revision__c')){
               ID revisionId = String.valueof(inputmap.get('DRId_Impl_Revision__c'));
               Impl_Revision__c  r = [select name from Impl_Revision__c where id =:revisionId];
               RevisionText  = RevisionText + r.name + '-';
               currentOrder.put('Latest_Revision_ID__c',r.id);
           }            
          // if(!existingSMEAPDepartments.containsAll(existingSMEAPDepartmentsCheck)){
                if(currentOrder.Revision_Sequence_UpdatingTrigger__c != null){  
                    currentOrderValue = Integer.valueof(currentOrder.Revision_Sequence_UpdatingTrigger__c);
                    currentOrderValue = currentOrderValue + 1;
                    currentOrder.put('Revision_Sequence_UpdatingTrigger__c',currentOrderValue);
                    currentOrder.put('Revision_Text__c',RevisionText);
                    currentOrder.put('Revision_Record_Link_For_Template__c',true);                    
                    currentOrder.put('No_Rev_Email__c',false);
                 }
                 else{
                    currentOrderValue = 1;  
                    currentOrder.put('Revision_Sequence_UpdatingTrigger__c',currentOrderValue); 
                    currentOrder.put('Revision_Text__c',RevisionText);
                    currentOrder.put('No_Rev_Email__c',false);  
                    currentOrder.put('Revision_Record_Link_For_Template__c',true);                
                 }
                
          //  } 
                    
            System.debug('deptList'+deptList);  
                
            for (Object deptname : deptList)                              
            {
                 String checkBoxDepartment;
                 // PRDCRM-39088 cmh
                 if(String.valueOf(deptname) == UtilConstants.PRICING_CONFIGURATION_MANAGEMENT_PCM)
                 {
                     checkBoxDepartment = UtilConstants.API_PRICING_CONFIGURATION_MANAGEMENT_PCM;
                 } else if(String.valueOf(deptname).trim() == 'Other') {
                     checkBoxDepartment = 'SME_Other__c';
                 } else
                 {
                     checkBoxDepartment = String.valueOf(deptname).replace(' - ','_');
                     checkBoxDepartment = 'SME_' + String.valueOf(checkBoxDepartment).replaceAll('[/ / /]','_') + '__c';
                     checkBoxDepartment = checkBoxDepartment.replaceAll('[/( )/]',''); 
                 }                 
                 currentOrder.put(checkBoxDepartment, true); 
                 currentOrder.put(UtilConstants.IMPLEMENTATION_STATUS , UtilConstants.IC_STATUS_PENDINGSMEREVIEW );
                                    
            } 
              
            List<SME_Approvals__c> sme_approvalList = new List<SME_Approvals__c>();
            for (Object deptname : deptList)
            {   


                 SME_Approvals__c sme_apprnew = new  SME_Approvals__c();
                 if(String.valueOf(deptname) == UtilConstants.OTHER + '  '){
                    continue;  // auto-selected-other ; cmh 
                 } else if(String.valueOf(deptname) == UtilConstants.OTHER) {
                     if (OtherDptVal == NULL || String.isEmpty(OtherDptVal)){ continue;}
                     sme_apprnew.If_Other_List_Department__c = OtherDptVal; //cmh q0817  UtilConstants.OTHER;
                     sme_apprnew.SME_Department__c = String.valueOf(deptname);              
                     
                 }  
                             
                 if(!existingSMEAPDepartments.Contains(String.valueOf(deptname)) &&  String.valueOf(deptname) != UtilConstants.IHM)                 
                     if(String.valueOf(deptname) != null)                                                                                                                                                                                                                                                                                                               
                         sme_apprnew.SME_Department__c = String.valueOf(deptname);                                                                                                                
                 
                 if(String.valueOf(deptname) == UtilConstants.IHM && !existingSMEAPDepartments.Contains(UtilConstants.IHMM))                              
                     sme_apprnew.SME_Department__c =  UtilConstants.IHMM;                        
                 
                 if(!String.isBlank(productEffectiveDate))
                 {
                     if (implementationType.equals(UtilConstants.NEW_BUSINESS) || implementationType.equals(UtilConstants.RENEWAL))                                   
                        sme_apprnew.Production_Date__c = Date.valueOf(productEffectiveDate);                                        
                 }
                 sme_apprnew.Implementation_Record_ID__c = contextId;
                 sme_approvalList.add(sme_apprnew);                 
              }
              

            
             System.debug('sme_approvalList'+sme_approvalList);
              if (sme_approvalList.size() >0)
              {
                  Savepoint sp = Database.setSavepoint();
                 
                  try
                  {
                     
                      Database.insert(sme_approvalList,false);                      
                      Database.update(relatedSMEAprovals,false);
                      
                      update currentOrder; 

                  }
                  catch(Exception e)
                  {       
                                                    
                      outMap.put(UtilConstants.ERROR, e.getMessage());
                      Database.rollback(sp);                        
                  }
              } 
                
            
        }
        
        else
        {
            if(String.valueOf(inputMap.get(UtilConstants.IMP_ID)) !=null)
             currentOrder.put(UtilConstants.IMPLEMENTATION_STATUS , currentRevision.Status_Capture__c);
             update currentOrder;
        }
        
    } 

}