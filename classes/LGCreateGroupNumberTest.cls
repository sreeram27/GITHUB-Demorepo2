/*
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Name              LGCreateGroupNumberTest
* Author            Deloitte offshore (Gladiators)
* ModifiedBy		 Deloitte offshore (Gladiators)
* Version			 v1.0
* CreatedDate       29/03/2018
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description	     
* This is a test class for CreateGroupNumber and it tests negative and positive scenarios with bulk data.
* Used in vlocity omniscript to Generate Group Number for Group record.
* -----------------------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* ----------------------------------------------------------------------------------------------------------------------------------------------------------------
* 1 - createData() 
* 			> TestSetup Method to create the required Test Data
* 
* 2 - createGrpNumberGAIN() and createGrpNumberGAINneg
* 			> Checks if the size of Groupnumber data returned is correct and verifies the result
* 
* 3 - createGroupNumberCT() and createGroupNumberCTneg
* 			> Checks if the size of Groupnumber data returned is correct and verifies the result
* 
* 4 - createGroupNumberME() and createGroupNumberMEneg
* 			> Checks if the size of Groupnumber data returned is correct and verifies the result
* 
* 5 - createGroupNumberNH() and createGroupNumberNHneg
* 			> Checks if the size of Groupnumber data returned is correct and verifies the result
*  
* Additional information
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Changes
* Version					v1.1
* Date						22 August2019						
* Explanation				Updated the class as part of JIRA ID PRDCRM- 41010
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

@isTest
private class LGCreateGroupNumberTest{
    
    private static final String GETGROUPNUMBER = staticVariableClass.CreateGrpGETGROUPNUMBER;
    private static final String UPDATENEXTNUMBERUTILITY =  staticVariableClass.CreateGrpUPDATENEXTNUMBERUTILITY;
    private static final String REQUESTGROUPNUMBERSTEP = staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP;
    private static final String ACCTID = staticVariableClass.CreateGrpACCTID;
    
    /*Below method inserts sample data*/
    @testsetup
    static void createData(){
        
        List<Account> acc = new List<Account>(TestDataFactory.createAccountSICList(1, staticVariableClass.AccountName, 
                                                                                   staticVariableClass.testAccBillingStreet, staticVariableClass.testAccBillingCity, 
                                                                                   staticVariableClass.testAccBillingState, staticVariableClass.testAccBillingPostalCode, 
                                                                                   staticVariableClass.testAccBillingCountry, staticVariableClass.AK));
        
        acc[0].Situs_State__c =  staticVariableClass.California;
        acc[0].RecordTypeId = Schema.getGlobalDescribe().get(staticVariableClass.Account).getDescribe().getRecordTypeInfosByName().get(staticVariableClass.LGProspect).getRecordTypeId();
        acc[0].Physical_County__c = staticVariableClass.California;
        acc[0].ShippingStreet = '';
        acc[0].ShippingState  = '';
        acc[0].ShippingPostalCode  = '';
        acc[0].ShippingCountry  = '';
        acc[0].ShippingCity  = '';
        acc[0].Mailing_Address_Same_as_Physical_Address__c = true;
        System.assertEquals(1, acc.size(),'The list size is one');
        insert acc;
        
        Group__c grp = TestDataFactory.createGroup(Acc[0].id,false);
        insert grp;
        
        Next_Number_Utility__c nextNumCA;
        Next_Number_Utility__c nextNumGA;
        Next_Number_Utility__c nextNumME;
        Next_Number_Utility__c nextNumCT;
        Next_Number_Utility__c nextNumNH;
        
        nextNumCA =TestDataFactory.createnextnum(1,staticVariableClass.California,100,500,'');
        
        nextNumGA =TestDataFactory.createnextnum(1,staticVariableClass.Georgia,999,999,'GB');
        nextNumME =TestDataFactory.createnextnum(1,staticVariableClass.Maine,2049,9999,'');
        nextNumCT =TestDataFactory.createnextnum(1,staticVariableClass.Connecticut,2049,9999,'');
        nextNumNH =TestDataFactory.createnextnum(1,staticVariableClass.CreateGroupNumberNH,2049,9999,'');
        
        insert new List<Next_Number_Utility__c>{nextNumCA,nextNumGA,nextNumME,nextNumCT,nextNumNH};
            
            }
    
    /*Below method is to invoke the CreateGroupNumber with the data inserted*/
    @isTest 
    public static void createGroupNumberGAIN(){
        String actName=staticVariableClass.AccountName+' '+ staticVariableClass.OpportunityStageName;
        Account acc = [select ID,Situs_State__c,RecordTypeId from Account where Name =:actName];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put(ACCTID, acc.ID);
        inputMap.put(REQUESTGROUPNUMBERSTEP, new Map<String, Object>());
        
        CreateGroupNumber cgn = new CreateGroupNumber();
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        
        acc.Situs_State__c = staticVariableClass.Indiana;
        update acc;
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        
        acc.Situs_State__c = staticVariableClass.Georgia;
        update acc;
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(2, inputMap.size(),staticVariableClass.assertEquals);
        
    }
    @isTest 
    public static void createGrpNumberGAINneg(){
        Map<String,Object> inputMapnegative = new Map<String,Object>();
        System.assertNotEquals(2,inputMapnegative.size(),staticVariableClass.assertNotEquals);
    }
    @isTest 
    public static void createGroupNumberCT(){
        String actName=staticVariableClass.AccountName+' '+ staticVariableClass.OpportunityStageName;
        
        Account acc = [select ID,Situs_State__c,RecordTypeId from Account where Name =:actName];
        
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put(ACCTID, acc.ID);
        inputMap.put(REQUESTGROUPNUMBERSTEP, new Map<String, Object>());
        
        CreateGroupNumber cgn = new CreateGroupNumber();
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        
        acc.Situs_State__c = staticVariableClass.Connecticut;
        update acc;
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(2, inputMap.size(),staticVariableClass.assertEquals);
    }
    @isTest 
    public static void createGroupNumberCTneg(){
        
        
        Map<String,Object> inputMapnegative = new Map<String,Object>();
        System.assertNotEquals(2,inputMapnegative.size(),staticVariableClass.assertNotEquals);}
    
    @isTest 
    public static void createGroupNumberME(){
        String actName=staticVariableClass.AccountName+' '+ staticVariableClass.OpportunityStageName;
        Account acc = [select ID,Situs_State__c,RecordTypeId from Account where Name = :actName];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put(ACCTID, acc.ID);
        inputMap.put(REQUESTGROUPNUMBERSTEP, new Map<String, Object>());
        
        CreateGroupNumber cgn = new CreateGroupNumber();
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        
        acc.Situs_State__c = staticVariableClass.Maine;
        update acc;
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        system.assertEquals(2, inputMap.size(),staticVariableClass.assertEquals);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
    }
    @isTest 
    public static void createGroupNumberMEneg(){
        
        Map<String,Object> inputMapnegative = new Map<String,Object>();
        System.assertNotEquals(2,inputMapnegative.size(),staticVariableClass.assertNotEquals);}
    @isTest 
    public static void createGroupNumberNH(){
        String actName=staticVariableClass.AccountName+' '+ staticVariableClass.OpportunityStageName;
        Account acc = [select ID,Situs_State__c,RecordTypeId from Account where Name =:actName];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put(ACCTID, acc.ID);
        inputMap.put(REQUESTGROUPNUMBERSTEP, new Map<String, Object>());
        
        CreateGroupNumber cgn = new CreateGroupNumber();
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        
        acc.Situs_State__c = staticVariableClass.CreateGroupNumberNH;
        update acc;
        
        cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null);
        cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null);
        System.assertEquals(2, inputMap.size(),staticVariableClass.assertEquals);
        
        System.assertEquals(cgn.invokeMethod(GETGROUPNUMBER, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
        System.assertEquals(cgn.invokeMethod(UPDATENEXTNUMBERUTILITY, inputMap, new Map<String,Object>(), null),true,staticVariableClass.assertEquals);
    }
    @isTest 
    public static void createGroupNumberNHneg(){
        
        Map<String,Object> inputMapnegative = new Map<String,Object>();
        System.assertNotEquals(2,inputMapnegative.size(),staticVariableClass.assertNotEquals);}
}