/*
@Author : Arun Siddappa
@name : CIP_Send_Document_REST_Service_Test
@CreateDate :06-22-2017
@Description : This class to test CIP_Send_Document_REST_Service
*/

@isTest
public class CIP_Send_Document_REST_Service_Test
{
	//Start | PRDCRM-47803 : Tech Debt story(Test setup method to create test data) | 25th Nov, 2019 | Accenture - Panthers
	/**
    @description : Test setup method for test data creation
    */
	@testSetup static void dataSetup() {
        // Creating account record
		Account accnt = CIP_Util_Test_Methods.CreateAccount();
        insert accnt;
        // Creating Opportunity record
        Opportunity opty = CIP_Util_Test_Methods.CreateOpportunity(accnt);
        insert opty;
        // Creating group record
        Group__c grpNbr =  CIP_Util_Test_Methods.CreateGroup(accnt.Id, 'ABC123');
        insert grpNbr; 
        // Creating Quote record
        Quote quote = CIP_Util_Test_Methods.CreateQuote(accnt, opty,grpNbr.Id);
        insert quote;
        // Creating document record
        CIP_Util_Test_Methods.createDocument(quote);    
    }
	
	
	// Test by not sending Group Number - REST Service will query against quote based on quote id to get the latest document 
	/**
    @description : Test method to to cover the CIPFromSales service where Group is null 
    */
	@isTest
    static void testServiceCallWhenGrpNull()
    {
        Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();      
        insert cipInt;
        
                    
        Test.startTest(); 
		Quote quote = [SELECT Id, name, GroupNumber__c, opportunityId FROM Quote LIMIT 1];
		System.assertEquals(quote.name,'Quote- TEST ACCOUNT', 'Quote name is not equal to Quote- TEST ACCOUNT');
        String jsonStr = getJsonStr(quote,true);
        jsonStr = EncodingUtil.urlEncode(jsonStr, 'UTF-8');   
        String retJSON = CIP_Send_Document_REST_Service.doPost(jsonStr);
        String retJsonStr = EncodingUtil.urlDecode(retJSON, 'UTF-8');
        retJsonStr = retJsonStr.replace('\\"', '"');                
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = CIP_RestAPI_Client_Handler.GetCIPObject(retJsonStr);        
        System.assertEquals(cipFlds.fileName,'ASF Document', 'File name is not equal to ASF Document');
        Test.stopTest();   
    } 
	// Test by sending Group Number - REST Service will query against quote based on group number to get the latest document     
	/**
    @description : Test method to to cover the CIPFromSales service where Group is not null 
    */
    @isTest
	static void testServiceCallWhenGrpNotNull()
    {
        Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();      
        insert cipInt;
        
        
        Test.startTest(); 
		Quote quote = [SELECT Id, name, GroupNumber__c, opportunityId FROM Quote LIMIT 1];
		System.assertEquals(quote.name,'Quote- TEST ACCOUNT', 'Quote name is not equal to Quote- TEST ACCOUNT');
        String jsonStr = getJsonStr(quote,false);
        jsonStr = EncodingUtil.urlEncode(jsonStr, 'UTF-8');   
        String retJSON = CIP_Send_Document_REST_Service.doPost(jsonStr);
        String retJsonStr = EncodingUtil.urlDecode(retJSON, 'UTF-8');
        retJsonStr = retJsonStr.replace('\\"', '"');                
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = CIP_RestAPI_Client_Handler.GetCIPObject(retJsonStr);        
        System.assertEquals(cipFlds.fileName,'ASF Document', 'File name is not equal to ASF Document');
        Test.stopTest();   
    } 
    
    //Start | PRDCRM-47803 : Tech Debt story(to remove SOQL inside for loop) | 25th Nov, 2019 | Accenture - Panthers
    /**
    @description : Test method to to cover Exception part of method getLatestQuoteForGroupNumber
    */
	@isTest
    static void testServicetoCoverException() 
    {		
		Test.setMock(HttpCalloutMock.class, new CIP_RestAPI_HttpCallout_MockImpl());   
        CIPIntegration__c cipInt = CIP_Util_Test_Methods.createCIPIntegration();      
        insert cipInt;
        
        
        Test.startTest(); 
		Quote quote = [SELECT Id, name, GroupNumber__c, opportunityId FROM Quote LIMIT 1];
		System.assertEquals(quote.name,'Quote- TEST ACCOUNT', 'Quote name is not equal to Quote- TEST ACCOUNT');
        String jsonStr = getJsonStr(quote,false);
		CIP_RestAPI_Client_Handler.CIPFields objCipFields = (CIP_RestAPI_Client_Handler.CIPFields) System.JSON.deserialize(EncodingUtil.urlDecode(JSONStr, 'UTF-8'), CIP_RestAPI_Client_Handler.CIPFields.class);
		objCipFields.GroupNumber = 'CEF123';
        objCipFields.parentId = null;
		jsonStr = System.JSON.serialize(objCipFields, true);
        jsonStr = EncodingUtil.urlEncode(jsonStr, 'UTF-8');   
        String retJSON = CIP_Send_Document_REST_Service.doPost(jsonStr);
        String retJsonStr = EncodingUtil.urlDecode(retJSON, 'UTF-8');
        retJsonStr = retJsonStr.replace('\\"', '"');                
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = CIP_RestAPI_Client_Handler.GetCIPObject(retJsonStr);        
        System.assertEquals(cipFlds.fileName,null, 'File name is not equal to null');		
		
        Test.stopTest();   
    }
    //End | PRDCRM-47803 : Tech Debt story(to remove SOQL inside for loop) | 25th Nov, 2019 | Accenture - Panthers
    
    
    /**
    @description : Test method to test creation of CIPFields object
    */    
  
	@isTest
    static void testServiceInitiation()
    {   
		Test.startTest(); 
        Quote quote = [SELECT Id, name, GroupNumber__c, opportunityId FROM Quote LIMIT 1];
		System.assertEquals(quote.name,'Quote- TEST ACCOUNT', 'Quote name is not equal to Quote- TEST ACCOUNT');
        
        CIP_Send_Document_REST_Service.CIPFields cipFields = new CIP_Send_Document_REST_Service.CIPFields();
        cipFields.name=quote.Name;
        cipFields.recType='LG Customer';
        cipFields.topic='CIP';
        cipFields.Status ='Success';
        cipFields.ErrorCode ='0';
        cipFields.Message ='Success';
        cipFields.CIPId ='001S';
        cipFields.fileContent ='CIPContent';    
        cipFields.fileName ='CIPTest';   
        cipFields.ParentId =quote.Id;
        cipFields.AccountName='45';
        cipFields.AccountNumber='45';
        cipFields.GroupNumberSFDCId='006S000000C';
        cipFields.SIC='Health';
        cipFields.Total_Employees='200';
        cipFields.Total_Eligibles='50';
        cipFields.HQ_State='California';
        cipFields.Original_Effective_Date='6/4/2019';
        cipFields.RecordType='LG Customer';
        cipFields.AnthemEntity='Large Group';
        cipFields.Group_Size='100';
        cipFields.Region='West';
        cipFields.Branding='Anthem Blue Cross';
        cipFields.Duns_Number='1234';
        cipFields.Segment ='Test Segment';
        cipFields.Website='www.test.com';
        cipFields.BillingAddress='214,Alamosa st Raleigh, NC 98057 UnitedStates';
        cipFields.ShippingAddress='214,Alamosa st Raleigh, NC 98057 UnitedStates';    
        cipFields.GroupNumber='904012';
        cipFields.OpportunityId='006S000000Cza5pIAB';       
        cipFields.OpportunityEffectiveDate='6/4/2019';                   
        cipFields.OpportunityName='2019 New Business Local-45';                   
        cipFields.OpportunityReceivedDt='5/5/2019';
        cipFields.OpportunityType='New Business Local';              
        cipFields.BillingStreet='Acacia Stree';     
        cipFields.BillingCity='Bell';     
        cipFields.BillingState='California';     
        cipFields.BillingPostalCode='90201';         
        cipFields.BillingCountry='Los Angeles';         
        cipFields.ShippingStreet='Acacia Stree';     
        cipFields.ShippingCity='Bell';     
        cipFields.ShippingState='California';     
        cipFields.ShippingPostalCode='90201';         
        cipFields.ShippingCountry='Los Angeles';		
        Test.stopTest();   

    } 
    
    /**
    @description : Method to generate JSON
    @return : String 
    @param : Instance of Quote object, Boolean variable
    */ 
    public static String getJsonStr(Quote quote,boolean flag){
        CIP_RestAPI_Client_Handler.CIPFields cipFlds = new CIP_RestAPI_Client_Handler.CIPFields();
        cipFlds.name='Test Name';
        cipFlds.recType='LG Customer';
        cipFlds.topic='CIP';
        cipFlds.Status='Success';
        cipFlds.ErrorCode='0';
        cipFlds.Message='Success';
        cipFlds.CIPId='001S';
        cipFlds.fileContent='CIPContent';
        cipFlds.fileName='CIPTest';
        if(flag)
        {
            cipFlds.ParentId=quote.Id;
        }
        else
        {
            cipFlds.GroupNumber='ABC123';
        }
        cipFlds.AccountName='45';
        cipFlds.AccountNumber='45';
        cipFlds.SIC='Health';
        cipFlds.Total_Employees='200';
        cipFlds.Total_Eligibles='50';
        cipFlds.HQ_State='California';
        cipFlds.Original_Effective_Date='6/4/2019';
        cipFlds.RecordType='LG Customer';
        cipFlds.AnthemEntity='Large Group';
        cipFlds.Group_Size='100';
        cipFlds.Region='West';
        cipFlds.Branding='Anthem Blue Cross';
        cipFlds.Duns_Number='1234';
        cipFlds.Segment ='Test Segment';
        cipFlds.Website='www.test.com';
        cipFlds.BillingAddress='214,Alamosa st Raleigh, NC 98057 UnitedStates';
        cipFlds.ShippingAddress='214,Alamosa st Raleigh, NC 98057 UnitedStates';           
        cipFlds.GroupNumberSFDCId='904012';
        cipFlds.OpportunityId='006S000000Cza5pIAB';     
        cipFlds.OpportunityEffectiveDate='6/4/2019';                 
        cipFlds.OpportunityName='2019 New Business Local-45';  
        cipFlds.OpportunityReceivedDt='5/5/2019';  
        cipFlds.OpportunityType='New Business Local';  
        cipFlds.BillingStreet='Acacia Stree';
        cipFlds.BillingCity='Bell';
        cipFlds.BillingState='California';
        cipFlds.BillingPostalCode='90201';    
        cipFlds.BillingCountry='Los Angeles';    
        cipFlds.ShippingStreet='Acacia Stree';
        cipFlds.ShippingCity='Bell';
        cipFlds.ShippingState='California';
        cipFlds.ShippingPostalCode='90201';    
        cipFlds.ShippingCountry='California';    
        cipFlds.DivisionName='Test Division';
        cipFlds.UseDivisionNameAsGroupName=true;
        cipFlds.ClaimSystem='Test Claim';    
        cipFlds.MemberCount='50'; 
        return System.JSON.serialize(cipFlds, true);       
    }
   
}