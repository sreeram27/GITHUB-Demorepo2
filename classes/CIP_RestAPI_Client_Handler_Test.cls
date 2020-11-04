/*
@Author : Arun Siddappa
@name : CIP_RestAPI_Client_Handler 
@CreateDate :05-30-2017
@Description : This class is to test the CIP Rest API Client
*/

@isTest
public class CIP_RestAPI_Client_Handler_Test {

    public static testMethod void testCreateCIP()
    {    
        Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();
        insert cipInt;
        Test.startTest(); 
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = new CIP_RestAPI_Client_Handler.CIPFields();
        cipFlds.name='DUMMY';
        cipFlds.recType='DUMMY';
        cipFlds.topic='DUMMY';
        cipFlds.Status='DUMMY';
        cipFlds.ErrorCode='DUMMY';
        cipFlds.Message='DUMMY';
        cipFlds.CIPId='DUMMY';
        cipFlds.fileContent='DUMMY';
        cipFlds.fileName='DUMMY';
        cipFlds.ParentId='DUMMY';
        cipFlds.AccountName='DUMMY';
        cipFlds.AccountNumber='DUMMY';
        cipFlds.SIC='DUMMY';
        cipFlds.Total_Employees='DUMMY';
        cipFlds.Total_Eligibles='DUMMY';
        cipFlds.HQ_State='DUMMY';
        cipFlds.Original_Effective_Date='DUMMY';
        cipFlds.RecordType='DUMMY';
        cipFlds.AnthemEntity='DUMMY';
        cipFlds.Group_Size='DUMMY';
        cipFlds.Region='DUMMY';
        cipFlds.Branding='DUMMY';
        cipFlds.Duns_Number='DUMMY';
        cipFlds.Segment ='DUMMY';
        cipFlds.Website='DUMMY';
        cipFlds.BillingAddress='DUMMY';
        cipFlds.ShippingAddress='DUMMY';           
        cipFlds.GroupNumber='DUMMY';
        cipFlds.GroupNumberSFDCId='DUMMY';
        cipFlds.OpportunityId='DUMMY';     
        cipFlds.OpportunityEffectiveDate='DUMMY';                 
        cipFlds.OpportunityName='DUMMY';  
        cipFlds.OpportunityReceivedDt='DUMMY';  
        cipFlds.OpportunityType='DUMMY';  
        cipFlds.BillingStreet='DUMMY';
        cipFlds.BillingCity='DUMMY';
        cipFlds.BillingState='DUMMY';
        cipFlds.BillingPostalCode='DUMMY';    
        cipFlds.BillingCountry='DUMMY';    
        cipFlds.ShippingStreet='DUMMY';
        cipFlds.ShippingCity='DUMMY';
        cipFlds.ShippingState='DUMMY';
        cipFlds.ShippingPostalCode='DUMMY';    
        cipFlds.ShippingCountry='DUMMY';    
        cipFlds.DivisionName='DUMMY';
        cipFlds.UseDivisionNameAsGroupName=true;
        cipFlds.ClaimSystem='DUMMY';    
        cipFlds.MemberCount='DUMMY';   
        CIP_RestAPI_Client_Handler.CIPFields RetcipFlds = CIP_RestAPI_Client_Handler.CreateCIP('http://OLDURL', 'ACCESSTOKEN', cipFlds); 
        System.assertEquals(RetcipFlds.GroupNumber,'GRP_NUM_SUCCESS');
        AttachedFile afile = new AttachedFile();
        afile.fileName ='test';
        afile.fileContent = 'test file content';
        
        Test.stopTest();   
    }
    
    
}