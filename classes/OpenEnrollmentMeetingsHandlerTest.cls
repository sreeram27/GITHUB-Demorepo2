@isTest
public class OpenEnrollmentMeetingsHandlerTest{


   public static testmethod  void testDataMethod () {
     
        Account acctRec = new Account();
        acctRec.Name = 'Open Enrollment';
        acctRec.Anthem_Entity__c = 'National Accounts';
        acctRec.Region__c = 'Central';
        insert acctRec;
        
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test Central';
        cnt.firstname='test';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Central';
        cnt.Email='test@test.com';
        cnt.Active__c=true;
        insert cnt;
        
        
        
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;       
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
        meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453'; 
        
       
        
        insert meetRec;
        List<Open_Enrollment_Meetings__c> oemList = [Select Anthem_Entity__c,Account_Region__c,Account__c,Plan_Type__c,Name,Source__c,OE_Coordinator_Contact__c,Request_is_from__c,Performance_Guarantees__c,Performance_Guarantees_Comments__c,Client_Arrangement__c,Sole_Carrier_or_Multi_Carriers__c,Client_Drivers_Issues_Risks__c,Member_Customer_Service_Telephone__c
                                                     from Open_Enrollment_Meetings__c]; 
        OpenEnrollmentMeetingsHandler.assignOECoordinator(oemList, acctRec.Id );
       
      
        }
        
     public static testmethod  void testDataMethod2 () {
     
        Account acctRec = new Account();
        acctRec.Name = 'Open Enrollment 2';
        acctRec.Anthem_Entity__c ='Labor and Trust';
        acctRec.Region__c = 'Central';
        insert acctRec;
        
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test Central';
        cnt.firstname='test';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Labor Accounts';
        cnt.Email='test@test.com';
        cnt.Active__c=true;
        insert cnt;
        
        
        
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;       
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
        meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453'; 
        
       
        
        insert meetRec;
        List<Open_Enrollment_Meetings__c> oemList = [Select Anthem_Entity__c,Account_Region__c,Account__c,Plan_Type__c,Name,Source__c,OE_Coordinator_Contact__c,Request_is_from__c,Performance_Guarantees__c,Performance_Guarantees_Comments__c,Client_Arrangement__c,Sole_Carrier_or_Multi_Carriers__c,Client_Drivers_Issues_Risks__c,Member_Customer_Service_Telephone__c
                                                     from Open_Enrollment_Meetings__c]; 
        OpenEnrollmentMeetingsHandler.assignOECoordinator(oemList, acctRec.Id );
       
      
        }
        
        public static testmethod  void testDataMethod3 () {
     
       /* Account acctRec = new Account();
        acctRec.Name = 'Open Enrollment 3';
        acctRec.Anthem_Entity__c ='Local/Large Group';
        acctRec.Region__c = 'Central';
        acctRec.Situs_State__c='Georgia';
        acctRec.WGS_MBU_Code__c='GHG00000-SPEC BCBSGA';
        acctRec.Submarket__c='Atlanta';
        acctRec.Vendor_Referral__c='N';
        insert acctRec; */
        
        Account acctRec = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'Georgia',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West',
                                Submarket__c='Atlanta'
                                );
        
        insert acctRec;
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test Central';
        cnt.firstname='test';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Georgia';
        cnt.Email='test@test.com';
        cnt.Active__c=true;
        insert cnt;
        
        
        
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;       
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
        meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453'; 
        
       
        
        insert meetRec;
        List<Open_Enrollment_Meetings__c> oemList = [Select Anthem_Entity__c,Situs_State__c,Submarket__c,Account_Region__c,Account__c,Plan_Type__c,Name,Source__c,OE_Coordinator_Contact__c,Request_is_from__c,Performance_Guarantees__c,Performance_Guarantees_Comments__c,Client_Arrangement__c,Sole_Carrier_or_Multi_Carriers__c,Client_Drivers_Issues_Risks__c,Member_Customer_Service_Telephone__c
                                                     from Open_Enrollment_Meetings__c]; 
        OpenEnrollmentMeetingsHandler.assignOECoordinator(oemList, acctRec.Id );
       
      
        }
        
        public static testmethod  void testDataMethod4() {
     
       /* Account acctRec = new Account();
        acctRec.Name = 'Open Enrollment 3';
        acctRec.Anthem_Entity__c ='Local/Large Group';
        acctRec.Region__c = 'Central';
        acctRec.Situs_State__c='Georgia';
        acctRec.WGS_MBU_Code__c='GHG00000-SPEC BCBSGA';
        acctRec.Submarket__c='Atlanta';
        acctRec.Vendor_Referral__c='N';
        insert acctRec; */
        
        Account acctRec = new Account( RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Customer').getRecordTypeId(),
                                Name = 'Test-acc1',
                                Group_Size__c = '51 - 99',
                                Situs_State__c = 'California',
                                Mailing_Address_Same_as_Physical_Address__c = true,
                                BillingStreet = '200 Main Street',
                                BillingPostalCode = '80202',
                                BillingCity = 'Denver',
                                BillingCountry = 'UnitedStates',
                                BillingState = 'CO',
                                ShippingStreet = '26',
                                ShippingCity = 'Ballar',
                                ShippingState = 'Georgea',
                                ShippingPostalCode = '10065',
                                ShippingCountry = 'USA',
                                Physical_County__c = 'NEW YORK',
                                Anthem_Entity__c = 'Local/Large Group',
                                Region__c = 'West',
                                Submarket__c='Strategic'
                                );
        
        insert acctRec;
        //Create contact
        Contact cnt=new Contact();
        cnt.lastname='Test Central';
        cnt.firstname='test';
        cnt.AccountId=acctRec.Id;
        cnt.RecordTypeID=Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Facilitator Contact').getRecordTypeId();
        cnt.Facilitator_Type__c='OE Coordinator';
        cnt.Region_Location__c='Strategic Accounts';
        cnt.Email='test@test.com';
        cnt.Active__c=true;
        insert cnt;
        
        
        
        Open_Enrollment_Meetings__c meetRec = new Open_Enrollment_Meetings__c();
        meetRec.Account__c = acctRec.id;       
        meetRec.Plan_Type__c = 'ANC Dental';        
        meetRec.Name='test Meeting';
        meetRec.Source__c='Georgia';
        meetRec.OE_Coordinator_Contact__c=cnt.id;
        meetRec.Plan_Type__c= 'ANC Vision'; 
        meetRec.Request_is_from__c='Commercial Medical';  
        meetRec.Performance_Guarantees__c = 'Yes';
        meetRec.Performance_Guarantees_Comments__c='Test Performance comment';
        meetRec.Client_Arrangement__c='Renewal - Growth Opportunity';
        meetRec.Sole_Carrier_or_Multi_Carriers__c='Sole Carrier';
        meetRec.Client_Drivers_Issues_Risks__c='Test';
        meetRec.Member_Customer_Service_Telephone__c='3534353453'; 
        
       
        
        insert meetRec;
        List<Open_Enrollment_Meetings__c> oemList = [Select Anthem_Entity__c,Situs_State__c,Submarket__c,Account_Region__c,Account__c,Plan_Type__c,Name,Source__c,OE_Coordinator_Contact__c,Request_is_from__c,Performance_Guarantees__c,Performance_Guarantees_Comments__c,Client_Arrangement__c,Sole_Carrier_or_Multi_Carriers__c,Client_Drivers_Issues_Risks__c,Member_Customer_Service_Telephone__c
                                                     from Open_Enrollment_Meetings__c]; 
        OpenEnrollmentMeetingsHandler.assignOECoordinator(oemList, acctRec.Id );
       
      
        }
        
      
    
}