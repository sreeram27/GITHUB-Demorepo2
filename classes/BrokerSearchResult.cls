/*
@Author : CDHP Dev Team 
@name : BrokerSearchResult
@CreateDate :04-02-2020
@Description : This class is used to for Broker Search Page functionality.
@Last Modified Date: 05th Feb 2020
*/
public with sharing class BrokerSearchResult {
    public static final String SYSTEM_ADMINISTRATOR = 'System Administrator';
    /*PRDCRM-45814,PRDCRM-51437 Constants for Permission Sets name.*/
    public static final String STATE_ADMIN_CREATE_BROKER_CONTACT_RELATIONSHIP = 'State_Admin_Create_Broker_Contact_Relationship_Records';
    public static final String STATE_ADMIN_CREATE_BROKER_RECORDS = 'State_Admin_Create_Broker_Records';
    public static final String CONSULTANT_RELATIONSHIP_RECORD_TYPE = 'LG Brokerage Consultant Relationship';
    //public static final String NO_RESULT = 'No results found, please change your criteria and search again.';
    
    /*
    @method Name : fetchBrokerStateLookupData
    @Parameters used: None
    @method Description : Fetch if the logged in User has the desired Permission set to view 'New Contact Relationship' 
    & 'Create New Broker' Buttons.
    @Last Modified Date: 05th Feb 2020
    */
    @AuraEnabled(Cacheable=true)
    public static List<LG_License__c> fetchBrokerStateLookupData(String searchState){
        if(!String.isBlank(searchState)){
            String brkrState = String.escapeSingleQuotes(searchState.trim()) + '%';
            Set<String> strState = new Set<String>();
            List<LG_License__c> searchContacts = new List<LG_License__c>();
            for(LG_License__c lg : [Select Id,State__c from LG_License__c where State__c like :brkrState]){
                if(lg.State__c != null && !strState.contains(lg.State__c)){
                    searchContacts.add(lg);
                    strState.add(lg.State__c);
                }
            }
            return searchContacts;
        }  
        return null;
    }
        
    /*
    @method Name : fetchBrokerSearchLookupData
    @Parameters used: None
    @method Description : Fetch if the logged in User has the desired Permission set to view 'New Contact Relationship' 
    & 'Create New Broker' Buttons.
    @Last Modified Date: 05th Feb 2020
    */
    @AuraEnabled(Cacheable=true)
    public static List<Contact> fetchBrokerSearchLookupData(String searchText, String searchType) {
        if(!String.isBlank(searchText) && !String.isBlank(searchType) && searchType.equalsIgnoreCase(CDHP_COMM2_Constants.NAME)){
            String brkrName = String.escapeSingleQuotes(searchText.trim()) + '%';
            List<Contact> searchContacts = [Select Id,Name from Contact where Name like :brkrName];
            return searchContacts;
        }  
        else if(!String.isBlank(searchText) && !String.isBlank(searchType) && searchType.equalsIgnoreCase(CDHP_COMM2_Constants.TAX)){
            String brkrTax = String.escapeSingleQuotes(searchText.trim()) + '*';
            List<List<sObject>> searchList = [FIND :brkrTax IN ALL FIELDS 
                                              RETURNING Contact(Id,Tax_ID__c)];
            List<Contact> searchContacts = new List<Contact>();
            for(Contact ct : (List<Contact>)searchList[0]){
                if(ct.Tax_ID__c != null && ct.Tax_ID__c.contains(searchText))
                    searchContacts.add(ct);
            }
            return searchContacts;
        }  
        else if(!String.isBlank(searchText) && !String.isBlank(searchType) && searchType.equalsIgnoreCase(CDHP_COMM2_Constants.BROKEREMAIL)){
            String brkrEmail = String.escapeSingleQuotes(searchText.trim()) + '%';
            List<Contact> searchContacts = [Select Id,Email from Contact where Email like :brkrEmail];
            return searchContacts;
        }  
        else if(!String.isBlank(searchText) && !String.isBlank(searchType) && searchType.equalsIgnoreCase(CDHP_COMM2_Constants.BROKERPHONE)){
            String brkrPhone = String.escapeSingleQuotes(searchText.trim()) + '%';
            List<Contact> searchContacts = [Select Id,MobilePhone from Contact where MobilePhone like :brkrPhone];
            return searchContacts;
        }  
        return null;
        
    }
    /*
@method Name : checkPermissionSet
@Parameters used: None
@method Description : Fetch if the logged in User has the desired Permission set to view 'New Contact Relationship' 
& 'Create New Broker' Buttons.
@Last Modified Date: 05th Feb 2020
*/
    @AuraEnabled(Cacheable=true)
    public static InitializeResponse checkPermissionSet() {
        //PRDCRM-45814,PRDCRM-51437
        Boolean createBrokerRecordsCheck = false;
        Boolean createBrokerContactRelationshipCheck = false;
        InitializeResponse response = new InitializeResponse();
        //Fetch the profile of Logged in User.
        User loggedInUser = [SELECT Id,Profile.Name
                             FROM User
                             WHERE Id = :Userinfo.getUserId()
                            ];
        if(loggedInUser.Profile.Name == SYSTEM_ADMINISTRATOR ){
            response.showContactRelationshipButton = true;
            response.showNewBroker = true;
            return response;
        }                        
        //Check the permission set assigned to the logged in user.
        List<PermissionSetAssignment> permissionSetList = [SELECT Id,PermissionSet.Name, AssigneeId
                                                           FROM PermissionSetAssignment
                                                           WHERE AssigneeId = :Userinfo.getUserId()
                                                          ];                                                           
        for(PermissionSetAssignment permSet : permissionSetList){
            if(permSet.PermissionSet.Name.equals(STATE_ADMIN_CREATE_BROKER_RECORDS)){
                response.showContactRelationshipButton = true;
                response.showNewBroker = true;
                createBrokerRecordsCheck = true;
            }
            if(permSet.PermissionSet.Name.equals(STATE_ADMIN_CREATE_BROKER_CONTACT_RELATIONSHIP)){
                response.showContactRelationshipButton = true;
                createBrokerContactRelationshipCheck =  true;
            }
            //To exit loop if both Permission sets are checked
            if(createBrokerRecordsCheck && createBrokerContactRelationshipCheck){
                return response;
            }
        }
        return response;
        
    }

    
        
        
    @AuraEnabled
    public static List<BrokerSelectionResponse> fetchBrokerSearchResult(String brokerName,String brokerTaxId,String brokerEmail,String brokerMobile,
                                  String brokerLicenseState) {
        
        //Search for the Tax ID field
    	List<List<sObject>> searchList = [FIND :brokerTaxId IN ALL FIELDS 
                                          RETURNING Contact(Id,FirstName,LastName)];
        List<Contact> searchContacts = (List<Contact>)searchList[0];
        Map<Id,Contact> searchContactMap = new Map<Id, Contact>(searchContacts);

        List<BrokerSelectionResponse> brokerSelResponse = new List<BrokerSelectionResponse>();
        String brokerLicenseWhereQuery = '';
        String brokerLicenseQuery = '';
        String whereQueryBrokerContact = '';
        //Final dynamic query to fetch Broker and its related Broker Licenses & Brokerages records.
        String brokerSearchQuery = '';
        String brokerLicenseSelectQuery = '';
        String brokerFromQuery = '';
        String brokerOrderQuery=' ORDER BY Name ';
		Date todayDate = Date.today();
        //dynamic WHERE condition for Broker License
        System.debug('brokerLicenseState: '+brokerLicenseState);
        if(String.isBlank(brokerLicenseState) || brokerLicenseState.equalsIgnoreCase('NA')){
            brokerLicenseWhereQuery = 'WHERE License_End_Date__c >= :todayDate)';
        }else{
            brokerLicenseWhereQuery = ' WHERE License_End_Date__c >= :todayDate AND State__c = :brokerLicenseState )'; 
        }
        //dynamic WHERE condition for Contact/Broker starts
        if(!String.isBlank(brokerTaxId)){    
            if(String.isBlank(whereQueryBrokerContact)){
                whereQueryBrokerContact += ' WHERE Id IN :searchContacts ';
            }else{
                whereQueryBrokerContact += ' AND Id IN :searchContacts ';    
            }
        }   
        if(!String.isBlank(brokerName)){
            String brkrName = String.escapeSingleQuotes(brokerName.trim()) + '%';
            if(String.isBlank(whereQueryBrokerContact))
                whereQueryBrokerContact += ' WHERE Name LIKE :brkrName ';
            else
                whereQueryBrokerContact += ' AND Name LIKE :brkrName ';    
        }

        if(!String.isBlank(brokerEmail)){
            String brkrEmail = '%'+String.escapeSingleQuotes(brokerEmail.trim())+'%';
            if(String.isBlank(whereQueryBrokerContact))
                whereQueryBrokerContact += ' WHERE Email LIKE :brkrEmail ';
            else
                whereQueryBrokerContact += ' AND Email LIKE :brkrEmail ';    
        }

        if(!String.isBlank(brokerMobile)){
            String brkrMobile = '%'+String.escapeSingleQuotes(brokerMobile.trim())+'%';
            if(String.isBlank(whereQueryBrokerContact))
                whereQueryBrokerContact += ' WHERE MobilePhone LIKE :brkrMobile ';
            else
                whereQueryBrokerContact += ' AND MobilePhone LIKE :brkrMobile ';    
        }
        //dynamic WHERE condition for Contact/Broker ends

        
        String brokerSelectQuery = 'SELECT Name, Tax_ID__c, Email, MobilePhone,ContactAccountName__c';
        brokerLicenseSelectQuery = '(SELECT Id,State__c FROM Broker_Licenses__r ';
        String contactRelQuery = '(SELECT Id,IsActive__c,RecordType.Name,Contact__c,Contact__r.Account_Name__c '+
                          'FROM Contact_Relationships__r '+ 
                          'WHERE RecordType.Name = :CONSULTANT_RELATIONSHIP_RECORD_TYPE '+
                          'AND IsActive__c = true) ';
        brokerFromQuery = ' FROM Contact ';
        
        brokerSearchQuery = brokerSelectQuery +',' + brokerLicenseSelectQuery + brokerLicenseWhereQuery +','+contactRelQuery
                            + brokerFromQuery + whereQueryBrokerContact + brokerOrderQuery;
        System.debug('brokerSearchQuery: '+brokerSearchQuery);

        List<Contact> brokerSearchList = (List<Contact>)Database.query(brokerSearchQuery);
        System.debug('brokerSearchList: '+brokerSearchList);
		if(brokerSearchList.isEmpty()){
        	 BrokerSelectionResponse brkrSel = new BrokerSelectionResponse();
             brkrSel.noDataToShow = true;
             brokerSelResponse.add(brkrSel);
             System.debug('brokerSelResponse0 '+brokerSelResponse);
             return brokerSelResponse;                                  
		}
        Map<Id,List<LG_License__c>> brokerLicenseMap = new Map<Id,List<LG_License__c>>();
        Map<Id,List<ContactRelationship__c>> brokerageConsultantMap = new Map<Id,List<ContactRelationship__c>>();
        integer brokerLicenseSize = 0;
        integer brokerageConsultantSize = 0;
        integer rowsCount = 0;
       
		try{
        	for(Contact broker : brokerSearchList){
                brokerLicenseMap.put(broker.Id,broker.Broker_Licenses__r);
                brokerLicenseSize = broker.Broker_Licenses__r.size();
                System.debug('brokerLicenseMap '+brokerLicenseMap);
                System.debug('brokerLicenseSize '+brokerLicenseSize);
                brokerageConsultantMap.put(broker.Id,broker.Contact_Relationships__r);
                brokerageConsultantSize = broker.Contact_Relationships__r.size();
                System.debug('brokerageConsultantSize '+brokerageConsultantSize);
                if(brokerageConsultantSize == 0){
                        rowsCount = 0;
                        BrokerSelectionResponse brkrSel = new BrokerSelectionResponse();
                        brkrSel.noDataToShow = true;
                        brokerSelResponse.add(brkrSel);
                        System.debug('brokerSelResponse1 '+brokerSelResponse);
                        return brokerSelResponse;
                }
                if(brokerLicenseState.equalsIgnoreCase('NA') || String.isBlank(brokerLicenseState)){
                    
                    if(brokerLicenseSize != 0 && brokerageConsultantSize != 0 ){
                        rowsCount = brokerLicenseSize * brokerageConsultantSize;
                    }
                    if(brokerLicenseSize == 0 && brokerageConsultantSize != 0 ){
                        rowsCount = brokerageConsultantSize;
                    }
                    System.debug('rowsCount_None: '+rowsCount);
                    for(integer row = 0; row < rowsCount ;row++){
                        BrokerSelectionResponse brkrSel = new BrokerSelectionResponse();
                        brkrSel.brokerName = broker.Name ;
                        brkrSel.brokerTaxId = broker.Tax_ID__c;
                        brkrSel.brokerEmail = broker.Email;
                        brkrSel.brokerMobile = broker.MobilePhone;
                        if((row < brokerLicenseSize) && !String.isBlank(broker.Broker_Licenses__r.get(row).State__c)){
                            brkrSel.brokerLicenseState = broker.Broker_Licenses__r.get(row).State__c;
                            System.debug('state_0 '+broker.Broker_Licenses__r.get(row).State__c);
                        }else{
                            brkrSel.brokerLicenseState = 'N/A';
                            System.debug('state_0 : N/A');
                        }        
                            
                        brkrSel.brokerPaidTin = broker.ContactAccountName__c;
                        /*if((row < brokerageConsultantSize) && !String.isBlank(broker.Contact_Relationships__r.get(row).Contact__r.Account_Name__c)){
                            brkrSel.contRelBrokerage = broker.Contact_Relationships__r.get(row).Contact__r.Account_Name__c;
                            System.debug('CR_0 '+broker.Contact_Relationships__r.get(row).Contact__r.Account_Name__c);
                        }else{
                            brkrSel.contRelBrokerage = 'N/A';
                            System.debug('CR_0 : N/A');
                        }*/
                        for(integer conRel = 0;conRel < brokerageConsultantSize;conRel++){
                            brkrSel.contRelBrokerage = broker.Contact_Relationships__r.get(conRel).Contact__r.Account_Name__c;
                            System.debug('CR_0 '+broker.Contact_Relationships__r.get(conRel).Contact__r.Account_Name__c);
                        }
                        brokerSelResponse.add(brkrSel);
                    }
                    
                }
                if(!(brokerLicenseState.equalsIgnoreCase('NA')) && !(String.isBlank(brokerLicenseState))){
                    if(brokerLicenseSize != 0 && brokerageConsultantSize != 0 ){
                        rowsCount = brokerageConsultantSize;
                    }
                    if(brokerLicenseSize == 0 && brokerageConsultantSize != 0 ){
                        rowsCount = 0;
                        BrokerSelectionResponse brkrSel = new BrokerSelectionResponse();
                        brkrSel.noDataToShow = true;
                        brokerSelResponse.add(brkrSel);
                        System.debug('brokerSelResponse2 '+brokerSelResponse);
                        return brokerSelResponse;
                    }
                    System.debug('rowsCount_Chosen: '+rowsCount);
                    for(integer row = 0; row < rowsCount ;row++){
                        BrokerSelectionResponse brkrSel = new BrokerSelectionResponse();
                        brkrSel.brokerName = broker.Name ;
                        brkrSel.brokerTaxId = broker.Tax_ID__c;
                        brkrSel.brokerEmail = broker.Email;
                        brkrSel.brokerMobile = broker.MobilePhone;
                        if((row < brokerLicenseSize) && !String.isBlank(broker.Broker_Licenses__r.get(row).State__c)){
                            brkrSel.brokerLicenseState = broker.Broker_Licenses__r.get(row).State__c;
                        }else{
                            brkrSel.brokerLicenseState = 'N/A';
                        }        
                            
                        brkrSel.brokerPaidTin = broker.ContactAccountName__c;
                        /*if((row < brokerageConsultantSize) && !String.isBlank(broker.Contact_Relationships__r.get(row).Contact__r.Account_Name__c)){
                            brkrSel.contRelBrokerage = broker.Contact_Relationships__r.get(row).Contact__r.Account_Name__c;
                        }else{
                            brkrSel.contRelBrokerage = 'N/A';
                        }*/
                        for(integer conRel = 0;conRel < brokerageConsultantSize;conRel++){
                            brkrSel.contRelBrokerage = broker.Contact_Relationships__r.get(conRel).Contact__r.Account_Name__c;
                            System.debug('CR_1 '+broker.Contact_Relationships__r.get(conRel).Contact__r.Account_Name__c);
                        }
                        brokerSelResponse.add(brkrSel);           
                    }
                    
                }
            }
        }catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
			System.debug('The following exception has occurred at line: ' + e.getLineNumber());

        } 
		System.debug('brokerSelResponse3 '+brokerSelResponse);                                      
        return brokerSelResponse;
    }
    // Wrapper class to send the Response to the Broker Search page.
    public class InitializeResponse{
        //To show/hide Contact Relationship Button
        @AuraEnabled public Boolean showContactRelationshipButton;
        //To show/hide New Broker Button
        @AuraEnabled public Boolean showNewBroker;
        // Constructor for the Wrapper Class to initialize the variables.
        public InitializeResponse(){
            this.showContactRelationshipButton = false;
            this.showNewBroker = false;
        }
    }
    //Fetching State name of Opp's Account's State
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppList(String OppId) {
        return [SELECT Id, Account.Billing_State_Province__c from Opportunity where id=: OppId];
    }

    // Wrapper class to fetch the Broker Search result.
    public class BrokerSelectionResponse{
        
        @AuraEnabled public String brokerName;
        @AuraEnabled public String brokerTaxId;
        @AuraEnabled public String brokerEmail;
        @AuraEnabled public String brokerMobile;
        @AuraEnabled public String brokerLicenseState;
        @AuraEnabled public String brokerPaidTin;
        @AuraEnabled public String contRelBrokerage;
        @AuraEnabled public Boolean noDataToShow;

        // Constructor for the Wrapper Class to initialize the variables.
        public BrokerSelectionResponse(){
            this.brokerName = '';
            this.brokerTaxId = '';
            this.brokerEmail = '';
            this.brokerMobile = '';
            this.brokerLicenseState = '';
            this.brokerPaidTin = '';
            this.contRelBrokerage = '';
            this.noDataToShow = false;
        }
    }
}