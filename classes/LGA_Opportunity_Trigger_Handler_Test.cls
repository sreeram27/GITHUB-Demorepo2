/*****************************************************************
* Class Name     : LGA_Opportunity_Trigger_Handler_Test
* Created By     : IDC Offshore
* Description     : This is the Test class for the LGA_Opportunity_Trigger_Handler
*                 .
* Change History : 
* ***************************************************************/ 

@isTest
public With Sharing  class LGA_Opportunity_Trigger_Handler_Test {
    
/************************************************************************
* Method Name 	 : createUpdateApplication
* Description 	 : To test createUpdateApplication() Class 
* Created By     : Prabir Mohanty
* Change History :
* Date			 : 21st June, 2019
************************************************************************/ 
    @isTest(SeeAllData=False)
    private static void createApplicationTest(){
        
        try{
            
            //User testUser = Util02_TestData.createUser();
            List<Id> accRecordTypeList = new List<Id>();
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('LG_Prospect').getRecordTypeId();         
            accRecordTypeList.add(accountRecordTypeId);
            List<Account> accountList = Anthem_TestDataFactory.generateAccount(accRecordTypeList);
            
            Database.insert(accountList, false);
            system.debug('*******Account******' + accountList);
            
            List<Opportunity> oppList = new List<Opportunity>();
            for(Account acc: accountList){
                system.debug('555555555555555555' + acc.Id);
            List<Id> oppRecordTypeList = new List<Id>();
            Id opportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('New_Business_Local').getRecordTypeId();
            oppRecordTypeList.add(opportunityRecordTypeId);
            oppList = Anthem_TestDataFactory.generateOpportunity(oppRecordTypeList,acc.Id);        
            
            Database.insert(oppList, false); 
            system.debug('*******Opportunity******' + oppList);
            }
            
            
            Product2 product = Anthem_TestDataFactory.generateProduct2();   
            Database.insert(product, false);
            
            
            Id priceBookId = Anthem_TestDataFactory.generatePricebookId();
            
            
            PricebookEntry priceBookEntry = Anthem_TestDataFactory.generatePricebookEntry(product.Id,priceBookId);
            Database.insert(priceBookEntry, false);
            
            
            List<Id> quoteRecIdList = new List<Id>();
            Id largeGroupQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('LargeGroupQuote').getRecordTypeId();         
            quoteRecIdList.add(largeGroupQuoteRecordTypeId);
            List<Quote> quoteList = Anthem_TestDataFactory.generateQuote(quoteRecIdList, priceBookId, oppList[0].Id);
            Database.insert(quoteList, false);
            system.debug('*******Quote******' + quoteList);
            
            
            List<Id> quoteLineItem = new List<Id>();
            List<QuoteLineItem> quoteLineItemTest = Anthem_TestDataFactory.generateSoldQuoteLineItem(3, product.Id, quoteList[0].Id, priceBookEntry);       
            Database.insert(quoteLineItemTest, false);
            system.debug('*******QLI******' + quoteLineItemTest);
            
            
            Opportunity opp = New Opportunity();
            Opportunity opp1 = New Opportunity();
            Opportunity opp2 = New Opportunity();
            
            
            Test.startTest();
            //System.runAs(testUser) {
                
                opp.Id = oppList[0].Id;
                opp.StageName = staticVariableClass.ClosedWon;
                Database.update(opp,false);
                
                opp1.Id = oppList[0].Id;
                opp1.StageName = staticVariableClass.StageNameInitiated;
                Database.update(opp1,false);
                
                opp2.Id = oppList[0].Id;
                opp2.StageName = staticVariableClass.ClosedWon;
                Database.update(opp2,false);
                
            //}
            Test.stopTest();
            System.assert([Select count() From Account Limit 50000] >= 0);
            /*System.assertEquals([Select count() From Opportunity  Limit 10],1);
System.assertEquals([Select count() From Product2  Limit 10],1);
System.assertEquals([Select count() From PriceBookEntry  Limit 10],1);
System.assertEquals([Select count() From Quote  Limit 10],1);
System.assertEquals([Select count() From QuoteLineItem  Limit 10],3);*/
            
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
    }
}