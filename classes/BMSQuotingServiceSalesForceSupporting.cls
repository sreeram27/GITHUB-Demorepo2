public with sharing class BMSQuotingServiceSalesForceSupporting {
    Id standardPBId = !Test.isRunningTest() ? [select name, isactive from Pricebook2 where IsStandard = true limit 1].Id : Test.getStandardPricebookId();
    
    public BMSQuotingServiceSalesForce.SendQuoteResp SendQuote(BMSQuotingServiceSalesForce.SendQuoteReq SendQuoteReq) {
        BMSQuotingServiceSalesForce.SendQuoteResp SendQuoteResp = new BMSQuotingServiceSalesForce.SendQuoteResp();
        BMSSendEmail sendEmail = new BMSSendEmail();
        BMSQuotingServiceSalesForceSupporting bmsQuote = new BMSQuotingServiceSalesForceSupporting();
        BMSQuotingObject bmsQObj = new BMSQuotingObject();
        System.debug('QuoteRequest - '+SendQuoteReq);
    //   Line_of_Business__c lob = new Line_of_Business__c(); 
        Quote qt = new Quote();
        Opportunity optyObj;
        List<sObject> genObject = new List<sObject>();
        SendQuoteResp.ResponseCode = 'SUCCESS';
        SendQuoteResp.Details= 'SUCCESS';     
        String strDirect;
        BMSQuotingObject.BMSQuoteOpportunity bmsQOppObj = bmsQObj.getOpportunityObj(SendQuoteReq);
        
        if(bmsQOppObj.AccountCode == null || bmsQOppObj.SalesRepCode == null){
            SendQuoteResp.ResponseCode = 'FAILED';
            SendQuoteResp.Details= 'Agent Or Account is Null : Agent Code - ' +bmsQOppObj.SalesRepCode+', Account Code - '+bmsQOppObj.AccountCode;
            sendEmail.CreateEmail(bmsQOppObj,SendQuoteResp.Details, SendQuoteReq.toString());
            return SendQuoteResp;    
        }
        Account accntObj = bmsQuote.getAccountObject(bmsQOppObj.AccountCode); 
        
        User agentDetails = bmsQuote.GetUserInfo(bmsQOppObj.SalesRepCode);
        
        if (agentDetails == null){ 
            SendQuoteResp.ResponseCode = 'FAILED';
            SendQuoteResp.Details= 'Agent Not Found : ' +bmsQOppObj.SalesRepCode;
            if(!Test.isRunningTest())
              sendEmail.CreateEmail(bmsQOppObj,SendQuoteResp.Details, SendQuoteReq.toString());
            return SendQuoteResp;
        }
       
        if(accntObj == null) {
            SendQuoteResp.ResponseCode = 'FAILED';
            SendQuoteResp.Details= 'Account Not Found: '+bmsQOppObj.AccountCode; 
            if(!Test.isRunningTest())
                sendEmail.CreateEmail(bmsQOppObj,SendQuoteResp.Details, SendQuoteReq.toString());
            return SendQuoteResp;
        }
        
        if(agentDetails != null && accntObj != null)
        {
            optyObj = bmsQuote.getOpportunityRecord(bmsQOppObj.OpportunityName, accntObj.Id, bmsQOppObj.CloseDate,bmsQOppObj.BrokerNumber, agentDetails.Id);
            
            if(optyObj == null){
                optyObj = new Opportunity();
                optyObj.AccountId = accntObj.Id;
                optyObj.RecordTypeId = bmsQOppObj.RecordTypeId;
                system.debug('bmsQOppObj.OpportunityName---->'+bmsQOppObj.OpportunityName);
                optyObj.Name =  bmsQOppObj.OpportunityName;
                optyObj.StageName = 'Quoting';//bmsQOppObj.StageName;
                optyObj.OwnerId = agentDetails.Id;
                optyObj.Received_Date__c = Date.Today();
                optyObj.CloseDate = bmsQOppObj.CloseDate;// == null ? Date.Today().addDays(30) : bmsQOppObj.CloseDate;
                insert optyObj;
            } 
            
            else
            {
                // optyObj.Quoted_Health__c =  bmsQOppObj.QuotedHealth;
                // optyObj.Composite_Morbidity_Factor__c = bmsQOppObj.CMF;
                //update optyObj;
                //deleteQuoteandQuoteLineItems(optyObj.id);
            }
            system.debug('optyObj.id-->'+optyObj.id);
            //  New Quote
            system.debug('bmsQOppObj.CloseDate act class:'+bmsQOppObj.CloseDate);
            //qt.Name = bmsQOppObj.CloseDate + (String.isEmpty(bmsQOppObj.BrokerNumber) ? 'DIRECT' : bmsQOppObj.BrokerNumber) + bmsQOppObj.SalesRepCode + bmsQOppObj.AccountCode;
            qt.Name = bmsQOppObj.CloseDatereq+'--'+(String.isEmpty(bmsQOppObj.BrokerNumber) ? 'DIRECT' : bmsQOppObj.BrokerNumber) + '--'+ bmsQOppObj.SalesRepCode + '--'+ bmsQOppObj.AccountCode;

            qt.LineofBusiness__c = 'Medical';
            qt.OpportunityId = optyObj.Id;
            qt.Pricebook2Id = standardPBId;
            insert qt;
            
            //  New QuoteLineItems
            List<QuoteLineItem> qliList = new List<QuoteLineItem>();
            BMSQuotingServiceSalesForce.Benefits[] benefits = SendQuoteReq.User.GroupDetails.Benefits;  
            
            for (BMSQuotingServiceSalesForce.Benefits benefit : benefits){
                System.debug('Benefit Details - '+benefit);
                if(benefit.Medical != null) {
                    if(benefit.Medical.Edition.MedicalProduct.Option != null){
                        BMSQuotingServiceSalesForce.Option option = benefit.Medical.Edition.MedicalProduct.Option;      
                        Product2 prodName = null;
                        if(option.annualOOP == null) {
                            System.debug('Skipping to Next Record');
                            continue;
                        }
                        prodName = bmsQuote.GetProductInfoByDesc(option.description);
                        
                        if(prodName == null) prodName = bmsQuote.GetProductInfoByCode(option.benefitCode);
                        
                        if(prodName == null){ 
                            SendQuoteResp.ResponseCode = 'FAILED';
                            SendQuoteResp.Details= 'Product Not Found: ' +option.description;
                            if(!Test.isRunningTest())
                                sendEmail.CreateEmail(bmsQOppObj,SendQuoteResp.Details, SendQuoteReq.toString());
                            return SendQuoteResp;       
                        }
                        
                        
                        PricebookEntry stdPBE;
                        try {
                            stdPBE = [Select Id From PriceBookEntry Where Pricebook2Id =: standardPBId  AND Product2Id =: prodName.Id AND IsActive = true];
                               system.debug('stdPBE --->'+stdPBE );                     
                        }catch(Exception e) {
                            stdPBE = new PricebookEntry(Pricebook2Id = standardPBId , Product2Id = prodName.Id, IsActive = true, UseStandardPrice = false, UnitPrice = 1);
                        
                            insert stdPBE;
                        }
                        
                        QuoteLineItem prodLine = new QuoteLineItem();
                        try{    
                            
                            // prodLine.Product_Search__c = prodName.Id; 
                            // GetRatesFromRequest(prodLine, benefit.Rates);
                            Double familyCount = String.isBlank(bmsQOppObj.familyContractCount) ? 0 : Double.valueOf(bmsQOppObj.familyContractCount);  
                            Double childCount = String.isBlank(bmsQOppObj.employeeChildContractCount) ? 0 : Double.valueOf(bmsQOppObj.employeeChildContractCount);
                            Double childrenCount = String.isBlank(bmsQOppObj.employeeChildrenContractCount) ? 0 : Double.valueOf(bmsQOppObj.employeeChildrenContractCount);  
                            Double spouseCount =  String.isBlank(bmsQOppObj.employeeSpouseContractCount) ? 0 : Double.valueOf(bmsQOppObj.employeeSpouseContractCount);  
                            Double employeeCount =  String.isBlank(bmsQOppObj.employeeContractCount) ? 0 : Double.valueOf(bmsQOppObj.employeeContractCount);
                            prodLine.Subscribers__c = employeeCount + familyCount + childCount + childrenCount + spouseCount;
                            system.debug('dental prod outside--->');
                            if(benefit.Dental!=null)
                            {
                                if(benefit.Dental.DentalProduct.network !=null)
                                {
                                 system.debug('dental prod present--->');
                                  prodLine.Network__c = benefit.Dental.DentalProduct.network;
                                }
                            }
                            prodLine.QuoteId = qt.Id;
                            prodLine.Quantity = 1;
                            prodLine.PricebookEntryId = stdPBE.id;
                            prodLine.UnitPrice = 1;
                            genObject.add(prodLine);
                        }catch(Exception e){
                            String str = benefit.Rates+'*******'+bmsQOppObj;
                            System.debug('Exception - '+e.getStackTraceString());
                            if(!Test.isRunningTest())
                                sendEmail.CreateEmail(bmsQOppObj,'Exception'+e.getStackTraceString(),str);
                        }                 
                        
                    }  
                }
            }
            insert genObject;
          
        }
        return SendQuoteResp;
    }
  
    public Opportunity getOpportunityRecord(String opptyName, String accountId, Date effectiveDt, String brokerCode, String agentId) 
    {
        //String opptyName = 'NEW SALE OPPORTUNITY --' + effectiveDt + '--' + brokerCode + '-' + agentId; //  ** agentId to be replaced by repCode
        
        Opportunity[] optyObject = [SELECT Id, Type, Received_Date__c, RecordTypeId FROM Opportunity WHERE Name =: opptyName AND OwnerId =: agentId AND AccountId =: accountId and CloseDate =: effectiveDt];
        if (optyObject.size() > 0)
        return optyObject[0];
        else return null;
    }
    public Account getAccountObject(String AccountCode) 
    {
        Account[] accntObject = [SELECT Id, CHIPS_Account_Code__c, Name FROM Account WHERE CHIPS_Account_Code__c =: AccountCode];
        if (accntObject.size() >0)
        return accntObject[0];
        else return null;
    }
    
    public User GetUserInfo(String userId) 
    {
        User[] thisUser = [SELECT Id, USID__c,Rep_ID_Code__c FROM User WHERE Rep_ID_Code__c=: userId];
        if (thisUser.size() >0)
            return thisUser[0];
        else 
            return null;
    }
    
    public Product2 GetProductInfoByDesc(String prodDesc) {
        Product2[] prodNameObj = [SELECT Id, Name FROM Product2 WHERE Name=: prodDesc];
        if (prodNameObj.size() >0)
            return prodNameObj[0];
        else return null;
    }
    
    public Product2 GetProductInfoByCode(String prodCode) {
        Product2[] prodNameObj = [SELECT Id, Name FROM Product2 WHERE Underwriting_Product_Code__c  =: prodCode];
        if (prodNameObj.size() >0)
            return prodNameObj[0];
        else return null;
    }
    /*
    public void deleteQuoteandQuoteLineItems(String SFDCOptyId) 
    {
        // List<Product_Line__c> prodLine = [SELECT Id,Line_of_Business__r.Opportunity__c FROM Product_Line__c WHERE Line_of_Business__r.Opportunity__c =: SFDCOptyId];
        // delete prodLine;
        // List<Line_of_Business__c> lob = [SELECT Id,Opportunity__c FROM Line_of_Business__c WHERE Opportunity__c =: SFDCOptyId];
        // delete lob;
    }*/

}