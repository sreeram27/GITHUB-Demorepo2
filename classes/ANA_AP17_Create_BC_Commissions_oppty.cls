/**
@Author : 
@name : ANA_AP17_Create_BC_Commissions_On_Opportunity 
@CreateDate :
@Description :Controller for Lookup Lightning Component
@History :
          1)05/16/2019 - Added method getBrokerageCommissionSplitTotal as part of PRDCRM-33470: Ravideep(Vikings)
*/
public with sharing class ANA_AP17_Create_BC_Commissions_oppty
{
    private static final String APPNAME='National Sales';
    private static final String CLASSNAME = ANA_AP17_Create_BC_Commissions_oppty.class.getName();
    private static final String REDIRECTMETHOD ='redirectToCreate';
    private static final String BROKERCONSULT ='BrokerConsult';
    private static final String SERACHBYNAME ='SearchByName';
    private static final String SEARCHBYID = 'SearchById';
    private static final String EMPTY = '';
    private static final String FUNDINGTYPE = 'FundingType';
    private static final String PAYMENTMETHOD = 'PaymentMethod';
    private static final String APPLIYONLY = 'appliyOnly';
    private static final String LOB = 'LineOfBusiness';
    private static final String PSYM = '\'%';
    private static final String PLSYM = '%\'';
    private static final String SLASH = '\'' ;
    private static final String QRYSELECT = 'SELECT ';
    private static final String QRYFROM = ' FROM ';
    private static final String QRYWHERE = ' WHERE ';
    private static final String QRYLIKE = ' LIKE ';
    private static final String QRYACCSEARCH = ' AND Opportunity__c = ';
    private static final String QRYLIMIT = ' LIMIT ';
    private static final String COMMA = ' ,';
    private static final String QRYEQUAL = ' = ';
    private static final string SELECTBC_QUERY ='SELECT Name,Consultant_Name__c,consultant__c,Brokerage__r.Name,ConsultantEffectiveDate__c,\n'+
                                                'ConsultantEndDate__c,Opportunity__c, Opportunity__r.Name FROM Brokerage_and_Consultant1__c \n' + 
                                                'WHERE Opportunity__C = :OpportunityId AND (ConsultantEndDate__c > TODAY OR ConsultantEndDate__c = null)\n'+
                                                'ORDER BY ConsultantEndDate__c DESC limit 1000';
    private static final String CONS_EFF_DATE_PARAM =' (Cons Effective Date) ';
    private static final String SAVEBCC='saveBCC';
    private static final String SEPARATOR = ' - ';
    private static final string ORGID=UserInfo.getOrganizationId();
    private static List<selectBCOption> options;
    /*
    * Construct the consultant picklist where the  ConsultantEndDate__c greater than TODAY or null.
    *  @name :createSelectOptions
    *  @param :NA
    *  @return: List<SelectOption>
    * 
    */
    @AuraEnabled
    public static String createSelectOptions(string oppId){        
        options = new List<selectBCOption>();        
        List<String> labelString;
        selectBCOption option;        
        List<Brokerage_and_Consultant1__c> bacList;
        Map<Id, Brokerage_and_Consultant1__c> brokerAndConsultantsById;
        try
        {
            ANA_UTIL04_AccessBCDataUtil_oppty.OpportunityId = Id.valueOf(oppId); 
            system.debug('ANA_UTIL04_AccessBCDataUtil_oppty.OpportunityId-->'+ANA_UTIL04_AccessBCDataUtil_oppty.OpportunityId);
            bacList=ANA_UTIL04_AccessBCDataUtil_oppty.queryBCrecords(SELECTBC_QUERY);
            system.debug('bacList--->'+bacList);
            brokerAndConsultantsById = new Map<Id, Brokerage_and_Consultant1__c>();           
            for(Brokerage_and_Consultant1__c bac :bacList)
            {               
                brokerAndConsultantsById.put(bac.id,bac);
                String effDate = CONS_EFF_DATE_PARAM;
                if(bac.ConsultantEffectiveDate__c!=null)
                {
                    effDate+=String.valueOf(bac.ConsultantEffectiveDate__c);  
                }                
                labelString = new List<String>();
                if(bac.Consultant_Name__c!=null)
                {
                    labelString.add(bac.Consultant_Name__c);
                }
                if(bac.Brokerage__c!=null&&bac.Brokerage__r.Name!=null)
                {
                    labelString.add(bac.Brokerage__r.Name);
                }
                labelString.add(effDate);
                system.debug('labelString--->'+labelString);
                String label = String.join(labelString, SEPARATOR);
                option = new selectBCOption(EMPTY,bac.Id, label);
                options.add(option);   
                system.debug('options--->'+options);
            }            
        }
        catch(Exception Excp)
        {
            UTIL_LoggingService.logHandledException(Excp, ORGID, APPNAME, CLASSNAME, REDIRECTMETHOD,null,LoggingLevel.ERROR);
        }
        return JSON.serialize(options);  
    }         
      /**
     * Returns JSON of list of ResultWrapper to Lex Components
     * @objectName - Name of SObject
     * @fld_API_Text - API name of field to display to user while searching
     * @fld_API_Val - API name of field to be returned by Lookup COmponent
     * @lim   - Total number of record to be returned
     * @fld_API_Search - API name of field to be searched
     * @searchText - text to be searched
     * */
    @AuraEnabled 
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText,string searchByType,string searchSpecific,string oppId){        
        String query;
        if(BROKERCONSULT.equalsIgnoreCase(searchSpecific))
        {
            string OpportunityId=SLASH + oppId + SLASH;
            if(SERACHBYNAME.equalsIgnoreCase(searchByType)){
                searchText=PSYM + String.escapeSingleQuotes(searchText.trim()) + PLSYM;                
                query = QRYSELECT+fld_API_Text+COMMA+fld_API_Val+
                            QRYFROM+objectName+
                                QRYWHERE+fld_API_Search+QRYLIKE+searchText+QRYACCSEARCH+ OpportunityId +
                            QRYLIMIT+lim;
            }
            else if(SEARCHBYID.equalsIgnoreCase(searchByType)){
                searchText=SLASH + String.escapeSingleQuotes(searchText.trim()) + SLASH;
                query = QRYSELECT+fld_API_Text+COMMA+fld_API_Val+
                            QRYFROM+objectName+
                                QRYWHERE+fld_API_Search+QRYEQUAL+searchText+QRYACCSEARCH+ OpportunityId +
                            QRYLIMIT+lim;
            }
        }
        else if(EMPTY.equalsIgnoreCase(searchSpecific)){          
            if(SERACHBYNAME.equalsIgnoreCase(searchByType)){
                searchText=PSYM + String.escapeSingleQuotes(searchText.trim()) + PLSYM;                
                query = QRYSELECT+fld_API_Text+COMMA+fld_API_Val+
                            QRYFROM+objectName+
                                QRYWHERE+fld_API_Search+QRYLIKE+searchText+ 
                            QRYLIMIT+lim;
            }
            else if(SEARCHBYID.equalsIgnoreCase(searchByType)){
                searchText=SLASH + String.escapeSingleQuotes(searchText.trim()) + SLASH;
                query = QRYSELECT+fld_API_Text+COMMA+fld_API_Val+
                            QRYFROM+objectName+
                                QRYWHERE+fld_API_Search+QRYEQUAL+searchText+ 
                            QRYLIMIT+lim;
            }
        }       
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();        
        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            lstRet.add(obj);
        } 
         return JSON.serialize(lstRet) ;
    } 
    
    /*PRDCRM-33470-This method gets total of brokerage commission split % field for all brokerage comission records associated with parent opportunity:Ravideep(Vikings)*/ 
    @AuraEnabled
    public static boolean getBrokerageCommissionSplitTotal(string oppId,decimal dccurrentBrokerageCommission) {
        boolean showWarning = true;
        List<Broker_Consultant_Commissions1__c> brokerageCommissionList = new List <Broker_Consultant_Commissions1__c>();
        Id opportunityid = Id.ValueOf(oppId);
        decimal dcTotalBrokerageCommission = dccurrentBrokerageCommission;
        system.debug('dccurrentBrokerageCommission-->' + dccurrentBrokerageCommission);
        system.debug('opportunityid-->' + opportunityid);
        if(!String.isEmpty(opportunityId)){
            brokerageCommissionList = [Select id,Brokerage_Commission_Split__c,Opportunity__c from Broker_Consultant_Commissions1__c where Opportunity__c =: opportunityId];
        }
        
        system.debug('brokerageCommissionList-->' + brokerageCommissionList);
        
        if(!brokerageCommissionList.isEmpty() && dcTotalBrokerageCommission != null ){
            for(Broker_Consultant_Commissions1__c bc : brokerageCommissionList){
            if(bc.Brokerage_Commission_Split__c != null){
                dcTotalBrokerageCommission = dcTotalBrokerageCommission + bc.Brokerage_Commission_Split__c;
                }
            }
        }
        
        system.debug('dcTotalBrokerageCommission-->' + dcTotalBrokerageCommission);
        if(dcTotalBrokerageCommission != null && dcTotalBrokerageCommission == 100){
            showWarning = false;
        }
        
        return showWarning;
    }
/*This method saves the Brokerage and Consultant Commission record.*/    
    @AuraEnabled
    public static string saveBRRecord(string oppId,string BrId,Broker_Consultant_Commissions1__c newBandConsuComm){
        try{
            newBandConsuComm.Opportunity__c = Id.ValueOf(oppId);
            newBandConsuComm.BrokerageAndConsultant__c = BrId;
            database.insert(newBandConsuComm);
            return newBandConsuComm.Id;
        }
        catch(Exception e){
            system.debug('SaveError:'+e.getMessage());
            UTIL_LoggingService.logHandledException(e, ORGID, APPNAME, CLASSNAME, SAVEBCC,null,LoggingLevel.ERROR);
            return e.getMessage();
        }
    }
    
    
     /*
    *  @Description : To get all Picklist values from object
    *  @name :getPickListValues
    *  @param :NA
    *  @return: List<SelectOption>
    */
    @AuraEnabled
    public static string getPickListValues(){
        options = new List<selectBCOption>();
        Schema.DescribeFieldResult fieldResult;
        List<Schema.PicklistEntry> ple;            
            fieldResult = Broker_Consultant_Commissions1__c.Funding_Type__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new selectBCOption(FUNDINGTYPE,f.getLabel(),f.getLabel()));
            }
            
            fieldResult = Broker_Consultant_Commissions1__c.Payment_Method__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new selectBCOption(PAYMENTMETHOD,f.getLabel(),f.getLabel()));
            }
            
            fieldResult = Broker_Consultant_Commissions1__c.Applies_to_only_a_portion_of_group__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new selectBCOption(APPLIYONLY,f.getLabel(),f.getLabel()));
            }
            
            fieldResult = Broker_Consultant_Commissions1__c.Line_of_Business__c.getDescribe();
            ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new selectBCOption(LOB,f.getLabel(),f.getLabel()));
            }
        return JSON.serialize(options);
    }    
 /*This Class is used to wrap the result*/   
    public with sharing class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String val{get;set;}
    }
  /*This class is used for wrap the picklist values*/  
    public with sharing class selectBCOption{
        public String type ;       
        public String value;
        public String label;
        /*This constructor method initializes the picklist values.*/
        public selectBCOption(string tp,string bcValue,string bcLabel){
            type  =  tp;
            value = bcValue;
            label = bcLabel;
        }       
    }
}