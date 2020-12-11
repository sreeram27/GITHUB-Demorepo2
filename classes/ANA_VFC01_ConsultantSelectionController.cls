/**
@Author : Accenture Offshore Dev team
@name : ANA_VFC01_ConsultantSelectionController
@CreateDate :05-05-2017
@Description : Ability for users to Create a new Brokerage Consultant commission Record using custom create Button. Currently this  is          happening thru a custom button which limits the number of consultants returned that are associated to the account by                Consultant End Date. Consultants are only displayed on the page where Consultant End Date is greater than today or  where   the Consultant End Date is Blank.This class will be controller extention to ANA_VFP01_ConsultantSelection page. 
This has the logic to create consultant picklist and prepopulating values on VF and saving the Broker_Consultant_Commissions__c record.
@Version <1.0>
*/
public with sharing class ANA_VFC01_ConsultantSelectionController {
    /*Creating private static variables for Hard coding values*/ 
    private static final String CONS_EFF_DATE_PARAM =' (Cons Effective Date) ';    
    private static final String SEPARATOR = ' - ';
    private static final String SLASH_PARAM = '/';    
    private static final String ID_PARAM = 'id';
    private static final String SELECT_OPTION_PARAM ='Please select an option.';    
    private static final String CLASSNAME = ANA_VFC01_ConsultantSelectionController.class.getName();  
    public static final String CREATESELECTOPTIONS='createSelectOptions';
    public static final String SAVEBCC='saveBCC';
    public static final String CANCEL='Cancel';
    public static final String REDIRECTMETHOD='redirectToCreate';
    public static final string ORGID=UserInfo.getOrganizationId();
    public static final String APPNAME='National Sales';    
    public Broker_Consultant_Commissions__c bcc{get;set;}
    public boolean showList{get;set;}    
    public List<SelectOption> consultantOptions { get; private set; }
    public String selectedConsultant { get; set; }
    private String returnUrl;
    private String accountId;
    private Map<Id, Brokerage_and_Consultant__c> brokerAndConsultantsById;
    private static final String RELATEDCONSULTANT='Related Consultant';
    private static final String CREATE='Create';
    private static final String SAVE='Save';
    private List<Brokerage_and_Consultant__c> bacList;
    private static final string SELECTBC_QUERY ='SELECT Name,Consultant_Name__c,consultant__c,Brokerage__r.Name,ConsultantEffectiveDate__c,\n'+
                                                'ConsultantEndDate__c,Account__c, Account__r.Name FROM Brokerage_and_Consultant__c \n' + 
                                                'WHERE Account__c = :accountId AND (ConsultantEndDate__c > TODAY OR ConsultantEndDate__c = null)\n'+
                                                'ORDER BY ConsultantEndDate__c DESC limit 1000';
    /*return the related consultant string*/
    public String getRelatedConsultant()
    {
        return RELATEDCONSULTANT;
    }
    /*return the create string*/
    public String getCreate()
    {
        return CREATE;
    }
    /*return the save string*/
    public String getSave()
    {
        return SAVE;
    }
    /*return the cancel string*/
    public String getCancel()
    {
        return CANCEL;
    }
    
    
    /*Constructor : By using this method get page parameters Id's[Account & return url ] into class*/ 
    /**
*  This is a parameterised constrcutor . Initiates some variables and prepares the consultant piclist
to be shown on visualforce page.
*  @name ANA_VFC01_ConsultantSelectionController
*  @param ApexPages.StandardSetController
*  @return NA
*  @throws exception-QueryException
*/
  public ANA_VFC01_ConsultantSelectionController(ApexPages.StandardSetController controller){       
        if(ApexPages.currentPage().getParameters().get(ID_PARAM) != null){            
            accountId = ApexPages.currentPage().getParameters().get(ID_PARAM);
            //returnUrl = ApexPages.currentPage().getParameters().get(RETURN_URL_PARAM);
            consultantOptions=new List<SelectOption>();
            brokerAndConsultantsById = new Map<Id, Brokerage_and_Consultant__c>();
            consultantOptions = createSelectOptions();
            bcc= new Broker_Consultant_Commissions__c();
            showList=true;
        }
    }
    /**
* Construct the consultant picklist where the  ConsultantEndDate__c greater than TODAY or null.
*  @name :createSelectOptions
*  @param :NA
*  @return: List<SelectOption>
* 
*/
    public List<SelectOption> createSelectOptions(){        
        List<SelectOption> options = new List<SelectOption>();        
        List<String> labelString;
        SelectOption option ;        
        try
        {
            ANA_UTIL04_AccessBCDataUtil.accountId = accountId; 
            bacList=ANA_UTIL04_AccessBCDataUtil.queryBCrecords(SELECTBC_QUERY);           
            for(Brokerage_and_Consultant__c bac :bacList)
            {               
                brokerAndConsultantsById.put(bac.id,bac);
                String effDate = CONS_EFF_DATE_PARAM ;
                if(bac.ConsultantEffectiveDate__c!=null)
                {
                    effDate+=String.valueOf(bac.ConsultantEffectiveDate__c);  
                }                
                labelString = new List<String>();//{bac.Consultant__r.Name,bac.Brokerage__r.Name,effDate};
                if(bac.Consultant_Name__c!=null)
                {
                    labelString.add(bac.Consultant_Name__c);
                }
                if(bac.Brokerage__c!=null&&bac.Brokerage__r.Name!=null)
                {
                    labelString.add(bac.Brokerage__r.Name);
                }
                labelString.add(effDate);
                String label = String.join(labelString, SEPARATOR);
                option = new SelectOption(bac.Id, label);
                options.add(option);                  
            }            
        }
        catch(QueryException Excp)
        {
            UTIL_LoggingService.logHandledException(Excp, ORGID, APPNAME, CLASSNAME, REDIRECTMETHOD,null,LoggingLevel.ERROR);
        }
        return options; 
        
    } 
    
    /**
* By using this method redirecting page to Brokerage and Consultant Commission record page with the default values populate of Account ,        Brokerage and Consultant .
*  @name :redirectToCreate
*  @param :NA
*  @return: void
* 
*/  
    public void redirectToCreate(){
        try{            
            if(brokerAndConsultantsById.get(selectedConsultant)!=null)
            {
                if(brokerAndConsultantsById.get(selectedConsultant).Account__c!=null)
                {
                    bcc.Account__c=brokerAndConsultantsById.get(selectedConsultant).Account__c;
                }
                if(brokerAndConsultantsById.get(selectedConsultant).consultant__c!=null)
                {
                    bcc.Contact_Relationship__c=brokerAndConsultantsById.get(selectedConsultant).consultant__c;
                }               
            }
            if(selectedConsultant!=null)
            {
                bcc.BrokerageAndConsultant__c=selectedConsultant;
            }            
            showList=false;
        }
        catch(Exception excp)
        {
            UTIL_LoggingService.logHandledException(excp, ORGID, APPNAME, CLASSNAME, CANCEL,null,LoggingLevel.ERROR);
        }
        
    }
    /**
* Saves the Broker_Consultant_Commissions__c record
*  @name :saveBCC
*/
    public pagereference saveBCC()
    {
        pagereference pgeRef;
        if(bcc!=null)
        {
            try{
                database.insert(bcc);
                pgeRef =new Pagereference(SLASH_PARAM+bcc.id);
                pgeRef.setredirect(true);
                 
            }
            catch(DMLException excp){
                UTIL_LoggingService.logHandledException(excp, ORGID, APPNAME, CLASSNAME, SAVEBCC,null,LoggingLevel.ERROR);
                             
            }
            catch(Exception e)
            {
                ApexPages.addMessages(e);
                             
            }
        }
        return pgeRef; 
       
    }
    
    /**
* By using this method redirecting page to previous page
*  @name :cancel
*/
    public PageReference cancel(){   
        PageReference pageRef;     
        try{
            pageRef = new PageReference(SLASH_PARAM+accountId);
            pageRef.setRedirect(true);
                      
        }
        catch(Exception excp)
        {
            UTIL_LoggingService.logHandledException(excp, ORGID, APPNAME, CLASSNAME, CANCEL,null,LoggingLevel.ERROR);
            
        }
       return pageRef; 
    }    
}