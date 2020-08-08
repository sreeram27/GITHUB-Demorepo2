public class IntegrationTestDataUtilty {
    
    //Test classes for this class : ContCodeReservServiceTest , CMPartialJSONRequestTest
    //
    //TO DO :   take recordtype name, state, anthem entity and account name as input parameter
    public static Account createAccount(Boolean doInsert){
        Account acc;
         
        try{  
            acc = new Account();
           // acc.RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId();    
            acc.Name = 'Test Account';
            acc.BillingStreet = '200 Main Street';
            acc.BillingCity = 'Denver';
            acc.BillingCountry = 'UnitedStates';
            acc.BillingPostalCode = '80238';
            acc.BillingState = 'CO';
            acc.Physical_County__c = 'UnitedStates';
            acc.Mailing_Address_Same_as_Physical_Address__c = true;
            acc.Anthem_Entity__c = 'Local/Large Group';
            acc.Region__c = 'West';
            acc.Group_Size__c ='0 - 50';
           
            if(doInsert)
            insert acc;
        }catch(Exception ex){
           System.debug('Account Insert Exception occured ' +ex.getMessage()); 
        }
        System.debug(acc.Id);
        return acc;
    }
    
    public static Account createAccount(String AcctName, String State, String RecordTypeName, String AnthemEntity, Boolean doInsert){
        Account acc;
         
        try{  
            acc = new Account();
            String recTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
            acc.RecordTypeId = recTypeId;   
            acc.Name = AcctName;
            acc.BillingStreet = '200 Main Street';
            acc.BillingCity = 'Denver';
            acc.BillingCountry = 'UnitedStates';
            acc.BillingPostalCode = '80238';
            acc.BillingState = State;
            acc.Physical_County__c = 'UnitedStates';
            acc.Mailing_Address_Same_as_Physical_Address__c = true;
            acc.Anthem_Entity__c = AnthemEntity;
            //acc.Region__c = 'West';
            acc.Group_Size__c ='0 - 50';
           
            if(doInsert)
            insert acc;
        }catch(Exception ex){
           System.debug('Account Insert Exception occured' +ex.getMessage()); 
        }
        System.debug(acc.Id);
        return acc;
    }
    
    public static Opportunity createOpportunity(Id AccId, Boolean doInsert){
        
        Opportunity opp;
        try{
            
            Opp = new Opportunity();
            Opp.Name = 'Test Opportunity ';
            Opp.AccountId = AccId;
            Opp.StageName = 'Closed Won'; 
            Opp.CloseDate = Date.today();
            
            if(doInsert)
            insert Opp;
        }catch(Exception ex){
           System.debug('Opportunity Insert Exception occured' +ex.getMessage()); 
        }
        
        return Opp;
    }
    
    public static Group__c createGroup(Id accId, Boolean doInsert){
        Group__c grp; 
        try{
            grp = new Group__c();
            grp.Name = 'Test Group';
            grp.Account__c = accId;
            grp.ClaimSystem__c = 'WGS 2.0';
            grp.IsActive__c  = True;
            
            if(doInsert)
            insert grp;
        }
        catch(Exception ex){
             System.debug('Group Insert Exception occured' +ex.getMessage());
        }
        
      return grp;  
    }
    /* TO-DO - take contract code as parameter */
    public static Product2 createProduct(Boolean doInsert){
        Product2 product;
        
        try{
           product = new Product2();
           product.Name = 'Test Product';
           product.IsActive = True;
           product.Contract_Code__c = '3MU2'; 
            
            if(doInsert)
            insert product;
        }
        catch(Exception ex){
            System.debug('Product Insert Exception occured' +ex.getMessage());
        }
        
        return product;  
    }
    
    public static Product2 createProduct(String ContractCode, Boolean doInsert){
        Product2 product;
        
        try{
           product = new Product2();
           product.Name = 'Test Product';
           product.IsActive = True;
           product.Contract_Code__c = ContractCode; 
            
            if(doInsert)
            insert product;
        }
        catch(Exception ex){
            System.debug('Product Insert Exception occured' +ex.getMessage());
        }
        
        return product;  
    }
    
    public static PriceBookEntry createpricebookEntry(Id ProdId, Boolean doInsert){
        PriceBookEntry pbentry;
       
        try{
           pbentry = new PriceBookEntry();
           pbentry.Pricebook2Id = Test.getStandardPricebookId();
           pbentry.Product2Id   = ProdId;
           pbentry.IsActive = True;
           pbentry.UnitPrice = 1000;
            
          if(doInsert)  
          insert  pbentry; 
        }
        catch(Exception ex){
          System.debug('PBE Insert Exception occured' +ex.getMessage());  
        }
        
        return pbentry;
    }
    
    public static Quote createQuote(Id OppId, Id GrpId, Boolean doInsert){
        Quote quot;     
        try{
           quot = new Quote();
           quot.Name = 'Test Quote';
           quot.OpportunityId = OppId;
           quot.Pricebook2Id = Test.getStandardPricebookId();
           quot.GroupNumber__c = GrpId;
           
            if(doInsert)
            insert quot;
        }
        catch(Exception ex){
            System.debug('Quote Insert Exception occured' +ex.getMessage());
        }
        
        return quot;
    }
    
    public static QuoteLineItem createQuoteLineItem(Id QuoteId, Id PricebookEntryId, Boolean doInsert){
        QuoteLineItem qli;
           
        try{
            qli = new QuoteLineItem();
            qli.QuoteId = QuoteId;
            qli.PricebookEntryId = PricebookEntryId;
            qli.Quantity = 1;
            qli.UnitPrice = 100;
            
            if(doInsert)
            insert qli;
        }
        catch(Exception ex){
            System.debug('QLI Insert Exception occured' +ex.getMessage());
        }
        System.debug(qli);
        return qli;
    }
    
    /* take status as one of the parameter */
    public static Order createImplCase(Id QuoteId, Id AccountId, Boolean doInsert){
        Order ImplCase;
        
        try{
            ImplCase = new Order();
            ImplCase.QuoteId = QuoteId;
            ImplCase.AccountId = AccountId;
            ImplCase.Name = 'Test';
            ImplCase.Status = 'Draft';
            ImplCase.EffectiveDate = Date.today();
            
            if(doInsert)
                insert ImplCase;
        }
        catch(Exception ex){
            System.debug('Create ImplCase Exception occured' +ex.getMessage());
        }
        System.debug(ImplCase);
        return ImplCase;
    }
    public static Implementation_tracking__c createImplTracking(Id OrderId, Id AccountId, Boolean doInsert){
        Implementation_tracking__c ImplTracking;
        
        try{
            ImplTracking = new Implementation_tracking__c();
            ImplTracking.Implementation_Record_ID__c = OrderId;
            ImplTracking.Account_Legal_Name__c =AccountId;
            //ImplTracking.Name
            //ImplTracking.Name = 'Test';
            //ImplCase.Status = 'Draft';
            //ImplCase.EffectiveDate = Date.today();
            
            if(doInsert)
                insert ImplTracking;
        }
        catch(Exception ex){
            System.debug('Create Implementation Tracking Exception occured' +ex.getMessage());
        }
        System.debug(ImplTracking);
        return ImplTracking;
    }
    
    public static ID_Cards__c createIdCards(Id implTrack, boolean doInsert){
       ID_Cards__c idCard;
        
        try{
            idCard = new ID_Cards__c();
            idCard.Implementation_Tracking_ID__c = implTrack;
            
            if(doInsert)
                insert idCard;
        }
        catch(Exception ex){
            System.debug('Create ID_Card__c Exception occured' +ex.getMessage());
        }
        System.debug(idCard);
        return idCard;
    }
    
    
    public static QuoteLineItemRates__c  createQLIRates(Id qliId, String rateId, Boolean doInsert){
        QuoteLineItemRates__c  qliRate;
           
        try{
            qliRate = new QuoteLineItemRates__c ();
            qliRate.Rate_Id__c = rateId;
            qlirate.QuoteLineItem__c = qliId;
            
            if(doInsert)
            insert qliRate;
        }
        catch(Exception ex){
            System.debug('Create QLIRate Exception occured' +ex.getMessage());
        }
        System.debug(qliRate);
        return qliRate;
    }
    
    public static Group_Plan_Design__c createGrpPlanDesign(String groupId, String qliId, String status, Boolean doInsert){
        Group_Plan_Design__c grpPlanDesign;

        try{
            grpPlanDesign = new Group_Plan_Design__c();
            grpPlanDesign.QuoteLineItem_Record_ID__c =qliId ;
            grpPlanDesign.Group__c = groupId;
            grpPlanDesign.Employee_category__c = status;
            grpPlanDesign.Is_Active_Indicator__c = true;
                
            if(doInsert)
            insert grpPlanDesign;
        }
        catch(Exception ex){
         System.debug('Create Group Plan Design Exception occured' +ex.getMessage());   
        }
        return grpPlanDesign;
    }
    
    public static Contact createContact(String accId, String RecordTypeName, String lastName, Boolean doInsert){
        Contact con;      
        try{
            con = new Contact();
            con.AccountId = accId; 
            String recTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
            con.RecordTypeId = recTypeId;
            con.LastName = lastName;
            con.FirstName = 'Test';
            con.Email = 'testContact@anthem.com';
            
            if(doInsert)
            insert con;      
        }
        catch(Exception ex){
           System.debug('Create Contact Exception occured' +ex.getMessage());   
        }
        return con;
    }
    
    public static ContactRelationShip__c createConRelationship(String accId, String contactId, String RecordTypeName, String contactType, Boolean doInsert){
        ContactRelationShip__c conRelation;
        try{
            conRelation = new ContactRelationShip__c();
            conRelation.Account__c = accId;
            conRelation.Contact__c = contactId;
            String recTypeId = Schema.getGlobalDescribe().get('ContactRelationShip__c').getDescribe().getRecordTypeInfosByName().get(RecordTypeName).getRecordTypeId();
            conRelation.RecordTypeId = recTypeId;
            conRelation.Contact_Type__c = contactType;
            conRelation.Start_Date__c = System.today();
            conRelation.EndDate__c = System.today()+20;
            conRelation.EffectiveDate__c = System.today();
            
            if(doInsert)
             insert conRelation;   
        }
        catch(Exception ex){
           System.debug('Create Contact Relationship Exception occured' +ex.getMessage()); 
        }      
        return conRelation;
    }
    
    public static Brokerage_and_Consultant1__c createBrokerConsultant1(String accId, String oppId, String brokerAccountId, String brokerConId, String lob, Boolean doInsert){
        Brokerage_and_Consultant1__c brokerCons; 
        try{
            brokerCons = new Brokerage_and_Consultant1__c();
            brokerCons.Account__c = accId;
            brokerCons.Opportunity__c = oppId;
            brokerCons.Brokerage__c = brokerAccountId;
            brokerCons.Consultant__c = brokerConId;
            brokerCons.Line_of_Business__c = lob;
            brokerCons.Brokerage_Effective_Date__c = System.today();
            
            if(doInsert)
                insert brokerCons;
        }
        catch(Exception ex){
            System.debug('Create Broker Consultant1 method Exception occured' +ex.getMessage());
        }
        return brokerCons;
    }
    
    public static Broker_Consultant_Commissions1__c createBrokerConsCommission1(String brokerConsultant1Id, String consultantId, String accId, String lob, Boolean doInsert){
        Broker_Consultant_Commissions1__c brokerConsComm;
        
        try{
            brokerConsComm = new Broker_Consultant_Commissions1__c();
            brokerConsComm.BrokerageAndConsultant__c = brokerConsultant1Id; 
            brokerConsComm.Contact_Relationship__c = consultantId;
            brokerConsComm.Commission_Percentage__c = 20;
            brokerConsComm.Line_of_Business__c = lob;
            brokerConsComm.Account__c = accId;
            
            if(doInsert)
                insert brokerConsComm;
        }
        catch(Exception ex){
             System.debug('Create Broker Consultant Commission1 method Exception occured' +ex.getMessage());
        }
        return brokerConsComm;
    }
    
    public static Sales_Compensation__c createSalesCompensation(String oppId, String lob, Boolean doInsert){
        Sales_Compensation__c salesComp;
        try{
            salesComp = new Sales_Compensation__c();
            salesComp.Opportunity__c = oppId;
            salesComp.Product_Type__c = lob;
            
            if(doInsert)
                insert salesComp;
        }
        catch(Exception ex){
           System.debug('Create Sales Compensation method Exception occured' +ex.getMessage()); 
        }
        return salesComp;
    }
    
    public static Internal_Broker__c createAgent(String salesCompId, String type, String lob, String repNumber, Boolean doInsert){
        Internal_Broker__c agent;
        try{
            agent = new Internal_Broker__c();
            agent.Sales_Comp_Master__c = salesCompId;
            agent.Type__c = type;
            agent.Effective_Date__c = System.today();
            agent.Line_of_Business__c = lob;
            agent.Term_Date__c = System.today()+100;
            agent.Rep_Num__c = repNumber;
            agent.Split_Percentage__c = 20;
            agent.Sales_Rep__c = UserInfo.getUserId();
            
            if(doInsert)
                insert agent;
        }
        catch(Exception ex){
            System.debug('Create agent method Exception occured' +ex.getMessage()); 
        }
        return agent;
    }
    
    public static Invoices_Local__c createInvoice(String accId, String conId, String grpId, Boolean doInsert){
        Invoices_Local__c invoice;
        try{
           invoice = new Invoices_Local__c();
           invoice.Account_Legal_Name__c =  accId;
           invoice.Billing_Contact__c = conId;
           invoice.Invoice_Effective_Date__c = System.today();
           invoice.Invoice_Cancel_Date__c = System.today()+100;
           invoice.Group__c = grpId;
           if(doInsert)
              insert invoice; 
        }
        catch(Exception ex){
            System.debug('Create Invoice method Exception occured' +ex.getMessage());
        }
        return invoice;
    }
    
    public static Billing_Arrangement_Local__c createBillingArrangement(String invoiceId, String lob, Boolean doInsert){
        Billing_Arrangement_Local__c billArrgmnt;
        try{
           billArrgmnt = new Billing_Arrangement_Local__c();
           billArrgmnt.Invoice_Record_ID__c = invoiceId;
           billArrgmnt.Product_LOB_for_BA__c = lob; 
           if(doInsert)
              insert billArrgmnt;  
        }
        catch(Exception ex){
             System.debug('Create Bill Arrangement method Exception occured' +ex.getMessage());
        }
        return billArrgmnt;
    }
    
    public static vlocity_ins__AttributeAssignment__c createAttributeAssgnmnt(String prodId, String attributeName, String value, Boolean doInsert){
        vlocity_ins__AttributeAssignment__c attrb;
        try{
          attrb = new  vlocity_ins__AttributeAssignment__c();
          attrb.vlocity_ins__ObjectId__c = prodId;
          attrb.vlocity_ins__AttributeName__c = attributeName;
          attrb.vlocity_ins__Value__c = value;
            
            if(doInsert){
                insert attrb;
            }  
        }
        catch(Exception ex){
             System.debug('Create Attribute Assignment method Exception occured' +ex.getMessage());
        }
        return attrb;
    }
    
    public static ServiceProviderRelationship__c createSrvcPrvdrRltnshp(String accId, String contctId, String vendorType, Boolean doInsert){
        ServiceProviderRelationship__c srvProvRltnshp;
          srvProvRltnshp = new  ServiceProviderRelationship__c();
          srvProvRltnshp.Account__c = accId;
          srvProvRltnshp.Contact__c = contctId;
          srvProvRltnshp.VendorType__c = vendorType;
         
            if(doInsert){
                insert srvProvRltnshp;
            }  
        return srvProvRltnshp;
    }
    
     public static Eligibility__c createEligibility(String implCaseId, String grpId, Boolean doInsert){
        Eligibility__c eligibility;
          eligibility = new  Eligibility__c();
          eligibility.Implementation_Record_ID__c = implCaseId;
          eligibility.Group__c = grpId;
         
            if(doInsert){
                insert eligibility;
            }  
        return eligibility;
    }
    
     public static Account_Preferences__c createGrpPreferences(String accId, Boolean doInsert){
        Account_Preferences__c grpPref;
          grpPref = new  Account_Preferences__c();
          grpPref.Account_Legal_Name__c = accId;
         
            if(doInsert){
                insert grpPref;
            }  
        return grpPref;
    }
    
     public static Department_Code__c createDepartmntCode(String accId, String deptmtCode, Boolean doInsert){
        Department_Code__c depCode;
          depCode = new  Department_Code__c();
          depCode.Account_Legal_Name__c = accId;
          depCode.Department_Code__c = deptmtCode;
            if(doInsert){
                insert depCode;
            }  
        return depCode;
    }
    
    public static void loadCustomSettings(){
       try{
           QLI_Child_Objects__c setting = new QLI_Child_Objects__c();
            setting.Field_Name__c = 'QuoteLineItem__c';
            setting.Object_Name__c = 'QuoteLineItemRates__c';
            setting.Name='QLI Rates Object';
            insert setting;
        }
        catch(Exception ex){
            System.debug('Error Occured While Loading custom settings' +ex.getMessage());
        }
    }
}