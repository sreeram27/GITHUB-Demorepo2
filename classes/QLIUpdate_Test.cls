//*************************************************************************************//
//******       Description:Test Class For 'QLIUpdate'								   
//******       Author:Harshavardhan																	  
//******       Version:43																		
//******       Date:6-08-18																											
//*************************************************************************************//

@isTest(seealldata=true)
private class QLIUpdate_Test {
    
     static testMethod void QLIUpdate() {

         Account acc = new Account (Name='newaccount',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
         insert acc;
  
        //Creating Opportunity Records
      list<id> lid =new list<id>();
        Opportunity opty = new opportunity(Name = 'test Opty',StageName = 'Engage',Closedate = Date.newInstance(2008,11,20),AccountId = acc.Id);
        insert opty; 
         lid.add(opty.id);
         Group__c grp1 = new Group__c(Name='tet41',Account__c=acc.id,ClaimSystem__c = 'NASCO');
           insert grp1;
         
           
       Group__c grp2 = new Group__c(Name='tet41',Account__c=acc.id,ClaimSystem__c = 'WGS 2.0');
           
            insert grp2;  
        
        Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
    Pricebook2 prb= new  Pricebook2(Name='Test',Description ='Price Book Products',IsActive = true);
    insert prb;
          Product2 prod = new Product2(Name = 'productName',isActive=true);
    insert prod;
   
    Product2 prodmed = new Product2(Name = 'Medical - POS',isActive=true);//'Onsite Clinics'
    insert prodmed;
    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, 
      Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert standardPrice;
    
    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = prb.Id,
       Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
    insert pbe;
            Quote quoteRec = new Quote(Name = 'Test Quote',OpportunityId = opty.Id,GroupNumber__c=grp1.id,Pricebook2Id = standardPB.Id);
        insert quoteRec;
            QuoteLineItem qli = new QuoteLineItem(QuoteId = quoteRec.Id,PricebookEntryId=standardPrice.id,Quantity = 1,UnitPrice = 1000);         
         insert qli;
         
         
         QLIUpdate.QLIUpdate(lid);
    
     }

}