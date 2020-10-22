/**
@Author : 
@name : ANA_VFC03_Create_BC_Commission_oppty
@CreateDate :08-08-2017
@Description : This class is for invokation of standardcontroller from VF page.
*/
public with sharing class ANA_VFC03_Create_BC_Commission_oppty
{
    private static final String ID_PARAM = 'id';
    private static final String START_PARAM='006';
    public String opportunityId{get;set;}
    public Brokerage_and_Consultant1__c brokerage;
    /*This constructor invokes the standard controller.*/
    public ANA_VFC03_Create_BC_Commission_oppty(ApexPages.StandardSetController controller){
        string inputId = ApexPages.currentPage().getParameters().get(ID_PARAM);
        if(inputId != null && inputId.startsWith(START_PARAM)){            
            opportunityId = ApexPages.currentPage().getParameters().get(ID_PARAM);
        }
    }
}