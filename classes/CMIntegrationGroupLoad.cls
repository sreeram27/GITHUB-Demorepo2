public class CMIntegrationGroupLoad {
		
    public static CMIntegrationRequest buildCMPayload(Order od, CMIntegrationRequest.cls_eventMetaData eventMetaData) {
    
        CMIntegrationRequest jsonCMPayload = new CMIntegrationRequest();
        jsonCMPayload.eventMetaData = eventMetaData;    
        if (od.Implementation_Type__c == CMIntegrationConstants.IMPLEMENTATION_TYPE_CHANGE) { // 'Change Request Off Cycle'
            // also build maintenance for preview
            buildMaintenance(jsonCMPayload, od);
        } 
        buildAccountInfo(jsonCMPayload, od);
        
        return jsonCMPayload;
    }
    
    /*
    The method is used to populate the maintenance section
    */
    public static void buildMaintenance(CMIntegrationRequest jsonCMPayload, Order od){  
        // avoid null point
        if (String.isEmpty(od.Maintenance_Reason_Customer_Master__c)) return;
        
		List<CMIntegrationRequest.cls_maintenance> maintenanceList = new List<CMIntegrationRequest.cls_maintenance>();
        jsonCMPayload.maintenance = maintenanceList;
        
        Set<String> entitySet = new Set<String>();
        entitySet.add(CMIntegrationConstants.ENTITY_CUST);
        entitySet.add(CMIntegrationConstants.ENTITY_PARENTCUST);
        
        for(String s : od.Maintenance_Reason_Customer_Master__c.split(';')) {
            if(s !=  CMIntegrationConstants.ADD_PRODCT_MAINT && s != CMIntegrationConstants.RATE_ADJ_MAINT){
                for(String entity : entitySet){
                CMIntegrationRequest.cls_maintenance maintenance = new CMIntegrationRequest.cls_maintenance();
                maintenanceList.add(maintenance);
                maintenance.entity = entity;
                maintenance.change = s;
                }
        	}
            else{
                CMIntegrationRequest.cls_maintenance maintenance = new CMIntegrationRequest.cls_maintenance();
                maintenanceList.add(maintenance);
                maintenance.entity = CMIntegrationConstants.ENTITY_CUST;
                maintenance.change = s;
            }
        }    
	}
    
      public static void buildAccountInfo(CMIntegrationRequest jsonCMPayload, Order od){
    
        CMIntegrationRequest.cls_accountInfo accountInfo = new CMIntegrationRequest.cls_accountInfo();
        jsonCMPayload.accountInfo = accountInfo;
    
        String accId = od.accountId;
        // 11/25/2019 As Olivia confirmed, we don't want a parent to be sent, will use account itself
        // String accParentId = od.account.ParentId;
        String accParentId = accId;
        
        Set<String> accIdSet = new Set<String>();
        accIdSet.add(accId);
        if (accParentId != null) accIdSet.add(accParentId);

        // TODO inclulde account's fields here        
        Account acc = null;
        Account accParent = null;
        for(Account accTemp : [select Account_Email__c, Account_Name_DBA__c, Account_Status__c, Active_Renewal_Date__c, 
                               BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode, Cancel_Date__c, Eligible_Employees__c, 
                               Is_this_Group_subject_to_ERISA__c, WGS_MBU_Code__c, Month_underwriter_starts_renewal_process__c, 
                               Name, National_Care_Network_NCN__c, Pooled_Non_Pooled__c, Global_Customer_ID__c,
                               Original_Effective_Date__c, phone, ShippingCity, ShippingCountry, ShippingState, ShippingStreet, ShippingPostalCode,
                               Situs_State_Abbrev__c, Tax_ID__c, vlocity_ins__TerminationReason__c, Prefix_Account_ID__c,
                               Claims_Savings_Vendor__c, Vendor_Referral__c,EOC_Paperless_Option_Indicator__c, Sic__c, Sic__r.SIC_Code__c,
                               Account_Medical_Funding_Type__c, Program_Selection_Details__c, Work_location__c, Legal_Entity__c, ProbationaryPeriod__c
                               from account 
                               where id in : accIdSet]) {
            if (accTemp.id == accId) acc = accTemp;
            if (accTemp.id == accParentId) accParent = accTemp;
        }
        if (accParent == null) {
            accParent = acc;
            accParentId = accParent.id;
        }
        
        // get contact relationship list for both child and parent account
        List<ContactRelationship__c> contactRelationshipListChild = new List<ContactRelationship__c>();
        List<ContactRelationship__c> contactRelationshipListParent = new List<ContactRelationship__c>();
        
        // TODO inclulde contact relationship's fields here
        for(ContactRelationship__c cr : [select Contact__r.Name, Contact__r.LastName, Contact__r.FirstName, 
                                         Contact__r.MailingStreet, Contact__r.MailingCity,
                                         Contact__r.MailingState, Contact__r.MailingPostalCode, Contact__r.MailingCountry,
                                         Contact__r.vlocity_ins__MiddleName__c, Contact__r.Department, 
                                         Contact__r.Title, Contact__r.Primary_Contact__c,Contact__r.email,Contact__r.Phone,
                                         Account__c, Contact__c, Contact_Type__c, EffectiveDate__c 
                                         from ContactRelationship__c 
                                         where Account__c in :accIdSet]) {
            if (cr.Account__c == accId) {
                contactRelationshipListChild.add(cr);
            }
            if (cr.Account__c == accParentId) {
                contactRelationshipListParent.add(cr);
            }
            
        }
        // prepare data TODO add fields here
        Group__c grp = new Group__c();
        if (!String.isEmpty(od.Group_Name__c)) grp = [select id, Retro_Enrollment_Maintenance_Online__c,Retro_Enrollment_Maintenance_Electronic__c
                                                      from Group__c where id = :od.Group_Name__c];
        
        List<Account_Preferences__c> gpList = [select Does_Anthem_Generate_HCID__c, ASO_Newborn_Opt_Out_Indicator__c, Delinquency_Cancellation_Letter_Suppress__c, Washout_Code__c, 
                                             Certificate_of_creditable_coverage_suppr__c, Conversion_letter_suppression__c, Termination_letter_suppression__c,
                                             Opt_Out_of_LHO_URL_on_ID_Cards__c, Billing_System__c
                                             from Account_Preferences__c 
                                             where Account_Legal_Name__c = :accId];

        // build parentInfo
        buildParentInfo(jsonCMPayload, accParent, contactRelationshipListParent, od, grp, gpList);
        
        Set<String> teamRoleSet = new Set<String>();
        teamRoleSet.add(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_MANAGER); // 'Account Manager'
        teamRoleSet.add(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_EXECUTIVE); // 'Account Executive'
        teamRoleSet.add(CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_SERVICE_REPRESENTIVE); // 'Account Service Representative';
        teamRoleSet.add(CMIntegrationConstants.TEAMMEMBER_ROLE_SPECIALTY_SALES_ACCOUNT_REP); // 'Specialty Sales Account Rep'                                     
		teamRoleSet.add(CMIntegrationConstants.TEAMMEMBER_ROLE_UNDERWRITER); // 'Underwriter'                                     
        
		List<AccountTeamMember> accTeamList = [select TeamMemberRole, User.Sales_office_location__c, User.Rep_ID_Code__C
                                               from AccountTeamMember 
                                         	   where AccountId = :accId and TeamMemberRole in :teamRoleSet
                                               order by TeamMemberRole desc];
        // build customerInfo
        buildCustomerInfo(jsonCMPayload, acc, accParent, contactRelationshipListChild, od, grp, accTeamList, gpList);
        
        // build accountBillGroups
        buildAccountBillGroups(jsonCMPayload, acc.Id, od);
    }
    
        /*
    The method is used to populate the parentInfo section under Account info
    */
    public static void buildParentInfo(CMIntegrationRequest jsonCMPayload, Account accParent,
                                    List<ContactRelationship__c> contactRelationshipListParent, Order od, Group__c grp, 
                                    List<Account_Preferences__c> gpList){  
 
        CMIntegrationRequest.cls_accountInfo accountInfo = jsonCMPayload.accountInfo;
        accountInfo.parentInfo = new CMIntegrationRequest.cls_parentInfo();
        
        // ids section        
        accountInfo.parentInfo.ids = buildIds(accParent, true, od);
        
        // demographic section
        accountInfo.parentInfo.demographic = buildDemographic(accParent, od, contactRelationshipListParent, true);
   
        // status section
        accountInfo.parentInfo.status = new CMIntegrationRequest.cls_status();
        buildStatus(accountInfo.parentInfo.status, accParent);
        
        // notes section. Per disucsssion with Kishore on 11/12, parent does not need note
        // parent config        
        CMIntegrationRequest.cls_parentConfig parentConfig = new CMIntegrationRequest.cls_parentConfig();
        accountInfo.parentInfo.parentConfig = parentConfig;
        
        // legal entity
        accountInfo.parentInfo.parentConfig.legalEntity = buildLegalEntity(accParent, grp, od);
        
        // masterBusinessUnit
        CMIntegrationRequest.cls_masterBusinessUnit masterBusinessUnit = new CMIntegrationRequest.cls_masterBusinessUnit();
        accountInfo.parentInfo.parentConfig.masterBusinessUnit = masterBusinessUnit;
        
        masterBusinessUnit.code = accParent.WGS_MBU_Code__c;
        masterBusinessUnit.contractStateCode = accParent.Situs_State_Abbrev__c; //Situs_State__C;
       // masterBusinessUnit.fundingType = od.Opportunity.Funding__c;
        masterBusinessUnit.effectiveDate = String.valueOf(accParent.Original_Effective_Date__c);
                                        
		// marketSegmentBilling
		CMIntegrationRequest.cls_marketSegmentBilling marketSegmentBilling = new CMIntegrationRequest.cls_marketSegmentBilling();
		accountInfo.parentInfo.parentConfig.marketSegmentBilling = marketSegmentBilling;

		// marketSegmentBilling.marketSegment = 'Large Group';
		marketSegmentBilling.billingSystemPreference = gpList!= null && gpList.size() > 0 ? gpList[0].Billing_System__c :null; // TODO ?       
    }

  //  The method is to be reused to populate the ids section for both parentInfo and customerInfo
  
    public static List<CMIntegrationRequest.cls_ids> buildIds(Account acc, boolean forParent, Order od){
        List<CMIntegrationRequest.cls_ids> ids = new List<CMIntegrationRequest.cls_ids>();
        
        CMIntegrationRequest.cls_ids id1 = new CMIntegrationRequest.cls_ids();
        id1.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_SFDCCOM2; // 'SFDCCOM2'
        id1.name = CMIntegrationConstants.ID_NAME_ACCOUNTID; // 'accountID'
        id1.value = acc.id;
        ids.add(id1);

        //Populate WGS and Compass Id sections if respective groups are present
        if (!forParent) { // 'WGS 2.0'
             //Get the respective group numbers and claim systems from the map 
           List<AggregateResult> agrList = [SELECT Count(Id) cnt, Group__r.Name, Group__r.ClaimSystem__c
                                        	FROM QuoteLineItem
                                        	WHERE Group__r.ClaimSystem__c != null 
                                            AND QuoteId =: od.QuoteId
                                            AND ProductStage__c IN : CMIntegrationConstants.PRODUCT_STAGES
                                            GROUP BY Group__r.name, Group__r.ClaimSystem__c
                                        	ORDER By Group__r.ClaimSystem__c];
            
             if(agrList.size() >0){
                   for(AggregateResult agr: agrList){
                       String clmSys = (String)agr.get('ClaimSystem__c');
                       if(clmSys.equalsIgnoreCase(CMIntegrationConstants.CLAIM_SYSTEM_WGS)){
                           CMIntegrationRequest.cls_ids id2 = new CMIntegrationRequest.cls_ids();
            				id2.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_WGS; // 'WGS'
            				id2.name = CMIntegrationConstants.ID_NAME_CASEID; // 'caseId'
            				id2.value = (String)agr.get('Name');
            				ids.add(id2);
                       }
                       else if(clmSys.equalsIgnoreCase(CMIntegrationConstants.CLAIM_SYSTEM_COMPASS)){
                          	CMIntegrationRequest.cls_ids id3 = new CMIntegrationRequest.cls_ids();
            				id3.sourceSystem = CMIntegrationConstants.CLAIM_SYSTEM_COMPASS; // 'COMPASS'
            				id3.name = CMIntegrationConstants.ID_NAME_SCHEMEID; // 'scheme'
            				id3.value = (String)agr.get('Name');
            				ids.add(id3);
                       }
                   }
               }
            
        }
        // Add global customer id at customer level for all transactions
        if (!forParent && !String.isEmpty(acc.Global_Customer_ID__c)) {         
            CMIntegrationRequest.cls_ids id4 = new CMIntegrationRequest.cls_ids();
            id4.sourceSystem = CMIntegrationConstants.SOURCE_SYSTEM_CM; // 'CM'
            id4.name = CMIntegrationConstants.ID_NAME_GLOBALCUSTOMERID; // 'globalCustomerId'
            id4.value = acc.Global_Customer_ID__c;
            ids.add(id4);          
        }
        
        return ids;   
    }    
    
    //The method is to be reused to populate the demographic section for both parentInfo and customerInfo
    
    public static CMIntegrationRequest.cls_demographic buildDemographic(Account acc, Order od, List<ContactRelationship__c> contactRelationshipList, 
                                                                        Boolean forParent){  
        CMIntegrationRequest.cls_demographic demographic = new CMIntegrationRequest.cls_demographic();
        
        demographic.organizationName = new CMIntegrationRequest.cls_organizationName();
        demographic.organizationName.name = acc.name;
        demographic.organizationName.dbaName = acc.Account_Name_DBA__c;

        demographic.contact = new CMIntegrationRequest.cls_contact();

        // build persons
        buildPersons(demographic, contactRelationshipList, forParent);
        
        // build addresses
        buildAddresses(demographic, acc, od, forParent);

        // build phones
        buildPhones(demographic, acc);

        // build emails
        buildEmails(demographic, acc, contactRelationshipList, forParent); 
		// Per the mapping doc, for parent level, CM will be adding email to Contact section
		// for contact level, CM moving this filed up in the contact.persons section

        return demographic;
    }
    
    //The method is to be reused to populate the persons under demographic section for both parentInfo and customerInfo
    
    public static void buildPersons(CMIntegrationRequest.cls_demographic demographic,
                                                            List<ContactRelationship__c> contactRelationshipList, 
                                    						Boolean forParent){  
        
        demographic.contact.persons = new List<CMIntegrationRequest.cls_persons>();
		
		// one contact can have multiple relationship
		Map<String, List<ContactRelationship__c>> contactToCrListMap = new Map<String, List<ContactRelationship__c>>();
        for(ContactRelationship__c cr : contactRelationshipList) {
            if(cr.Contact__c != null){
			List<ContactRelationship__c> crList = contactToCrListMap.get(cr.Contact__c);
            if (crList == null) {
				crList = new List<ContactRelationship__c>();
                contactToCrListMap.put(cr.Contact__c, crList);
            }
			crList.add(cr);
            }
        }
		List<Contact> conList = new List<Contact>();
		for(String contactId : contactToCrListMap.keySet()) {
            Contact con = contactToCrListMap.get(contactId)[0].Contact__r;
            conList.add(con);
        }

        for(Contact con : conList) {
            
            CMIntegrationRequest.cls_persons person = new CMIntegrationRequest.cls_persons();
            demographic.contact.persons.add(person);
            // person.id = con.id;
            // change referenceId to use Contact's id per discussion with Kishore on 11/12
            // person.referenceId = contactRelationshipMap.get(con.id).id; // newly added in 10/28 JSON
            person.referenceId = con.id;
            person.lastName = con.LastName;
            person.firstName = con.FirstName;
            person.middleName = con.vlocity_ins__MiddleName__c;
            
            List<CMIntegrationRequest.cls_purposes> purposeList = new List<CMIntegrationRequest.cls_purposes>();
            for(ContactRelationship__c cr : contactToCrListMap.get(con.id)) {
                if(cr.Contact_Type__c != null){
                    for(String str: cr.Contact_Type__c.split(';')){
                        CMIntegrationRequest.cls_purposes purpose = new CMIntegrationRequest.cls_purposes();
                        purpose.purpose = str;
                        purposeList.add(purpose);
                    }
                }
            }           
            person.purposes = purposeList;
            
            person.organization = con.Department;
            person.title = con.Title;

            // for parent, there is an addresses section under person 
            // if (parentOrChild == 'parent') {
                // address section
                CMIntegrationRequest.cls_addresses addresses = new CMIntegrationRequest.cls_addresses();
                    
                addresses.line1 = con.MailingStreet;
                addresses.city = con.MailingCity;
                addresses.stateCode = con.MailingState;
                addresses.zipCode = con.MailingPostalCode;
                addresses.countryName = con.MailingCountry;
                                                                 
                person.addresses = addresses;
                
				// phone section
                CMIntegrationRequest.cls_phones phone = new CMIntegrationRequest.cls_phones();
            	String conPhone =  con.phone != null ? con.phone.replaceAll('[^0-9]', '') : null;
        		phone.value = String.isNotBlank(conPhone) ? conPhone : null; 
                /* phone.id = con.id;
                phone.authorizeTxtFlg = 'N';
				*/

                person.phones = phone;
                
				// email section
                CMIntegrationRequest.cls_emails email = new CMIntegrationRequest.cls_emails();
                email.value = con.email;
                person.emails = email;
        }
    }
    
   // The method is to be reused to populate the addresses under demographic->contact->addresses section for both parentInfo and customerInfo
   
    public static void buildAddresses(CMIntegrationRequest.cls_demographic demographic,
                                                            Account acc, Order od, Boolean forParent){
        // address section
        demographic.contact.addresses = new List<CMIntegrationRequest.cls_addresses>();
        
        CMIntegrationRequest.cls_addresses address1 = new CMIntegrationRequest.cls_addresses();
            
        address1.line1 = acc.BillingStreet;
        address1.city = acc.BillingCity;
        address1.stateCode = acc.BillingState;
		address1.zipCode = acc.BillingPostalCode;
        address1.useType = CMIntegrationConstants.ADDRESS_USETYPE_PHYSICAL; // 'Physical'
        address1.countryName = acc.BillingCountry;
        address1.effectiveDtm = forParent ? String.valueOf(od.Implementation_Effective_date__c): null;
                                                                
        demographic.contact.addresses.add(address1);
        
        CMIntegrationRequest.cls_addresses address2 = new CMIntegrationRequest.cls_addresses();
            
        address2.line1 = acc.ShippingStreet;
        address2.city = acc.ShippingCity;
        address2.stateCode = acc.ShippingState;
		address2.zipCode = acc.ShippingPostalCode;
        address2.useType = CMIntegrationConstants.ADDRESS_USETYPE_MAILING; // 'Mailing'
       // address2.countryCode = acc.ShippingCountry; // TODO --- Confirm? 
		address2.countryName = acc.ShippingCountry;
		address2.effectiveDtm = forParent ? String.valueOf(od.Implementation_Effective_date__c): null;
                                                                        
        demographic.contact.addresses.add(address2);
    }
    
   // The method is used to add one year then convert date to yyyy-MM-dd formate
   
    public static String convertDateToYYMMDDAddOneYear(Date d) {
        if (d == null) return '';
        
        Integer day = d.day();
        Integer mo = d.month();
        Integer yr = d.year() + 1;
        
        DateTime dt = DateTime.newInstance(yr, mo, day);
        return dt.format('yyyy-MM-dd');
    }
    
    //The method is used to get the contact by ContactRelationship__c's Contact_Type__c
    
    public static Contact getContactByRelationshipType(List<ContactRelationship__c> contactRelationshipList,
                                                        String relationshipType) {
        for(ContactRelationship__c cr : contactRelationshipList) {
            if (cr.Contact_Type__c != null && cr.Contact_Type__c.contains(relationshipType) && cr.Contact__r != null) return cr.Contact__r;
        }
        return new Contact();
    }
    
    //The method is used to get the contact type from ContactRelationship__c
  /*    public static String getContactType(List<ContactRelationship__c> contactRelationshipList, String contactId) {
        for(ContactRelationship__c cr : contactRelationshipList) {
        	if (cr.Contact__c == contactId && cr.Contact_Type__c != null) return cr.Contact_Type__c;
        }
        return '';
    }

   // The method is used to get the contact effectiveDate from ContactRelationship__c
    
  public static String getContactEffectiveDate(List<ContactRelationship__c> contactRelationshipList, String contactId) {
        for(ContactRelationship__c cr : contactRelationshipList) {
        	if (cr.Contact__c == contactId) return String.valueOf(cr.EffectiveDate__c);
        }
        return '';
    } */
    
    //The method is to be reused to populate the phones under demographic->contact section for both parentInfo and customerInfo
    
    public static void buildPhones(CMIntegrationRequest.cls_demographic demographic,
                                                            Account acc){  
        demographic.contact.phones = new List<CMIntegrationRequest.cls_phones>();
        
        CMIntegrationRequest.cls_phones phone = new CMIntegrationRequest.cls_phones();
        String accPhone =  acc.phone != null ? acc.phone.replaceAll('[^0-9]', '') : null;
        phone.value = String.isNotBlank(accPhone) ? accPhone : null;
        // phone.authorizeTxtFlg = 'N';
        // phone.id = con.id;
        demographic.contact.phones.add(phone);   
    }

   // The method is to be reused to populate the emails under demographic->contact section for both parentInfo and customerInfo
   
    //public static void buildEmails(CMIntegrationRequest.cls_demographic demographic, List<Contact> conList){  
    public static void buildEmails(CMIntegrationRequest.cls_demographic demographic, Account acc,
                                  List<ContactRelationship__c> contactRelationshipList, Boolean forParent) {
        
		// use e-mail address for contact type group admin for account level e-mail address
		//contactRelationshipList
		Contact groupAdminContact = getContactByRelationshipType(contactRelationshipList, CMIntegrationConstants.RELATIONSHIPTYPE_GROUP_ADMIN); // 'Group Administrator'
                                      
        // email section
        demographic.contact.emails = new List<CMIntegrationRequest.cls_emails>();
        CMIntegrationRequest.cls_emails email = new CMIntegrationRequest.cls_emails();
		email.value = groupAdminContact.email;
		demographic.contact.emails.add(email);
        
    }

    //The method is to be reused to populate the status section for both parentInfo and customerInfo
    public static void buildStatus(CMIntegrationRequest.cls_status status, Account acc){  

        status.timeline = new List<CMIntegrationRequest.cls_timeline>();
        CMIntegrationRequest.cls_timeline timeline = new CMIntegrationRequest.cls_timeline();
        status.timeline.add(timeline);
        
        timeline.status = acc.Account_Status__c == 'Active' ? 'A' : null;
        // If status=Active, use Original_Effective_Date__c
        timeline.effectiveDate = acc.Account_Status__c == 'Active' ? String.valueOf(acc.Original_Effective_Date__c) : null;
        
        /* if needed, uncomment this
        timeline.endDate = convertDateToYYMMDD(acc.Cancel_Date__c);
        
        timeline.reasons = new List<CMIntegrationRequest.cls_reasons>();
        CMIntegrationRequest.cls_reasons reason = new CMIntegrationRequest.cls_reasons();
        reason.description = acc.vlocity_ins__TerminationReason__c;
        timeline.reasons.add(reason);
        */        
    }

   // The method is to be reused to populate the status section for both parentInfo and customerInfo
    public static CMIntegrationRequest.cls_legalEntity buildLegalEntity(Account acc, Group__c grp, Order od){  
        
        // legal entity
        CMIntegrationRequest.cls_legalEntity legalEntity = new CMIntegrationRequest.cls_legalEntity();
        
        legalEntity.name = acc.Name;	

        if (grp != null) {
			List<Group_Tax_ID__c> groupTaxList = [select Tax_ID__r.Tax_ID__c 
                                                  from Group_Tax_ID__c 
                                                  where Group__c =:grp.id];
            
        	if (groupTaxList.size() > 0 && groupTaxList[0].Tax_ID__r != null) legalEntity.taxId = groupTaxList[0].Tax_ID__r.Tax_ID__c;
        }
        legalEntity.type 		  = ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, 'Legal Entity', acc.Legal_Entity__c);	
        legalEntity.effectiveDate = String.valueOf(od.Implementation_Effective_Date__c);
        
        return legalEntity;
    }
  
  //  The method is to be reused to populate the notes section for both parentInfo and customerInfo
        public static void buildNotes(List<CMIntegrationRequest.cls_notes> notes, Order od){  
        
        CMIntegrationRequest.cls_notes note = new CMIntegrationRequest.cls_notes();
        notes.add(note);
        note.value = od.Additional_comments__c;        
      
    }

    //  The method is used to populate the customerInfo section under Account info
    public static void buildCustomerInfo(CMIntegrationRequest jsonCMPayload, Account accChild, Account accParent,
                                    List<ContactRelationship__c> contactRelationshipListChild, Order od, Group__c grp,
                                    List<AccountTeamMember> accTeamList, List<Account_Preferences__c> gpList){
        
        /*************** customerInfo from here ************/
		// in order to reuse
        String orderEffectiveDate = String.valueOf(od.Implementation_Effective_Date__c);
                                        
     /*   List<Group_Logistics__c> groupLogisticsList = [select Does_Anthem_Generate_HCID__c 
                                                       from Group_Logistics__c 
                                                       where Group_Number__c = :od.Group_Name__c]; */
        
        List<Quote> qtList = [select Terminated_Reserveless_MPP_Funding__c, Employee_Assistance_Program__c 
                              from Quote 
                              where id = :od.QuoteId];
		Quote qt = new Quote();
		if (qtList.size() > 0) qt = qtList[0];
        User currentUser = [select FederationIdentifier, Rep_ID_Code__c, Sales_office_location__c 
                            from User 
                            where id =:UserInfo.getUserId()];

        List<ServiceProviderRelationship__c> sprList   =[select Account__c, Contact__c, EffectiveDate__c, VendorName__c, VendorType__c
                                                  from ServiceProviderRelationship__c 
                                                  where Account__c = :accChild.id order by EffectiveDate__c desc] ;                             
                                        
                                        
        CMIntegrationRequest.cls_accountInfo accountInfo = jsonCMPayload.accountInfo;
        
        CMIntegrationRequest.cls_customerInfo customerInfo = new CMIntegrationRequest.cls_customerInfo();
        accountInfo.customerInfo = customerInfo;
        
        List<CMIntegrationRequest.cls_customers> customers = new List<CMIntegrationRequest.cls_customers>();
        accountInfo.customerInfo.customers = customers;
        CMIntegrationRequest.cls_customers customer = new CMIntegrationRequest.cls_customers();
        customers.add(customer);

        // ids section
        customer.ids = buildIds(accChild, false, od);
        
        // demographic section
        customer.demographic = buildDemographic(accChild, od, contactRelationshipListChild, false);

        // status section
        customer.status = new CMIntegrationRequest.cls_status();
        buildStatus(customer.status, accChild);
                                        
        // customerConfig section        
        CMIntegrationRequest.cls_customerConfig customerConfig = new CMIntegrationRequest.cls_customerConfig();
        customer.customerConfig = customerConfig;
                                        
		// add legalEntity here    
		customer.customerConfig.legalEntity = buildLegalEntity(accChild, grp, od);

		// miscellaneous section
		CMIntegrationRequest.cls_miscellaneousCustomerConfig miscellaneous = new CMIntegrationRequest.cls_miscellaneousCustomerConfig();
		customer.customerConfig.miscellaneous = miscellaneous;
		List<Alpha_Prefix_Network__c> prefixList = [select Account_ID_Indicator__c,Prefix_Account_ID__c 
                                                    from Alpha_Prefix_Network__c 
                                                    where Alpha_Prefix_Request__r.CIP_Reference__c = :od.id
                                                    and Account_ID_Indicator__c = 'Y' ]; 

		miscellaneous.prefixAccountId = accChild.Prefix_Account_ID__c;
        miscellaneous.eocIndicator    = accChild.EOC_Paperless_Option_Indicator__c;                                
		// Pull all Alphanumeric Network records associated with the Account(Group)
		// If any Indicator field is set to Y then send WGS 'Y' for the Prefix Account ID Indicator.
		// If all Alphanumeric Network records have Indicator set to 'N' then send WGS 'N' for the Prefix Account ID Indicator
		miscellaneous.prefixIndicator = prefixList.size() > 0 ? 'Y': 'N';
        if (accChild.Sic__r != null) miscellaneous.standardIndustryClassification = accChild.Sic__r.SIC_Code__c;
                                        
        // thirdPartyAdministrator ContactRelationship__c.Contact_Type__c (multi picklist) contains Third Party Admin
        //Contact thirdPartyAdministratorContact = getContactByRelationshipType(contactRelationshipListChild, 'Third Party Admin');

        CMIntegrationRequest.cls_thirdPartyAdministrator thirdPartyAdministrator = new CMIntegrationRequest.cls_thirdPartyAdministrator();
        customer.customerConfig.thirdPartyAdministrator = thirdPartyAdministrator;

		//ServiceProviderRelationship__c sprThirdPartyAdministrator = serviceProviderRelationshipMap.get(thirdPartyAdministratorContact.id);
        // For Service Provider Relationship record tied to Account, where Vendor_type__c=TPA, pass field Vendor__c??
        for(ServiceProviderRelationship__c spr : sprlist){
            if(spr.VendorType__c == 'TPA') {
                thirdPartyAdministrator.code = spr.VendorName__c;
                thirdPartyAdministrator.effectiveDate = orderEffectiveDate;//convertDateToYYMMDD(od.Implementation_effective_date__c);
                break;
            }                              
        }
        /*                                
		if (sprThirdPartyAdministrator.VendorType__c != null && sprThirdPartyAdministrator.VendorType__c == 'TPA') {
			thirdPartyAdministrator.code = sprThirdPartyAdministrator.VendorName__c;
        } else {
        	thirdPartyAdministrator.code = '';
        }*/
            
        // customerVendorSegment, no need
        List<Eligibility__c> eliList = [select COBRA_Administration_Services_Provided__c, Prem_Paid_for_Each_Sub_per_Month__c, 
                                        Prem_Paid_for_Each_Sub_Dep_per_Month__c, New_Hire_Probationary_Period__c, If_Dep_reaches_max_age_auto_terminate__c,
                                        Over_65_Code__c, Domestic_Partner_Indicator__c, Overage_dep_term_Itrs_be_mailed_to_sub__c, Employee_Excluded_Code__c,
                                        MHSA_Service_Level_Indicator__c, Delete_Dependent_Code__c, Women_s_Contraceptive_Exemption_Ind__c,
                                        Eligibility_Change_Indicator_Dependent__c, Eligibility_Term_Indicator_Dependent_E__c
                                        from Eligibility__c 
                                        where Implementation_Record_ID__c =:od.id ];
         //customerIndicators
         if(eliList.size()>0){
         CMIntegrationRequest.cls_customerIndicators customerIndicators = new CMIntegrationRequest.cls_customerIndicators();
         customer.customerConfig.customerIndicators = customerIndicators;
         customerIndicators.eligibilityChange = eliList[0].Eligibility_Change_Indicator_Dependent__c;
         customerIndicators.eligibilityTerm   = eliList[0].Eligibility_Term_Indicator_Dependent_E__c;                               
         }                               
        // dentalCensus, no need

        // salesOfficeLocation 
        CMIntegrationRequest.cls_salesOfficeLocation salesOfficeLocation = new CMIntegrationRequest.cls_salesOfficeLocation();
        customer.customerConfig.salesOfficeLocation = salesOfficeLocation;

		// For User, reference Account Team member with role 'Account Manager', if no 'Account Manager', use 'Account Executive'
        for(AccountTeamMember accTeam : accTeamList) {
			if (accTeam.TeamMemberRole == CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_MANAGER
                ||accTeam.TeamMemberRole == CMIntegrationConstants.TEAMMEMBER_ROLE_ACCOUNT_EXECUTIVE){
                salesOfficeLocation.code = accTeam.User.Sales_office_location__c;
                break;
            }
		}
        
        // salesOfficeLocation.effectiveDate = convertDateToYYMMDD(Date.today());

        // speciality 
       CMIntegrationRequest.cls_speciality speciality = new CMIntegrationRequest.cls_speciality();
        customer.customerConfig.speciality = speciality;
        speciality.principleEmployerIndicator = 'Y'; 
        // speciality.gsmCreator = ''; // Leave blank (DDS)*/
                                        
        // enrollment 
        CMIntegrationRequest.cls_enrollment enrollment = new CMIntegrationRequest.cls_enrollment();
        customer.customerConfig.enrollment = enrollment;
        
        CMIntegrationRequest.cls_retro retro = new CMIntegrationRequest.cls_retro();
        customer.customerConfig.enrollment.retro = retro;
        retro.daysOL = grp.Retro_Enrollment_Maintenance_Online__c;
        retro.daysGT = grp.Retro_Enrollment_Maintenance_Electronic__c;
        
        //enrollment.oadRiderCode = ''; // TODO Per CM, this can wait
        // enrollment.fullDepEligibilityFlag = 'Y'; //Default.Deafult to "Y"
		// TODO will there be only one Group Logistics?
        // if (groupLogisticsList.size() > 0) enrollment.hcidEnrollCode = groupLogisticsList[0].Does_Anthem_Generate_HCID__c;
    
        if (gpList != null && gpList.size() > 0) enrollment.hcidEnrollCode = gpList[0].Does_Anthem_Generate_HCID__c;
        enrollment.effectiveDate = orderEffectiveDate;

        // idCard 
        CMIntegrationRequest.cls_idCardCustomerConfig idCard = new CMIntegrationRequest.cls_idCardCustomerConfig();
        customer.customerConfig.idCard = idCard;
        idCard.nonHmoldCards = od.Non_HMO_ID_Cards__c;
        // idCard.idCardCompanyLogo = '';
        // idCard.genIdCardIndicator = '';
        idCard.effectiveDate = orderEffectiveDate;
        
        // claim
        CMIntegrationRequest.cls_claimCustomerConfig claim = new CMIntegrationRequest.cls_claimCustomerConfig();
        customer.customerConfig.claim = claim;
        
        // minimumPremiumPlan
        CMIntegrationRequest.cls_minimumPremiumPlan minimumPremiumPlan = new CMIntegrationRequest.cls_minimumPremiumPlan();
        customer.customerConfig.claim.minimumPremiumPlan = minimumPremiumPlan;
        // minimumPremiumPlan.mppInsuranceRunout = 'N';
        minimumPremiumPlan.termReservelessMppCheckStock = qt.Terminated_Reserveless_MPP_Funding__c;
        
        // nationalCareNetwork
        CMIntegrationRequest.cls_nationalCareNetwork nationalCareNetwork = new CMIntegrationRequest.cls_nationalCareNetwork();
        customer.customerConfig.claim.nationalCareNetwork = nationalCareNetwork;
		// If Account_Medical_Funding_Type__c=FI, and Program_Selection_Details__c=null, pass "Y"
		// If Account_Medical_Funding_Type__c=ASO, and Program_Selection_Details__c=No, pass "N"
		// If Account_Medical_Funding_Type__c=ASO, and Program_Selection_Details__c=Yes, pass "T"
		// If Account_Medical_Funding_Type__c=ASO/FI, and Program_Selection_Details__c=Yes, pass "T"
		// If Account_Medical_Funding_Type__c=ASO/FI, and Program_Selection_Details__c=No, pass "M"
        if (accChild.Account_Medical_Funding_Type__c == 'FI' && accChild.Program_Selection_Details__c == null) {
            nationalCareNetwork.referralIndicator = 'Y';
        } else if (accChild.Account_Medical_Funding_Type__c == 'ASO' && accChild.Program_Selection_Details__c == 'No') {
            nationalCareNetwork.referralIndicator = 'N';
        } else if (accChild.Account_Medical_Funding_Type__c == 'ASO' && accChild.Program_Selection_Details__c == 'Yes') {
            nationalCareNetwork.referralIndicator = 'T';
        } else if (accChild.Account_Medical_Funding_Type__c == 'ASO/FI' && accChild.Program_Selection_Details__c == 'Yes') {
            nationalCareNetwork.referralIndicator = 'T';
        } else if (accChild.Account_Medical_Funding_Type__c == 'ASO/FI' && accChild.Program_Selection_Details__c == 'No') {
            nationalCareNetwork.referralIndicator = 'M';
        }
        if(String.isNotBlank(nationalCareNetwork.referralIndicator))
        nationalCareNetwork.referralEffectiveDate = orderEffectiveDate;

        // claimVendors
        List<CMIntegrationRequest.cls_claimVendors> claimVendors = new List<CMIntegrationRequest.cls_claimVendors>();
        customer.customerConfig.claim.claimVendors = claimVendors;
        
        CMIntegrationRequest.cls_claimVendors claimVendor = new CMIntegrationRequest.cls_claimVendors();
        claimVendors.add(claimVendor);
        
        if(String.isNotBlank(accChild.Claims_Savings_Vendor__c)){
        	claimVendor.code = accChild.Claims_Savings_Vendor__c;
        	claimVendor.effectiveDate = orderEffectiveDate;
        }

        // cobra 
        CMIntegrationRequest.cls_cobra cobra = new CMIntegrationRequest.cls_cobra();
        customer.customerConfig.cobra = cobra;
		
        if (eliList.size() > 0) cobra.adminServicesFlag = eliList[0].COBRA_Administration_Services_Provided__c;
        String erisaFlag =  ServiceIntegrationMappingUtility.getExternalSystemValue(CMIntegrationConstants.INTEGRATION_NAME, 'Erisa Status',accChild.Is_this_Group_subject_to_ERISA__c);
        cobra.erisaFlag = erisaFlag;//(accChild.Is_this_Group_subject_to_ERISA__c == 'ERISA' || accChild.Is_this_Group_subject_to_ERISA__c == 'Yes') ? 'Y' : 'N';
       
		// TODO add membershipDescriptors here
		List<Department_Code__c> departmentCodes = [Select Id, Department_Code__c, Department_Description__c
                                                    FROM Department_Code__c
													WHERE Account_Legal_Name__c =:accChild.id];
        if(departmentCodes.size() >0){                                
		List<CMIntegrationRequest.cls_membershipDescriptors> membershipDescriptors = new List<CMIntegrationRequest.cls_membershipDescriptors>();
        customer.customerConfig.membershipDescriptors = membershipDescriptors;
        CMIntegrationRequest.cls_membershipDescriptors memDesciptor = new CMIntegrationRequest.cls_membershipDescriptors();
        membershipDescriptors.add(memDesciptor);
        List<CMIntegrationRequest.cls_department> department = new List<CMIntegrationRequest.cls_department>(); 
        memDesciptor.department = department;
            for(Department_Code__c depCode : departmentCodes){
                CMIntegrationRequest.cls_department dep = new CMIntegrationRequest.cls_department();
                CMIntegrationRequest.cls_info info = new CMIntegrationRequest.cls_info();
                info.code = depCode.Department_Code__c;
                info.name = depCode.Department_Description__c;
                dep.info =  info;
                department.add(dep);
            }
        }
        // renewal
        CMIntegrationRequest.cls_renewal renewal = new CMIntegrationRequest.cls_renewal();
        customer.customerConfig.renewal = renewal;
        // If Next Anniv Date populated THEN pass values form SF. 
        // Else if blank THEN Original Effective Date + 12 months. Original_Effective_Date__c
        // Else if midmonth effective date THEN First month of the month 
        //  following Original Effective Date + 12 months.
        renewal.nextAnniversaryDate = String.valueOf(accChild.Active_Renewal_Date__c); 
		// TODO cannot find Next Anniv Date / midmonth effective date in this org 
        // We will ensure the user populates this prior to submission
                                        
        // underWriting
        CMIntegrationRequest.cls_underWriting underWriting = new CMIntegrationRequest.cls_underWriting();
        customer.customerConfig.underWriting = underWriting;

		// if one of the Quote line items is 'grandfathered' then we can pass 'Grandfathered' for the whole Order
        List<QuoteLineItem> qliGrandfatheredList = [Select id FROM QuoteLineItem where HCR_Status__c = 'Grandfathered' and QuoteId = :qt.id];
                                        
		// For the state of CA, there are only 2 valid codes “066” and “069”. For CA, only pooled business needs to have one of these codes. 
        if (accChild.Situs_State_Abbrev__c == 'CA' && accChild.Pooled_non_pooled__c == 'Pooled') {
            // If Situs_state__c=California, Pooled_non_pooled__c=Pooled, HCR_Status__c=Nongrandfathered: pass UW code "066" 
            if (qliGrandfatheredList.size() == 0) {
                underWriting.underWriter = '066';
            } else {
			// If Situs_state__c=California, and Pooled_non_pooled__c=Pooled, and HCR_Status__c=Grandfathered: pass UW code "069"
                underWriting.underWriter = '069';
            }
		// For anything not in the state of CA, send the field Rep_ID_Code_c from the Account Team role=Underwriter.
        } else {
            for(AccountTeamMember accTeam : accTeamList) {
                if (accTeam.TeamMemberRole == CMIntegrationConstants.TEAMMEMBER_ROLE_UNDERWRITER) {
                    underWriting.underWriter = accTeam.User.Rep_ID_Code__c;
                    break;
                }
            }
        }
        
        underWriting.uwWorkMonth = ServiceIntegrationMappingUtility.getExternalSystemValue('CM Integration', 'UW Work Month', accChild.Month_underwriter_starts_renewal_process__c);
        
		// If CA (case level), and (Pooled_Non_Pooled__c=Pooled) standard value comes from SF, 
		// then FocalRenewalDate= Case Eff Date + 1 year. Else leave blank
        if (accChild.Situs_State_Abbrev__c == 'CA' && accChild.Pooled_Non_Pooled__c == 'Pooled') {
        	underWriting.focalRenewalDate = convertDateToYYMMDDAddOneYear(od.Implementation_Effective_date__c); 
        }
        // representatives
        customer.customerConfig.representatives = CMPartialJSONRequest.buildRepresentatives(od.AccountId, od, accTeamList);
        
        // quote
        List<CMIntegrationRequest.cls_quotes> quotes = new List<CMIntegrationRequest.cls_quotes>();
        customer.customerConfig.quotes = quotes;
        CMIntegrationRequest.cls_quotes quot = new CMIntegrationRequest.cls_quotes();
        quotes.add(quot);
		
		// Life and Disability	Quote_ID__c
		List<Life_and_Disability__c> ldList = [select Quote_ID__c 
                                               from Life_and_Disability__c 
                                               where Implementation_Tracking_ID__r.Implementation_Record_ID__c = :od.id];                  
        quot.quoteID = ldList.size() > 0 ? ldList[0].Quote_ID__c : null;
        if(String.isNotBlank(quot.quoteID)){
        	quot.type = 'SRQ';
        	quot.effectiveDate = String.valueOf(od.Opportunity.CloseDate);
                                            
        }                                        
                                        
		// speciality no need
                                        
        // notes section
        List<CMIntegrationRequest.cls_notes> notes = new List<CMIntegrationRequest.cls_notes>();
        customer.notes = notes;
        buildNotes(customer.notes, od);
                                        
      //  customer.products = CMPartialJSONRequest.buildProductsCustInfo(accChild, od, grp, sprList, eliList, gpList);
        CMPartialJSONRequest.buildProductsCustInfo(jsonCMPayload, accChild, od, grp, sprList, eliList, gpList);                                
                                        
		 customer.broker = CMPartialJSONRequest.buildBrokerCustomerInfo(od.AccountId, od);
      // code to be merged here
    }
    
   // The method is used to populate the accountBillGroups section under Account info  
    public static void buildAccountBillGroups(CMIntegrationRequest jsonCMPayload, String accId, Order od){
       
        CMPartialJSONRequest.buildAccountBillGroups(jsonCMPayload, accId, od);
    }

}