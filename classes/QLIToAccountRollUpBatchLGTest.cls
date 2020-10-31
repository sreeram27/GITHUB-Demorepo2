/**************************************************************************************
Apex Class Name:  QLIToAccountRollUpBatchLGTest
Version     : 1.0 
Created Date    : 13 June 2019
* @Author: Legato Vikings Team
Function    : Test class for QLIToAccountRollUpBatchLG
*************************************************************************************/
@isTest
public class QLIToAccountRollUpBatchLGTest extends staticVariableClass {
    
    @testSetup
    static  void setupTestData(){
        AccountRoles__c roles = new AccountRoles__c();
        roles.Name = 'QLIToAccountRollUpBatchLG';        
        DateTime dt = DateTime.newInstance(2012,2,3,13,20,30);
        roles.LastRun__c = dt;
        insert roles;
        
        //********Moved the code for test data creation**********//
        SIC__c Sic = new SIC__c(
            Name = staticVariableClass.SIC
        );
        Insert SIC;
        List<account>accList=new List<account>();      
        for(integer i=0;i<11;i++){
         Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = 'VKLegosACN'+i,
            Account_s_Suppress_Auto_Renewal__c = false,
            Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region,
            Branding__c =staticVariableClass.UniCare,
            SIC__c = SIC.Id,
            Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp,
            HQ_State__c =staticVariableClass.AK,
            Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true,
            BillingStreet = 'Land Marks'+i,
            BillingPostalCode = '560036',
            BillingCity = 'Manglores'+i,
            BillingCountry = 'India',
            BillingState = 'Karnataka',
            Physical_County__c = 'Banglore' 
            );
          accList.add(acc);
        }   
      
        insert accList;
        
        List<Opportunity> lstOpp= new List<Opportunity>();
        
        for(integer i=0;i<11;i++){
            Opportunity newOpp = new Opportunity(
                name=  (String.valueOf(system.today().year() + 1) + ' New Business Local-' +  accList[i].Name),
                StageName = staticVariableClass.ClosedWon,
                AccountID = accList[i].id,
                CloseDate = ((system.TODAY())-9),                   
                recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New Business Local').getRecordTypeId()                                    
            );
            lstOpp.add(newOpp);
        }   
        Database.insert(lstOpp);
        
        Group__c grp=ANA_UTIL01_TestMethods.createGroup(accList[0].id,false);
        Database.insert(grp);
        
        List<Quote> qteList=ANA_UTIL01_TestMethods.createQuotes(11,false,lstOpp[0].Id);
        for(integer i=0;i<11;i++){
        qteList[i].GroupNumber__c=grp.id;
        qteList[i].Opportunityid=lstOpp[i].Id;
        }
        
        Database.insert(qteList);
        
        Product2 prod=ANA_UTIL01_TestMethods.createProduct(false);
        prod.Family = 'Medical';
        prod.LOB__c= 'Medical';        
        prod.name='Anthem Health PPO Medical';
        Database.insert(prod);
        
        PricebookEntry pbe=ANA_UTIL01_TestMethods.createPricebookEntry(false,prod.id);
        Database.insert(pbe);
        
        List<QuoteLineItem> qliList=new List<QuoteLineItem>();       
        List<QuoteLineItem> qliList5=ANA_UTIL01_TestMethods.createQuoteLineItems(5,false,qteList[4].id,pbe.id);  // where all the QLI's will be in N/A Status 
        List<QuoteLineItem> qliList1=ANA_UTIL01_TestMethods.createQuoteLineItems(4,false,qteList[0].id,pbe.id);
        List<QuoteLineItem> qliList2=ANA_UTIL01_TestMethods.createQuoteLineItems(4,false,qteList[1].id,pbe.id);
        List<QuoteLineItem> qliList3=ANA_UTIL01_TestMethods.createQuoteLineItems(4,false,qteList[2].id,pbe.id);
        
        List<QuoteLineItem> qliList4=ANA_UTIL01_TestMethods.createQuoteLineItems(4,false,qteList[3].id,pbe.id);   //IN Progress+Mixed         
        List<QuoteLineItem> qliList6=ANA_UTIL01_TestMethods.createQuoteLineItems(4,false,qteList[5].id,pbe.id);   //IN Progress+FI     
        List<QuoteLineItem> qliList10=ANA_UTIL01_TestMethods.createQuoteLineItems(1,false,qteList[9].id,pbe.id);   //IN Progress+ASO
        
        List<QuoteLineItem> qliList7=ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qteList[6].id,pbe.id); //Lost+Mixed
        List<QuoteLineItem> qliList8=ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qteList[7].id,pbe.id);   //Lost+ASO        
        List<QuoteLineItem> qliList9=ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qteList[8].id,pbe.id);   //Lost+FI  

        List<QuoteLineItem> qliList11=ANA_UTIL01_TestMethods.createQuoteLineItems(2,false,qteList[10].id,pbe.id); // Covers Deleted  //Lost+FI          
        
           
         qliList5[0].Funding__c='N/A';       
         qliList5[1].Funding__c='N/A';      
         qliList5[2].Funding__c='N/A';        
         qliList5[3].Funding__c='N/A';
		 qliList5[4].Funding__c='N/A';
		 qliList5[0].ProductStage__c='IGAP Sold'; 
         qliList5[1].ProductStage__c='Sold';
         qliList5[2].ProductStage__c='Renewed'; 
         qliList5[3].ProductStage__c='Sold'; 
		 qliList5[4].ProductStage__c='IGAP Dead'; 
         
         qliList1[0].Funding__c='ASO';        // Sold+Mixed Funding
         qliList1[1].Funding__c='FI';       
         qliList1[2].Funding__c='ASO';        
         qliList1[3].Funding__c='ASO';
         qliList1[0].ProductStage__c='IGAP Sold'; 
         qliList1[1].ProductStage__c='Sold';
         qliList1[2].ProductStage__c='Renewed'; 
         qliList1[3].ProductStage__c='Sold'; 
            
            
         qliList2[0].Funding__c='ASO';     // Sold+ASO Funding    
         qliList2[1].Funding__c='ASO';          
         qliList2[2].Funding__c='ASO';        
         qliList2[3].Funding__c='ASO';         
         qliList2[0].ProductStage__c='Sold'; 
         qliList2[1].ProductStage__c='Sold';
         qliList2[2].ProductStage__c='Sold'; 
         qliList2[3].ProductStage__c='Sold'; 
         
         qliList3[0].Funding__c='FI';         // Sold+FI Funding
         qliList3[1].Funding__c='FI';         
         qliList3[2].Funding__c='FI';      
         qliList3[3].Funding__c='FI';       
         qliList3[0].ProductStage__c='Sold'; 
         qliList3[1].ProductStage__c='Sold';
         qliList3[2].ProductStage__c='Sold'; 
         qliList3[3].ProductStage__c='Sold'; 
            
         qliList4[0].Funding__c='ASO';       // In Progress+Mixed Funding  
         qliList4[1].Funding__c='ASO/FI';          
         qliList4[2].Funding__c='FI';        
         qliList4[3].Funding__c='ASO';         
         qliList4[0].ProductStage__c='In Progress'; 
         qliList4[1].ProductStage__c='IGAP In Progress';
         qliList4[2].ProductStage__c='In Progress'; 
         qliList4[3].ProductStage__c='In Progress'; 
        
         qliList6[0].Funding__c='FI';       // In Progress+FI Funding  
         qliList6[1].Funding__c='FI';          
         qliList6[2].Funding__c='FI';        
         qliList6[3].Funding__c='N/A';         
         qliList6[0].ProductStage__c='In Progress'; 
         qliList6[1].ProductStage__c='IGAP In Progress';
         qliList6[2].ProductStage__c='In Progress'; 
         qliList6[3].ProductStage__c='In Progress'; 
         
         qliList10[0].Funding__c='ASO';    // In Progress+ASO Funding        
         qliList10[0].ProductStage__c='In Progress';
         
        
         qliList7[0].Funding__c='ASO';       // Lost+Mixed Funding  
         qliList7[1].Funding__c='ASO/FI';
         qliList7[0].ProductStage__c='Lost'; 
         qliList7[1].ProductStage__c='IGAP Lost';
         
         qliList8[0].Funding__c='ASO';       // Lost+ASO  
         qliList8[1].Funding__c='ASO';
         qliList8[0].ProductStage__c='Lost'; 
         qliList8[1].ProductStage__c='IGAP Lost';
         
         qliList9[0].Funding__c='FI';       // Lost+FI  
         qliList9[1].Funding__c='FI'; 
         qliList9[0].ProductStage__c='Lost'; 
         qliList9[1].ProductStage__c='IGAP Lost';
    
         qliList11[0].Funding__c='N/A';       // will be deleted 
         qliList11[1].Funding__c='FI'; 
         qliList11[0].ProductStage__c='In Progress'; 
         qliList11[1].ProductStage__c='IGAP Lost';
         
         qliList.addall(qliList1);
         qliList.addall(qliList2);
         qliList.addall(qliList3);
         qliList.addall(qliList4);
         qliList.addall(qliList5);
         qliList.addall(qliList6);
         qliList.addall(qliList7);
         qliList.addall(qliList8);
         qliList.addall(qliList9);
         qliList.addall(qliList10);
         qliList.addall(qliList11);
         
         Database.insert(qliList);
         delete qliList11;
        
        //*****************************************************************
        
    }
    
    static testMethod void testMethodBatchAccountUpdate() 
    {
        
        
         Test.startTest();
           QLIToAccountRollUpBatchLG obj = new QLIToAccountRollUpBatchLG();
           DataBase.executeBatch(obj,200); 
         Test.stopTest();
    }
    
    
}