/***************************************************************************
* @Mod : 10/15/2019
* @Author : Mehaboob
* @description : added createOpenEnrollment,createOpenEnrollmentMeeting,createContact methods 
* @comments : Modified this class as part of PRDCRM-43211
**************************************************************************/

/***************************************************************************
* @Mod : 10/24/2019
* @Author : Poonam Goturi
* @description : added createOEAmbassadorVolunteer method, added parameters to contact method
* @comments : Modified this class as part of PRDCRM-43212
**************************************************************************
* @Mod : 10/30/2019
* @Author : Mehaboob
* @description : added 'Name=name+String.valueOf(i)' in method createOpenEnrollment
* @comments : Modified this class as part of Story PRDCRM-45610 and 43212 .
         
**************************************************************************

* @Mod : 12/05/2019
* @Author : Poonam
* @description : Removed two parameters(Anthem entity, Region) from Account method
* @comments : Modified this class as part of Story PRDCRM-43214
**************************************************************************

* @Mod : 12/23/2019
* @Author : Neha Prasad
* @description : Added 3 New fields "Voluntary_Enrollment_Consultant__c", "GRS_Account_Executive__c" and "GRS_ESR__c" in the account rollup.
* @comments : Modified this class as part of Story PRDCRM-47935

**************************************************************************
* @Mod : 02/04/2020
* @Author : Ravideep Singh 
* @description : Added methods for creation of underwriting records.
* @comments : Modified this class as part of Story PRDCRM-49125       
**************************************************************************/

/**************************************************************************
* @Mod : 03/06/2020
* @Author : Ravideep Singh 
* @description : Added methods for creation of PG Catalog Item records.
* @comments : Modified this class as part of Story PRDCRM-51773       
**************************************************************************/
@istest 
public with sharing class TestDataFactory {

//*** Account ***
  // Account with SIC
  public static List<Account> createAccountSICList(Integer recordCount, String Name, String Street, String City, String State, String ZIP, String country, String stateCode){
    List<Account> accounts = new List<Account>();
    Account account;
    for(Integer i = 0; i < recordCount; i++){
      account = new Account(
        Name = Name + ' ' + i,
        BillingStreet = street,
        BillingCity = city,
        BillingState = state,
        BillingPostalCode = ZIP,
        BillingCountry = country,
        ShippingStreet = street,
        ShippingCity = city,
        ShippingState = state,
        ShippingPostalCode = Zip,
        ShippingCountry = country
      );
      accounts.add(account);
    }
    return accounts;
  }
  
//*** Opportunity ***
  public static List<Opportunity> createOpportunityList(Integer recordCount,string name,Account acc) {
  Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
   List<Opportunity> opportunities = new List<Opportunity>();
    Opportunity opportunity;
    for(Integer i = 0; i < recordCount; i++){
      opportunity = new opportunity(
        Name = name,
        StageName = 'Closed Won',
        //GAP_Plan_in_Place__c = GapPlaninPlace,
        //GAP_Plan_Proposed__c = GapPlanProposed,
        //Out_to_Bid_Reason__c = outToBidReason,
        
        //Effective_Date__c = effectiveDate,
        //CloseDate = system.today(),
        CloseDate = Date.newinstance(system.today().year(),system.today().month(),1),
        Probability=100,
        AccountId = acc.Id,
        Received_Date__c=system.today(),
        recordtypeid=devRecordTypeId
      );
      opportunities.add(opportunity);
    }
    return opportunities;
  }
  

  
  //*** OpportunityTeamMember ***
 public static List<OpportunityTeamMember> createOpportunityTeam(Integer recordCount, Opportunity opp){
    List<OpportunityTeamMember> oppTeam = new List<OpportunityTeamMember>();
    OpportunityTeamMember oppMem;
    for(Integer i = 0; i < recordCount; i++){
      oppMem = new OpportunityTeamMember(
        UserId = UserInfo.getUserId(),
        TeamMemberRole = 'Underwriter',
        OpportunityId = opp.id 
      );
      oppTeam.add(oppMem);
    }
    return oppTeam;
  }
  
  
   //*** Product2 ***
  public static List<Product2> createProduct(string Name,Integer recordCount){
    List<Product2> prodlist= new List<Product2>();
    Product2 prod;
    for(Integer i = 0; i < recordCount; i++){
      prod= new Product2(
        Name= Name,
        Underwriting_Product_Code__c='525',
        Product_Type__c='Medical'
      );
      prodlist.add(prod);
    }
    return prodlist;
  }
  
     //*** QuoteLineItem ***
  public static List<QuoteLineItem > QuoteLineItem(string Name,Integer recordCount,Quote q,product2 p,PricebookEntry pb){
    List<QuoteLineItem> quotelineitemlist= new List<QuoteLineItem>();
    QuoteLineItem  qli;
    for(Integer i = 0; i < recordCount; i++){
      qli= new QuoteLineItem(Subscribers__c=12,
                             Network__c = 'Dental Net',
                            
                            QuoteId = q.Id,
                            Quantity = 1,
                            product2id=p.Id,
                           // prodLine.PricebookEntryId = stdPBE.id;
                            UnitPrice = 1,
                            Funding__c='FI',
                            Financing__c='Fully Insured',
                            Line_of_Business__c= 'Medical',
                            Involvement_Type__c='Slice',
                            
                  PricebookEntryId=pb.id
      );
      quotelineitemlist.add(qli);
    }
    return quotelineitemlist;
  }
  
      //*** Quote***
  public static List<Quote> Quote(string Name,Integer recordCount,Opportunity opp){
   Id pricebookId = Test.getStandardPricebookId();
    List<Quote> quotelist= new List<Quote>();
    Quote  q;
    for(Integer i = 0; i < recordCount; i++){
      q= new Quote(Name = Name,
           
              OpportunityId = opp.Id,
              Pricebook2Id = pricebookId 
      );
      quotelist.add(q);
    }
    return quotelist;
  }
  
      //*** PricebookEntry***
  public static List<PricebookEntry> PricebookEntry(Integer recordCount,Product2 p){
  Id pricebookId = Test.getStandardPricebookId();

    List<PricebookEntry> Pricebookentrylist= new List<PricebookEntry>();
    PricebookEntry pbe;
    for(Integer i = 0; i < recordCount; i++){
      pbe= new PricebookEntry(
            product2id=p.id,
            pricebook2id=pricebookId,
            unitprice=1,isactive=true);
      Pricebookentrylist.add(pbe);
    }
    return Pricebookentrylist;
  }
  
    //  User data
   public static List<User> createUserData(Integer recordCount, String profileName, String federationId) {
        List<User> userList = new List<User>();
        User u;
        Profile p = [SELECT Id FROM Profile WHERE Name=:profileName limit 1]; 
        
        for(Integer i = 0; i < recordCount; i++){
            u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, FederationIdentifier = federationId, USId__c = federationId, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+Math.random()+'@testorg.com',Rep_ID_Code__c=federationId);
            userList.add(u);
        }
        
        return userList;
    }
    // Group Creation
     public static Group__c createGroup(Id accId, Boolean doInsert){
        Group__c grp; 
        try{
            grp = new Group__c();
            grp.Name = 'Test Group';
            grp.Account__c = accId;
            //grp.Account__c = acc.Id;
            grp.ClaimSystem__c = 'WGS 2.0';
            
            if(doInsert)
            insert grp;
        }
         
        catch(Exception ex){
             System.debug('Group Insert Exception occured' +ex.getMessage());
        }
        
      return grp;  
    }
    
    public static Next_Number_Utility__c createnextnum(Integer recordCount,string situsState,Integer lastNumber,Integer maxVal,string CurrentStatePrefix ){
        Next_Number_Utility__c num;
       for(Integer i = 0; i < recordCount; i++){
           num=new Next_Number_Utility__c(Name = situsState, Last_Number_Used__c = lastNumber, Max_Value__c = maxVal,Current_State_Prefix__c = CurrentStatePrefix);
       }
            
        return num;
    }
    public static List<Order> createOrder(Integer recordCount,String groupId,String accountId,String userId,String quoteId){
        List<Order> orderList=new List<Order>();
        for(Integer i=0;i<recordCount;i++){
            orderList.add(new Order(Group_Name__c =groupId, AccountId =accountId, EffectiveDate=System.today(),Status = staticVariableClass.Draft,
                              User_Group__c =staticVariableClass.LocalNewBusiness,Implementation_Case_Name__c = staticVariableClass.AIMTesting01, 
                              Discovery_Call_Desired__c =staticVariableClass.UpsellYes,Implementation_Status__c = staticVariableClass.ReadyforImps, 
                              Implementation_Effective_Date__c=System.today(),Assigned_Implementer__c =userId, QuoteId=quoteId)); 
        }
    return orderList;
    }

    public static List<Implementation_Tracking__c> createTracking(Integer recordCount,String recTypeId, String ordId){
        List<Implementation_Tracking__c> impTrackList = new List<Implementation_Tracking__c>();
        for(Integer i=0;i<recordCount;i++){
            impTrackList.add(new Implementation_Tracking__c(RecordTypeId = recTypeId,Implementation_Record_ID__c = ordId));
        }
        return impTrackList;
    }
    public static List<ID_Cards__c> createIdCard(Integer recordCount,String trackId){
        List<ID_Cards__c> idCardList = new List<ID_Cards__c>();
        for(Integer i=0;i<recordCount;i++){
            idCardList.add(new ID_Cards__c(Implementation_Tracking_ID__c = trackId,Stage__c=UtilConstants.REVIEW_DONE_04));
        }
        return idCardList;
    }
    public static List<Dental_Complete__c> createDentalSme(Integer recordCount,String trackingId){
        List<Dental_Complete__c> dentalRecList = new List<Dental_Complete__c>();
        for(Integer i=0;i<recordCount;i++){
            dentalRecList.add(new Dental_Complete__c(Implementation_Tracking_ID__c = trackingId));
        }
        return dentalRecList;
    }
    public static List<Life_and_Disability__c> createLifeSme(Integer recordCount,String trackingId){
        List<Life_and_Disability__c> lifeRecList = new List<Life_and_Disability__c>();
        for(Integer i=0;i<recordCount;i++){
            lifeRecList.add(new Life_and_Disability__c(Implementation_Tracking_ID__c = trackingId));
        }
        return lifeRecList;
    }
    public static List<Vision__c> createVisionSme(Integer recordCount,String trackingId){
        List<Vision__c> visionRecList = new List<Vision__c>();
        for(Integer i=0;i<recordCount;i++){
            visionRecList.add(new Vision__c(Implementation_Tracking__c = trackingId));
        }
        return visionRecList;
    }
    /*
    @description : Create Contact records .Added this method as part of PRDCRM-43211
    */
    public static List<Contact> createContact(Integer recordCount,String firstname,String lastname,Account acc,Id recordTypeID,String facType,String regLocation,String email,Boolean active, Integer selForFacTally, Integer noThanksTally){
        List<Contact> contactList = new List<Contact>();
        for(Integer i=0;i<recordCount;i++){
            contactList.add(new Contact (
              Firstname=firstname,
              Lastname=lastname,
              AccountId=Acc.Id,
              RecordTypeID=recordTypeID,
              Facilitator_Type__c=facType,
              Region_Location__c=regLocation,
              Email=email,
              Active__c=active,
              OE_Amb_Selected_Current_Year_Tally__c=selForFacTally,
              OE_Amb_No_Thanks_Current_Year_Tally__c=noThanksTally
            ));
        }
        return contactList;
    }   
    /*
    @description : Create Open Enrollment Meeting records .Added this method as part of PRDCRM-43211
    */
    public static List<Open_Enrollment_Meetings__c> createOpenEnrollmentMeeting(Integer recordCount,String name,Account acc,String source,Contact oeCordinator,String planType,String requestisfrom,String performanceGuarantees,String pgComments,String clientArrangement,String soleCarrierORMultiCarriers,String clientDriversIssuesRisks,String memberCustomerServiceTelephone, String dressCodeForEvent){
        List<Open_Enrollment_Meetings__c > openEnrMeetingList = new List<Open_Enrollment_Meetings__c >();
        for(Integer i=0;i<recordCount;i++){
            openEnrMeetingList.add(new Open_Enrollment_Meetings__c(
             
             Name=name,
             Account__c = acc.Id,
             Source__c=source,
             OE_Coordinator_Contact__c=oeCordinator.id,          
             Plan_Type__c =planType,
             Request_is_from__c=requestisfrom,
             Performance_Guarantees__c = performanceGuarantees,
             Performance_Guarantees_Comments__c=pgComments,
             Client_Arrangement__c=clientArrangement,
             Sole_Carrier_or_Multi_Carriers__c=soleCarrierORMultiCarriers,
             Client_Drivers_Issues_Risks__c=clientDriversIssuesRisks,
             Member_Customer_Service_Telephone__c=memberCustomerServiceTelephone,
             Dress_Code_for_Event__c = dressCodeForEvent     
            ));
        }
        return openEnrMeetingList;
    }
    /*
    @description : Create Open Enrollment records .Added this method as part of PRDCRM-43211
    */
    public static List<SFDC_Volunteer_Event__c > createOpenEnrollment(Integer recordCount,String name,Open_Enrollment_Meetings__c oem,String bilingual,Boolean buddyProgramEligible,String mStreet,String mCity,String mState,String mZipCode,String session1ST,String session1ET,Date mDate,String recrFacNeeded,String mType,Integer expEmployees,Boolean datesFlexible,String mStage,String localAMBonly,Decimal locLat,Decimal locLong,Boolean facBeingRecr,Boolean recrConsltnt,Boolean facSecured, Account accRec, String mStatus, Contact oeCoordinator){
        List<SFDC_Volunteer_Event__c  > openEnrollmentList = new List<SFDC_Volunteer_Event__c  >();
        for(Integer i=0;i<recordCount;i++){
            openEnrollmentList.add(new SFDC_Volunteer_Event__c (
               
               Name=name+String.valueOf(i),
               OE_Grouping__c=oem.Id,
               bilingual__c =bilingual,
               Buddy_Program_Eligible__c=buddyProgramEligible,
               meeting_Street__c =mStreet,
               meeting_city__c =mCity,
               meeting_state__c =mState,
               Meeting_Zip_Code__c=mZipCode,
               Session_1_Start_Time__c = session1ST,
               Session_1_End_Time__c =session1ET,
               Date__c =mDate,
               Recruitment_of_Facilitator_Needed__c=recrFacNeeded,
               Meeting_Type__c = mType,
               Expected_of_Employees__c = expEmployees,
               Dates_Flexible__c = datesFlexible,
               Meeting_Stage__c =mStage,
               Local_Ambassador_Only__c =localAMBonly,
               Location__Latitude__s = locLat,
               Location__Longitude__s = locLong,
               Facilitator_Being_Recruited__c =facBeingRecr,
               Recruit_Consultant__c = recrConsltnt,
               Facilitator_Secured__c = facSecured,
               Account__c = accRec.id,
               Meeting_Status__c = mStatus,
               OE_Coordinator_Contact__c = oeCoordinator.id
               //Submit__c=Submit
            ));
        }
        return openEnrollmentList;
    }
    
    /*
    @description : Create OE Ambassador volunteer records .Added this method as part of PRDCRM-43212
    */
    public static List<SFDC_Volunteer_Participant__c> createOEAmbassadorVolunteer(Integer recordCount, SFDC_Volunteer_Event__c openEnrollment, Contact oeAmbVolunteer, Boolean selectedForFacilitator, Boolean thanksButNoThanks){
        List<SFDC_Volunteer_Participant__c> oeAmbassdorVolunteerList = new List<SFDC_Volunteer_Participant__c>();
        for(Integer i=0;i<recordCount;i++){
            oeAmbassdorVolunteerList.add(new SFDC_Volunteer_Participant__c(
                Volunteer_Event__c = openEnrollment.id,
                OE_Ambassador_Volunteer__c = oeAmbVolunteer.id,
                Selected_For_Facilitator__c = selectedForFacilitator,
                Thanks_but_No_Thanks__c = thanksButNoThanks
            ));
        }
        return oeAmbassdorVolunteerList;
    }
    
    
    /**
     * @description This methood is used to return  a Product_HPCC_Codes__c .
     * @param  objsetup trigger Switch passed.
     * @return objsetup (vlocity_ins__TriggerSetup__c)  
    */
    public static vlocity_ins__TriggerSetup__c  createTriggerSetup(vlocity_ins__TriggerSetup__c objsetup){
        objsetup.vlocity_ins__IsTriggerOn__c  = true;
        return objsetup;
    }
    
    /**
     * @description This methood is used to return  a Product_HPCC_Codes__c .
     * @param objProHPCC ProductHpcccodes custom setting object
     * @param parentProductId Id of ParentProductId 
     * @return objProHPCC (Product_HPCC_Codes__c) 
    */
    public static Product_HPCC_Codes__c createProductHPCCCodes(Product_HPCC_Codes__c objProHPCC, Id parentProductId){
        
        objProHPCC.Name = staticVariableClass.HPCCCODE_PRODUCT_NAME ;
        objProHPCC.HPCC_Code__c= staticVariableClass.HPCCCODE;
        objProHPCC.Funding_Type__c=staticVariableClass.FUNDING_TYPE;
        objProHPCC.State__c=staticVariableClass.STATE;
        objProHPCC.Incentive_Type__c=staticVariableClass.INCENTIVE_TYPE_NA;
        objProHPCC.Minimum__c= 50; 
        objProHPCC.Parent_Id__c= parentProductId ;
        return objProHPCC;
    }
    /**
     * @description This methood is used to return  a productchildItem.
     * @param  objProdChildItem Object of ProductChildItem 
     * @param  parentProductId Id of the parentProduct 
     * @param  childProdId Id of childProduct
     * @return objProdChildItem (vlocity_ins__ProductChildItem__c)
    */
    public static vlocity_ins__ProductChildItem__c createProdChildItem(vlocity_ins__ProductChildItem__c objProdChildItem, Id parentProductId, Id childProdId ){
        objProdChildItem.Name = staticVariableClass.HPCCCODE_PRODUCT_NAME ;
        objProdChildItem.vlocity_ins__ChildLineNumber__c = staticVariableClass.CHILD_NUMBER;
        objProdChildItem.vlocity_ins__ChildProductId__c = childProdId ;
        objProdChildItem.vlocity_ins__CollapseHierarchy__c = false;
        objProdChildItem.vlocity_ins__IsOverride__c = false;
        objProdChildItem.vlocity_ins__IsRootProductChildItem__c = false;
        objProdChildItem.vlocity_ins__MaxQuantity__c = 99999.0;
        objProdChildItem.vlocity_ins__MaximumChildItemQuantity__c = 99999.0;
        objProdChildItem.vlocity_ins__MinQuantity__c = 0.0;
        objProdChildItem.vlocity_ins__MinimumChildItemQuantity__c = 0.0;
        objProdChildItem.vlocity_ins__ParentProductId__c = parentProductId;
        objProdChildItem.vlocity_ins__Quantity__c = 1.0;
        objProdChildItem.vlocity_ins__RelationshipType__c = staticVariableClass.RELATIONSHIP_TYPE;
        objProdChildItem.IsActive__c = false;
        objProdChildItem.vlocity_ins__IsOptional__c = false;
        objProdChildItem.Incentive_Type_NA__c = staticVariableClass.INCENTIVE_TYPE_NA;
        return objProdChildItem;
    }
  
    /**
     * @description Factory Method to create test account team records 
     * @author 
     * @date        Created: 13-Dec-2019
     * @param       accountId - Parent Account Id
     * @param       teamRole - Account Team Member Role
     * @param       userId - User record id
     * @return      Returns Account Team Member Record
     */
    public static AccountTeamMember getAccountTeamMember(Id accountId, String teamRole, Id userId)
    {
        AccountTeamMember teamMember = new AccountTeamMember();
        teamMember.AccountId = accountId;
        teamMember.TeamMemberRole = teamRole;
        teamMember.UserId = userId;
        return teamMember;
    }
    
    /**
     * @description Factory Method to create test underwriting records 
     * @author 
     * @date        Created: 4-Feb-2020
     * @param       name - name of account
     * @param       BillingStreet - street address
     * @param       SameAsPhysicalAddress - physical address same as billing
     * @param       BillingPostalCode - Zipcode
     * @param       name - name of account
     * @param       BillingCity - City
     * @param       BillingCountry - Country
     * @param       BillingState - State
     */
    public static Account createLGAccount(string name, string BillingStreet, boolean SameAsPhysicalAddress,string BillingPostalCode,string BillingCity,string BillingCountry, string BillingState, string PhysicalCountry)
     {
        account acc = new account();
        acc.recordtypeid = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId();
        acc.name = name;
        acc.BillingStreet = BillingStreet;
        acc.Mailing_Address_Same_as_Physical_Address__c = SameAsPhysicalAddress;
        acc.BillingPostalCode = BillingPostalCode;
        acc.BillingCity = BillingCity;
        acc.BillingCountry = BillingCountry;
        acc.BillingState = BillingState;
        acc.Physical_County__c = PhysicalCountry;
        return acc;
     }
     
     
    /**
     * @description Factory Method to create test underwriting records 
     * @author 
     * @date        Created: 4-Feb-2020
     * @param       accountId - Parent Account Id
     * @param       imptrackingId - parent implementation case id
     */
     public static Underwriting__c createUnderwriting(id imptrackingId)
     {
        Underwriting__c uw = new Underwriting__c();
        uw.Implementation_Tracking_ID__c = imptrackingId;
        return uw;
     }
     
     /**
     * @description Factory Method to create test PG Catalog Item records 
     * @author 
     * @date        Created: 6-March-2020
     * @param       pgtype - PG_Type__c of PG_Catalog_Item__c
     * @param       performancecategory - Performance_Category__c of PG_Catalog_Item__c
     * @param       contractcategory - Broad_Contract_Category__c of PG_Catalog_Item__c
     */
     public static PG_Catalog_Item__c createPGCatalogItem(string pgtype,string performancecategory,string contractcategory)
     {
        PG_Catalog_Item__c pgitem = new PG_Catalog_Item__c();
        pgitem.PG_Type__c = pgtype;
        pgitem.Performance_Category__c = performancecategory;
        pgitem.Broad_Contract_Category__c = contractcategory;
        pgitem.active__c = true;
        pgitem.sequence__c = 1;
        return pgitem;
     }
    
    /**
     * @description Factory Method to create test PG Request record
     * @author 
     * @date        Created: 12-March-2020
     */
    public static PG_Request__c  createPGRequestItem()
     {
        PG_Request__c pgRequest = new PG_Request__c();
        pgRequest.PG_Effective_Date__c = system.today();
        pgRequest.Account_Executive__c = UserInfo.getUserId();
        pgRequest.Underwriter_Name__c= UserInfo.getUserId();
        
        return pgRequest;
     }
    
    
    
  }