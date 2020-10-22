@isTest
public class WGSCCQLIDeleteReportTest {
    
    @isTest
    static List<WGS_Sold_Contract_Codes__c> createWGSInputTestData(){
        
        Account acc=IntegrationTestDataUtilty.createAccount(true); 
        
        Opportunity oppty=IntegrationTestDataUtilty.createOpportunity(acc.id, true);
        
        Group__c allSuccessGrp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        allSuccessGrp.Name = 'W61305';
        update allSuccessGrp;
        
        Group__c errorGrp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        errorGrp.Name = 'W61307';
        update errorGrp;
        
        Group__c secondRunSuccessGrp=IntegrationTestDataUtilty.createGroup(acc.id, true);
        secondRunSuccessGrp.Name = 'W61308';
        update secondRunSuccessGrp;
        
        Quote qte=IntegrationTestDataUtilty.createQuote(oppty.Id, allSuccessGrp.id, true);
        Quote qte1=IntegrationTestDataUtilty.createQuote(oppty.Id, errorGrp.id, true);
        Quote qte2=IntegrationTestDataUtilty.createQuote(oppty.Id, secondRunSuccessGrp.id, true);
        
        List<Product2> prodList = new List<Product2>();
        Product2 prod=IntegrationTestDataUtilty.createProduct('40QA', false);
        prod.Category__c = 'Plan';
        prod.Product_Type__c = 'Medical';
        prodList.add(prod);
        
        Product2 prod2 =IntegrationTestDataUtilty.createProduct('40PA', false);
        prod2.Category__c = 'Plan';
        prod2.Product_Type__c = 'Medical';
        prodList.add(prod2);
        
        Product2 prod3 =IntegrationTestDataUtilty.createProduct('40SA', false);
        prod3.Category__c = 'Plan';
        prod3.Product_Type__c = 'Medical';
        prodList.add(prod3);
        
        Product2 prod4 =IntegrationTestDataUtilty.createProduct('40TA', false);
        prod4.Category__c = 'Plan';
        prod4.Product_Type__c = 'Medical';
        prodList.add(prod4);
        
        Product2 prod5 =IntegrationTestDataUtilty.createProduct(null, false);
        prod5.Category__c = 'Plan';
        prod5.Product_Type__c = 'Medical';
        prodList.add(prod5);
        
        Product2 prod6 =IntegrationTestDataUtilty.createProduct(false);
        prod6.Category__c = 'Product';
        prod6.Product_Type__c = 'Medical';
        prodList.add(prod6);
        
        Product2 prod7 =IntegrationTestDataUtilty.createProduct('40AA', false);
        prod7.Category__c = 'Plan';
        prod7.Product_Type__c = 'Medical';
        prodList.add(prod7);
        
        Database.insert(prodList);
        
        PricebookEntry pbe=IntegrationTestDataUtilty.createPricebookEntry(prodList[0].id, true);
        PricebookEntry pbe2=IntegrationTestDataUtilty.createPricebookEntry(prodList[1].id, true);
        PricebookEntry pbe3=IntegrationTestDataUtilty.createPricebookEntry(prodList[2].id, true);
        PricebookEntry pbe4=IntegrationTestDataUtilty.createPricebookEntry(prodList[3].id, true);
        PricebookEntry pbe5=IntegrationTestDataUtilty.createPricebookEntry(prodList[4].id, true);
        PricebookEntry pbe6=IntegrationTestDataUtilty.createPricebookEntry(prodList[5].id, true);
        PricebookEntry pbe7=IntegrationTestDataUtilty.createPricebookEntry(prodList[6].id, true);
        
        
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        QuoteLineItem qli = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe.Id, false);
        qli.Product2Id = prodList[0].Id;
        qliList.add(qli); 
        
        QuoteLineItem qli2 = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe2.Id, false);
        qli2.Product2Id = prodList[1].Id;
        qliList.add(qli2);
        
        QuoteLineItem qli3 = IntegrationTestDataUtilty.createQuoteLineItem(qte1.Id, Pbe3.Id, false);
        qli3.Product2Id = prodList[2].Id;
        qliList.add(qli3);
        
        QuoteLineItem qli4 = IntegrationTestDataUtilty.createQuoteLineItem(qte2.Id, Pbe4.Id, false);
        qli4.Product2Id = prodList[3].Id;
        qliList.add(qli4);
        
        QuoteLineItem qli7 = IntegrationTestDataUtilty.createQuoteLineItem(qte2.Id, Pbe7.Id, false);
        qli7.Product2Id = prodList[6].Id;
        qliList.add(qli7);
        
        QuoteLineItem qli5 = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe5.Id, false);
        qli5.Product2Id = prodList[4].Id;
        qli5.vlocity_ins__ContractCode__c = null;
        qliList.add(qli5);
        
        QuoteLineItem qli9 = IntegrationTestDataUtilty.createQuoteLineItem(qte1.Id, Pbe5.Id, false);
        qli9.Product2Id = prodList[4].Id;
        qli9.vlocity_ins__ContractCode__c = null;
        qliList.add(qli9);
        
        QuoteLineItem qli6 = IntegrationTestDataUtilty.createQuoteLineItem(qte1.Id, Pbe6.Id, false);
        qli6.Product2Id = prodList[5].Id;
        qliList.add(qli6);
        
        QuoteLineItem qli8 = IntegrationTestDataUtilty.createQuoteLineItem(qte2.Id, Pbe6.Id, false);
        qli8.Product2Id = prodList[5].Id;
        insert qli8;
        
        QuoteLineItem childforParenDelQLI = IntegrationTestDataUtilty.createQuoteLineItem(qte2.Id, Pbe4.Id, false);
        childforParenDelQLI.Product2Id = prodList[3].Id;
        childforParenDelQLI.ParentQuoteLineItem__c = qli8.Id;
        insert childforParenDelQLI;
        
        QuoteLineItem qliParentError = IntegrationTestDataUtilty.createQuoteLineItem(qte.Id, Pbe6.Id, false);
        qliParentError.Product2Id = prodList[5].Id;
        qliList.add(qliParentError);
        
        Database.insert(qliList);
        
        List<WGS_Sold_Contract_Codes__c> wgsRecList = new List<WGS_Sold_Contract_Codes__c>();
        
        WGS_Sold_Contract_Codes__c allSuccessRec1= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61305', Contract_Code__c ='40QA', Benefit_Period__c = 'Calendar Year',
                                                                                  Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Success',
                                                                                  Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No', QLI_ID_Created__c = qliList[0].id);
        wgsRecList.add(allSuccessRec1);
        
        WGS_Sold_Contract_Codes__c allSuccessRec2= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61305', Contract_Code__c ='40PA', Benefit_Period__c = 'Calendar Year',
                                                                                  Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Success',
                                                                                  Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No', QLI_ID_Created__c = qliList[1].id);
        wgsRecList.add(allSuccessRec2);
        
        WGS_Sold_Contract_Codes__c partialSuccessRec1= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61307', Contract_Code__c ='40SA', Benefit_Period__c = 'Calendar Year',
                                                                                      Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Success',
                                                                                      Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No', QLI_ID_Created__c = qliList[2].id);
        wgsRecList.add(partialSuccessRec1);
        
        WGS_Sold_Contract_Codes__c partialSuccessRec2= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61307', Contract_Code__c ='40LA', Benefit_Period__c = 'Calendar Year',
                                                                                      Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Error',
                                                                                      Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No');
        wgsRecList.add(partialSuccessRec2);
        
        WGS_Sold_Contract_Codes__c partialSuccessRec3= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61307', Contract_Code__c ='40BA', Benefit_Period__c = 'Calendar Year',
                                                                                      Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Error',
                                                                                      Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No');
        wgsRecList.add(partialSuccessRec3);
        
        WGS_Sold_Contract_Codes__c secondRunSuccess1= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61308', Contract_Code__c ='40AA', Benefit_Period__c = 'Calendar Year',
                                                                                     Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Success',
                                                                                     Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No', QLI_ID_Created__c = qliList[4].id);
        wgsRecList.add(secondRunSuccess1);
        
        WGS_Sold_Contract_Codes__c secondRunSuccess2= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61308', Contract_Code__c ='40TA', Benefit_Period__c = 'Calendar Year',
                                                                                     Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Success',
                                                                                     Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No', QLI_ID_Created__c = qliList[3].id);
        wgsRecList.add(secondRunSuccess2);
        
        WGS_Sold_Contract_Codes__c secondRunSuccess3= new WGS_Sold_Contract_Codes__c(WGS_Group_Number__c = 'W61308', Contract_Code__c ='40TA', Benefit_Period__c = 'Calendar Year',
                                                                                     Effective_Date__c = Date.today(), Financing__c = 'Fully Insured', Funding_Type__c = 'FI', Status__c = 'Error',
                                                                                     Member_Count__c = 150, Subscriber_Count__c = 100, Upsell_Flag__c = 'No');
        wgsRecList.add(secondRunSuccess3);
        
        Database.insert(wgsRecList); 
        
        return wgsRecList;
    }
    
    @isTest
    static void testWGSCCDeeleteReport(){
        
        List<WGS_Sold_Contract_Codes__c> wgsRecList = createWGSInputTestData();
        
        System.debug('Test Data WGS Input data Records Size: '+ wgsRecList.size());
        
        String[] statuses= new String[]{'Success','Error'};
        String[] toEmails = new String[]{'sushmithachandra.venkata@anthem.com'}; 
        Date[] effectiveDatesToProcess = new Date[]{Date.today()};  
            
        WGSCCQLIDeleteReport.getdeleteQLIsReport( statuses,effectiveDatesToProcess, toEmails);
        System.assertEquals(1, Limits.getEmailInvocations(), 'An Email is sent with Attachments');
        
    } 
}