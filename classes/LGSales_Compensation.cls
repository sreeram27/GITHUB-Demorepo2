/* *******************************************************
Class Name   : LGSales_Compensation
Date Created : 18-MAY-2018
Created By   : Deloitte USI
Description  : Extension for VF page "LG_SalesCompStart"
********************************************************** */

public class LGSales_Compensation{
    
    public Sales_Compensation__c salesCompId {get; set;}
    public LGSales_Compensation(ApexPages.StandardController stdController) {
         salesCompId = (Sales_Compensation__c)stdController.getRecord();
    }

/* *********************************************************************************
Method Name   : save
Description  : Save button redirects to detail page of Sales COmpensation record
********************************************************************************* */
    public PageReference save(){
        try{
              upsert salesCompId ;
              
              PageReference pageRef = new ApexPages.StandardController(salesCompId).view();
              pageRef.setRedirect(true);
              return pageRef;

        }catch(Exception saveEx){
             //handle exception
           //  throw new DMLException('DML exception Occured',saveEx);
             return null;
        }

    }
}