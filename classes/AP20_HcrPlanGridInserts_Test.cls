/**
@Author : Accenture Offshore Dev team
@name : AP20_HcrPlanGridInserts_Test
@CreateDate :4/9/2018
@Description :This class is used for the test coverage of AP20_HcrPlanGridInserts .
*/

@isTest
 
private class AP20_HcrPlanGridInserts_Test {

static testMethod void HcrPlanGridInsertsTest(){

  List<Account> accList= new List<Account>();
        Account acc = new Account (Name='newaccount',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        Account acc1 = new Account (Name='newaccount1',Anthem_Entity__c ='National Accounts',Brand__c ='Uni care',Group_Size__c ='0 - 50',HQ_State__c = 'ak',Total_Employees__c =20);
        accList.add(acc);
        accList.add(acc1);
    insert accList;
 
  
  Group__c testGroup = new Group__c(Name='tet41',Account__c=accList[0].id);
  insert testGroup;
 
  HCR__c hcr1 = new HCR__c();
  hcr1.Group__c=testGroup.id; 
  insert hcr1;
  system.debug('&&hcr1'+hcr1.id);
  
  
  System.debug([Select Id,Group_Number__c from HCR__c where Id = :hcr1.Id]);
  
  HCR__c hcrRecord = [Select Id,Group_Number__c from HCR__c where Id = :hcr1.Id limit 1];
  id RecTypeId =Schema.SObjectType.HCR_Plan_Grids__c.getRecordTypeInfosByName().get('Grandfathered').getRecordTypeId();
  HCR_Plan_Grids__c hp1 = new HCR_Plan_Grids__c( Active__c='Yes',HCR__c=hcr1.id,HCR_Status__c='Grandfathered',RecordTypeID=RecTypeId);
  insert hp1;
  
  HCR__c hcr2 = new HCR__c(); 
  hcr2.Group__c=testGroup.id;
  insert hcr2;
  system.debug('&&hcr2'+hcr2.id);
   
  HCR_Plan_Grids__c hp2 = new HCR_Plan_Grids__c( Active__c='Yes',HCR__c=hcr2.id,HCR_Status__c='Grandfathered');
  insert hp2;
   
  HCR__c hcr3 = new HCR__c();
  hcr3.Group__c=testGroup.id;
  
  insert hcr3;
   
   
   list<String> grpnames = new list<String>();
   grpnames.add(testGroup.Name);
   
  
  String s = String.valueOf(hcrRecord.Group_Number__c);
  System.debug(s);
  AP20_HcrPlanGridInserts.processBuilderInput pbi = new AP20_HcrPlanGridInserts.processBuilderInput();
  pbi.hcrId =hcr3.id;
  pbi.groupName= testGroup.Id;
  
  
  list<AP20_HcrPlanGridInserts.processBuilderInput> innerList = new list<AP20_HcrPlanGridInserts.processBuilderInput>();
  innerList.add(pbi);
  Test.startTest(); 
  AP20_HcrPlanGridInserts.clonePlanGrids(innerList); 
  Test.stopTest(); 

 }
 
 
}