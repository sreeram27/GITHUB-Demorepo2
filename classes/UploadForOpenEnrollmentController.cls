public with sharing class UploadForOpenEnrollmentController {


    Id parentId;
    public String fileName {get;set;}                       
    public String fileBodyContents{get;set;}    
    static String SAVE_FAILURE = 'There was an error saving the records: ';
    public Boolean showErrorTable 
    {
        get
        {
            return showErrorTable == null ? false : showErrorTable;
        }
        set;
    }
    

    public UploadForOpenEnrollmentController(ApexPages.StandardController stdCont) 
    {
        parentId = stdCont.getId();
    }

    public List<OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper> enrollmentWrappers 
    {
        get;
        set;

    }

    public List<OpenEnrollmentCSVParserServices.ColumnNameWrapper> columnNameWrappers {get;set;}

    public void fileRefreshPage(){
            
        if(!fileName.contains('.csv')){
            ApexPages.addMessage( 
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'You can only upload csv files.')
                );
        }
        else
        {
            if(fileBodyContents != null)
            {
                showErrorTable = false;
                OpenEnrollmentCSVParserServices.readListOpenEnrollmentCSV(fileBodyContents, parentId, this);
            }
        }
    }

    @TestVisible
    private List<SFDC_Volunteer_Event__c> openEnrollmentList
    {
        get
        {
            openEnrollmentList = new List<SFDC_Volunteer_Event__c>();
            for(OpenEnrollmentCSVParserServices.OpenEnrollmentWrapper enrollmentWrapper: enrollmentWrappers)
            {
                openEnrollmentList.add(enrollmentWrapper.openEnrollment);
            }
            return openEnrollmentList;
        }  
        set; 
    }

    public PageReference insertRecords()
    {

System.debug(openEnrollmentList);
        Database.SaveResult[] enrollmentDMLResults =  Database.insert(openEnrollmentList,false);

        for(Integer i = 0; i < enrollmentDMLResults.size(); i++)
        {
            Database.SaveResult result = enrollmentDMLResults[i];
            if(!result.isSuccess())
            {   
                showErrorTable = true;
                for(Database.Error error : result.getErrors())
                {
                    String openEnrollmentErrors = error.getStatusCode() +': \n'+ error.getMessage() + '\n';
                    enrollmentWrappers[i].errorMessage = String.isBlank(enrollmentWrappers[i].errorMessage)? 
                                               openEnrollmentErrors : enrollmentWrappers[i].errorMessage + openEnrollmentErrors;
                }
            }
        }
        
        return showErrorTable? null : new PageReference('/'+parentId);

    }

}