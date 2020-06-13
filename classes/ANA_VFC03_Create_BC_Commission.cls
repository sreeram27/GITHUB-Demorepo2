/**
@Author : Accenture Offshore Dev team
@name : ANA_VFC03_Create_BC_Commission
@CreateDate :08-08-2017
@Description : This class is for invokation of standardcontroller from VF page.
*/
public with sharing class ANA_VFC03_Create_BC_Commission
{
    private static final String ID_PARAM = 'id';
    private static final String START_PARAM='001';
    public String accountId{get;set;}
    public Brokerage_and_Consultant__c brokerage;
    /*This constructor invokes the standard controller.*/
    public ANA_VFC03_Create_BC_Commission(ApexPages.StandardSetController controller){
        string inputId = ApexPages.currentPage().getParameters().get(ID_PARAM);
        if(inputId != null && inputId.startsWith(START_PARAM)){            
            accountId = ApexPages.currentPage().getParameters().get(ID_PARAM);
        }
    }
}