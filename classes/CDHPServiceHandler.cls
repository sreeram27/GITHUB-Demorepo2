/*********************************************************************************
@author        Ranjit
@date          12th December 2018
@description   This is service handler class which we are calling from CDHP Service.
*******************************************************************************/

public class CDHPServiceHandler {
    public static String empName;
    public static String employerAddress;
    Public static Set<Id> opportunityIDFromQuote = new Set<Id>();
    public static CDHPService.CDHPFields ProcessRequest(List<CDHPService.CDHPFields> cdhpFlds1){
        String StatusCode = 'SUCCESS';       
        String StatusDescription;
        String cdhpId;
        String QuoteId;
        CDHPService.CDHPFields retCDHPFields;
        String cdhpParentId;
        //Avi changes starts'
        System.debug('cdhpFlds1------>'+cdhpFlds1);
        UpdateCDHPQuestionnaireFromISG(cdhpFlds1);
        BackSynch(cdhpFlds1);//33173 code
        for(CDHPService.CDHPFields cdhpFlds: cdhpFlds1){
            try{
                cdhpId = UpdateCDHPStatus (cdhpFlds.StatusDetails);              
                
            }catch(Exception e){
                StatusCode = 'ERROR';
                StatusDescription = e.getStackTraceString(); 
                System.debug('respFlds**********' + e.getStackTraceString());
            }
        }
        //ends
        /*try{
cdhpId = UpdateCDHPStatus (cdhpFlds1[0].StatusDetails);

}catch(Exception e){
StatusCode = 'ERROR';
StatusDescription = e.getStackTraceString(); 
System.debug('respFlds**********' + e.getStackTraceString());
}*/
        retCDHPFields = ReturnStatusDetails(StatusCode, StatusDescription, cdhpId); 
        return retCDHPFields;
    }
    /******************************************************************************
@author        Ranjit
@date          12th December 2018
@description   This is return status details.
*******************************************************************************/
    public static CDHPService.CDHPFields ReturnStatusDetails(String status, String statusDesc, String cdhpParentId)
    {
        CDHPService.CDHPFields retCDHPFields = new CDHPService.CDHPFields();
        CDHPService.StatusDetails retStatus  = new CDHPService.StatusDetails();
        retStatus.Status = status;
        retStatus.StatusMessage = statusDesc;
        retStatus.CDHPParentId = cdhpParentId;
        retCDHPFields.StatusDetails = retStatus;
        return retCDHPFields; 
    } 
    // Method is used to update the status of quote status.
    public static string UpdateCDHPStatus (CDHPService.StatusDetails StatusDetails){
        Quote objQuote;   
        boolean insertFlg = false;
        List<Quote> quoteList = new List<Quote>();
        // Assuming here we will get the Quote Id here which we will pass from SPG Dev2 , bases on quote Id 
        // We are querying the Quote and updating the status of quote. and returning the quote id. 
        if(StatusDetails.QuoteId != null){
            // Querying on quote based on quote id.
            system.debug('StatusDetails.QuoteId************:' + StatusDetails.QuoteId);
            quoteList = [SELECT id, CDHP_Questionnaire_Status__c FROM Quote 
                         WHERE Id = :StatusDetails.QuoteId];
            if(quoteList.size() > 0) {
                objQuote = quoteList[0]; 
                // Updating status of Quote
                objQuote.CDHP_Questionnaire_Status__c = StatusDetails.Status;
                update objQuote;
                return string.ValueOf(objQuote.Id);
            }
        }
        return string.valueOf(objQuote.Id);
    }
    
    
    //Avi code starts
    // this Method is to update Quote data from ISG to COM2
    public static void UpdateCDHPQuestionnaireFromISG(List<CDHPService.CDHPFields> cdhpFldsList){
        //To avoid Callout loop
        TriggerHelperUtility.setStopTrigger();
        //Set of Accounts
        Set<Id> accountIDSet = new Set<Id>();
        Set<Id> quoteIds = new Set<ID>();
        Map<Id,CDHPService.CDHPFields> cdhpFieldMap = new Map<Id,CDHPService.CDHPFields>();
        //Map to have Quote ID as Key and Account ID as Value
        Map<Id,Account> quoteAccountMap = new Map<Id,Account>();
        System.debug(cdhpFldsList);
        for(CDHPService.CDHPFields cdhpFlds: cdhpFldsList){
            quoteIds.add(cdhpFlds.StatusDetails.QuoteId);
            cdhpFieldMap.put(cdhpFlds.StatusDetails.QuoteId,cdhpFlds);
            
            System.debug('quoteIds----->'+quoteIds);
            System.debug('cdhpFieldMap----->'+cdhpFieldMap);
        }
        
        List<Quote> quotes = [SELECT Id,Name,Envelope_Number__c,Envelope_Status__c,Envelope_Sent__c,Envelope_Sent_Age__c,CDHP_Questionnaire_Status__c,Opportunity.AccountId, Opportunity.Account.name,
                              GroupNumber__c,GroupNumber__r.name,CDHP_Questionnaire_Name__c,Employer_ID_Case_Number__c
                              FROM Quote WHERE ID IN :quoteIds ];
        System.debug('quotes--->'+quotes);
        
        Set<Id> accountIDFromQuote = new Set<Id>();
       // Set<Id> opportunityIDFromQuote = new Set<Id>();
        
        List<Quote> quotesToUpdateList = new List<Quote>();
        if(quotes.size() > 0){
            for(Quote qt : quotes){
                CDHPService.CDHPFields cdhpFld = new CDHPService.CDHPFields();
                cdhpFld = cdhpFieldMap.get(qt.ID);
                System.debug('cdhpFld--->'+cdhpFld);
                System.debug('cdhpFld.docSignDetails--->'+cdhpFld.docSignDetails);
                //Update the name of the Associated Opportunity
                //qt.Opportunity.Name = cdhpFld.docSignDetails.OpportunityName;
                qt.Opportunity.Name = cdhpFld.oppDetails.OptyName;
                //qt.Name = 'testName';
                //qt.Opportunity.Account.name = cdhpFld.docSignDetails.dsfs_Company;
                if(qt.GroupNumber__c != null)
                    qt.GroupNumber__r.name = cdhpFld.grpDetails.EmployerIdCaseNumber;
                qt.CDHP_Questionnaire_Status__c = cdhpFld.docSignDetails.CDHP_Questionnaire_Name_Status;
                qt.Envelope_Number__c = cdhpFld.docSignDetails.dsfs_Envelope_Name;
                System.debug('cdhpFld.docSignDetails.dsfs_Envelope_Status--> '+cdhpFld.docSignDetails.dsfs_Envelope_Status);
                qt.Envelope_Status__c = cdhpFld.docSignDetails.dsfs_Envelope_Status;
                qt.Envelope_Sent__c = cdhpFld.docSignDetails.dsfs_Sent_Date_Time;
                qt.Envelope_Sent_Age__c = cdhpFld.docSignDetails.dsfs_Sent_Age;
                qt.CDHP_Questionnaire_Name__c = cdhpFld.CDHP_Questionnaire_Name;
                qt.Employer_ID_Case_Number__c = cdhpFld.grpDetails.EmployerIdCaseNumber;
                
                
                quotesToUpdateList.add(qt);
                //Account ID of the Quote
                accountIDFromQuote.add(qt.Opportunity.AccountID);
                //accountIDFromQuote.add(qt.AccountID);
                //OpportunityID from Quote
                opportunityIDFromQuote.add(qt.OpportunityId);
                
                //if(quoteAccountMap.containsKey(Object key))
                //quoteAccountMap.put(Opportunity.AccountId,cdhpFieldMap.get(qt.id));
                accountIDSet.add(qt.Opportunity.AccountID);
            }
        }
        System.debug('quotesToUpdateList----->'+quotesToUpdateList);
        //Update the Associated Account Details
        List<Account> accToUpdate = new List<Account>();
        map<id,Account> AccIDMap = new map<id,Account>([select id from Account where id in: accountIDFromQuote]);
        
        //Update the Associated Opportunity Details
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<id,Opportunity> oppIDMap = new Map<id,Opportunity>([select id from Opportunity where id in: opportunityIDFromQuote]);
        
        for(Quote qt : quotes)
        {
            Account acc= new Account();
            CDHPService.CDHPFields cdhpFld = new CDHPService.CDHPFields();
            cdhpFld = cdhpFieldMap.get(qt.ID);
            System.debug('cdhpFld in loop----->'+cdhpFld);
            if(AccIdMap.containsKey(qt.Opportunity.AccountId))
            {
                acc = AccIdMap.get(qt.Opportunity.AccountId);
                //acc.name=cdhpFld.docSignDetails.dsfs_Company;
                acc.name=cdhpFld.grpDetails.EmployerName;
                accToUpdate.add(acc);
            }
            
            Opportunity opp = new Opportunity();
            cdhpFld = cdhpFieldMap.get(qt.ID);
            if(oppIDMap.containsKey(qt.OpportunityId)){
                opp = oppIDMap.get(qt.OpportunityId);
                opp.name = cdhpFld.oppDetails.OptyName;
                oppToUpdate.add(opp);
            }
            
            
        }
        
        
        if(accToUpdate.size()>0){
            System.debug('accToUpdate----->'+accToUpdate);
            update accToUpdate;
        }    
        if(oppToUpdate.size() > 0 ){
            System.debug('oppToUpdate----->'+oppToUpdate);
            update oppToUpdate;
        }
        if(quotesToUpdateList.size() > 0){
            System.debug('quotesToUpdateList---->'+quotesToUpdateList);
            update quotesToUpdateList;
        }
        
        
    }
    //33173 code starts
    public static void BackSynch(List<CDHPService.CDHPFields> cdhpFldsList){
        Set<Id> quoteIds = new Set<ID>();
        Map<Id,CDHPService.CDHPFields> cdhpFieldMap = new Map<Id,CDHPService.CDHPFields>();
        
        Map<id,List<id>> quoteQLIMap = new Map<id,List<id>>();
        Map<id,HRA_Administration__c> QliIdHRAMap = new Map<id,HRA_Administration__c>();
        //Map<id,QuoteLineItem> QLImap = new Map<id,QuoteLineItem>();
        for(CDHPService.CDHPFields cdhpFld : cdhpFldsList){
            if(cdhpFld.StatusDetails.Status == 'Alegeus Completed'){
                quoteIds.add(cdhpFld.StatusDetails.QuoteId);
                cdhpFieldMap.put(cdhpFld.StatusDetails.QuoteId,cdhpFld);
                System.debug('quoteIds----->'+quoteIds);	
            }
        }
        
        Map<id,QuoteLineItem> QLImap = new Map<id,QuoteLineItem>([select Id,Quote.Opportunity.CloseDate,QuoteId, Subscribers__c, HSABankingPartner__c,
                                                                  Administrative_Fees_Responsibility__c, FSA_Plan_Options__c, FSA_Plan_End_Date__c, Transit_Plan_Option__c, 
                                                                  Parking_Plan_Option__c from QuoteLineItem where QuoteId in : quoteIds]);
        
        List<Quote> quoteList = [SELECT Id,Name,CDHP_Questionnaire_Status__c,Opportunity.AccountId, Opportunity.Account.name,GroupNumber__c,GroupNumber__r.name,CDHP_Questionnaire_Name__c,Employer_ID_Case_Number__c, ContactId,
                                 OpportunityId, AccountId FROM Quote WHERE ID IN :quoteIds ];
        
        List<HRA_Administration__c> HRA_List = [select QLI__c,HRA_Upfront_Deductible__c , HRA_Split_Percentage__c,
                                                Type_of_HRA__c, Plan_Start_Date__c, Plan_End_Date__c, HRA1_Group_Suffix__c, CapEE__c, CapEA__c,
                                                CapEChild__c, CapEChildren__c, CapEFamily__c, AllocationEA__c, Allocation_EChild__c, AllocationEChildren__c, 
                                                AllocationEE__c, AllocationFamily__c, Annual_Allocation_Tiers__c, Claim_Run_Out_Date__c, Debit_Card_Services__c, 
                                                Has_Individual_Deductible__c, Rollover_Percent_Value__c, Employee_Funds_Rollover_Next_Plan_Year__c, 
                                                HRA_Funds_to_Employees_and_on_what_basis__c, HRA_Funds_Pro_Rate_on_Entry_Date__c, Health_Activities_Incentives__c, 
                                                Health_Incentive_Type__c, Individual_Deductible_Amount__c, Rollover_Cap_Tiers__c, Member_Responsibility_by_Claim__c, 
                                                Minimum_Rollover_Amount__c, Specialty__c, Covered_Services__c, Medical__c, HRA_Rollover__c, 
                                                HRA_Rollover_Time_Period__c, Terminated_can_submit_claims_for__c, Custom_Member_Responbsibility__c, Rollover_Different_Admin__c,
                                                UpfrontDedEE__c, UpFrontDedEA__c, UpfrontDedEChild__c, UpFrontDedEEChildren__c, UpFrontDedFamily__c, Up_Front_Deductible_Tiers__c, 
                                                HRA_Lites_Rollover__c from HRA_Administration__c where QLI__c in: QLImap.keyset()];
        system.debug('HRA_List======>'+HRA_List);
        
        Set<Id> accountIDFromQuote = new Set<Id>();
        Set<Id> opportunityIDFromQuote = new Set<Id>();
        Set<Id> contactIDFromQuote = new Set<Id>();
        Set<Id> groupIdFromeQuote = new Set<Id>();
        
        for(HRA_Administration__c hraAd: HRA_List) {
            if(QliIdHRAMap.containsKey(hraAd.QLI__c)) {
                //QliIdHRAMap.get(hraAd.QLI__c).add(hraAd);
            } else {
                QliIdHRAMap.put(hraAd.QLI__c, hraAd);
            }
        }
        system.debug('QliIdHRAMap======>'+QliIdHRAMap);
        for(QuoteLineItem qli: QLImap.values()) {
            if(quoteQLIMap.containsKey(qli.QuoteId)) {
                quoteQLIMap.get(qli.QuoteId).add(qli.id);
            } else {
                quoteQLIMap.put(qli.QuoteId, new List<Id> { qli.id });
            }
        }
        for(Quote qt : quoteList)
        {
            contactIDFromQuote.add(qt.contactId);
            accountIDFromQuote.add(qt.accountId);
            opportunityIDFromQuote.add(qt.OpportunityId);
            groupIdFromeQuote.add(qt.GroupNumber__c);
        }
        //Update Account details
        List<Account> accToUpdate = new List<Account>();
        Map<id,Account> AccIDMap = new map<id,Account>([select id from Account where id in: accountIDFromQuote]);
        
        //Update the Associated Opportunity Details
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        Map<id,Opportunity> oppIDMap = new Map<id,Opportunity>([select id from Opportunity where id in: opportunityIDFromQuote]);
        //Update Contact Details
        List<Contact> conToUpdate = new List<Contact>();
        map<id,Contact> conIDMap = new map<id,Contact>([select id from Contact where id in: contactIDFromQuote]);
        
        Map<id,Group__c> grpIDMap = new Map<id,Group__c>([select id from Group__c where id in: groupIdFromeQuote]);
        List<Group__c> grpToUpdate = new List<Group__c>();
		//Broker Part start
        Map<id,Brokerage_and_Consultant__c> AccBrokerMap = new Map<id,Brokerage_and_Consultant__c>();
		List<Brokerage_and_Consultant__c>  brokerList = [select id, Account__c,Consultant__c, Consultant__r.Contact__c from Brokerage_and_Consultant__c where Account__c
                                                        in: accountIDFromQuote];
        
        System.debug('broker List '+brokerList);
        
        map<id,id> AcccontactId =new map<id,id>();
        map<id,id> AccCosRelId =new map<id,id>();
        for(Brokerage_and_Consultant__c b: brokerList){
            AcccontactId.put(b.Account__c,b.Consultant__r.Contact__c);
            AccCosRelId.put(b.Account__c,b.Consultant__c);
        }
        Map<id,Contact> ContactIDMap =new Map<id,Contact>([select id from Contact where id in:
                                               AcccontactId.values()]);
        
        Map<id,ContactRelationship__c> CosRelIDMap =new Map<id,ContactRelationship__c>([select id from ContactRelationship__c where id in:
                                               AccCosRelId.values()]);
        List<ContactRelationship__c> brokerToUpdate =  new List<ContactRelationship__c>();
        //Broker part end
        System.debug('AcccontactId List '+AcccontactId);
        System.debug('AccCosRelId List '+AccCosRelId);
        System.debug('ContactIDMap List '+ContactIDMap);
        System.debug('CosRelIDMap List '+CosRelIDMap);
		
        for(Quote qt : quoteList)
        {
            Account acc= new Account();
            CDHPService.CDHPFields cdhpFld = new CDHPService.CDHPFields();
            cdhpFld = cdhpFieldMap.get(qt.ID);
            System.debug('cdhpFld in loop----->'+cdhpFld);
            if(AccIdMap.containsKey(qt.Opportunity.AccountId))
            {
                acc = AccIdMap.get(qt.Opportunity.AccountId);
                acc.name=cdhpFld.CDHPar.EmployerName;
                acc.Tax_ID__c = cdhpFld.CDHPar.TaxId;
                acc.Eligible_Employees__c = cdhpFld.CDHPar.NumberOfEligibleEmpl;
                acc.Branding__c = cdhpFld.CDHPar.Brand;
                accToUpdate.add(acc);
            }
            
            Opportunity opp = new Opportunity();
            //cdhpFld = cdhpFieldMap.get(qt.ID);
            if(oppIDMap.containsKey(qt.OpportunityId)){
                opp = oppIDMap.get(qt.OpportunityId);
                opp.CloseDate = cdhpFld.CDHPar.Effective_Date;
                oppToUpdate.add(opp);
            }   
            Contact con = new Contact();
            //cdhpFld = cdhpFieldMap.get(qt.ID);
            if(conIDMap.containsKey(qt.ContactId)){
                con = conIDMap.get(qt.ContactId);
                /*con.FirstName = cdhpFld.CDHPar.Employer_Contact_Name_1.split(' ')[0];
                con.LastName = cdhpFld.CDHPar.Employer_Contact_Name_1.split(' ')[1];*/
                Integer result;
                if(cdhpFld.CDHPar.Employer_Contact_Name_1 != null)
                	result = cdhpFld.CDHPar.Employer_Contact_Name_1.indexOf(' ');
                if(result != null && cdhpFld.CDHPar.Employer_Contact_Name_1.substring(0, result) != null)
                	con.FirstName = cdhpFld.CDHPar.Employer_Contact_Name_1.substring(0, result);
                if(result != null && cdhpFld.CDHPar.Employer_Contact_Name_1.substring(result+1) != null)
                	con.LastName = cdhpFld.CDHPar.Employer_Contact_Name_1.substring(result+1);
                if(cdhpFld.CDHPar.Employer_Contact_Phone_1 != null)
                	con.Phone = cdhpFld.CDHPar.Employer_Contact_Phone_1;
                if(cdhpFld.CDHPar.Employer_Contact_Email_1 != null)
                	con.Email = cdhpFld.CDHPar.Employer_Contact_Email_1;
                conToUpdate.add(con);
            }   	
            Group__c grp = new Group__c();
            //cdhpFld = cdhpFieldMap.get(qt.ID);
            if(grpIDMap.containsKey(qt.GroupNumber__c)){
                grp = grpIDMap.get(qt.GroupNumber__c);
                grp.name = cdhpFld.CDHPar.EmployerIdCaseNumber;
                grpToUpdate.add(grp);
            }   
           //Broker Part 
            if(AcccontactId.containsKey(qt.Opportunity.AccountId))
            {
                id cun= AcccontactId.get(qt.Opportunity.AccountId);
                Contact CRecord = new Contact();
                if(ContactIDMap.containsKey(cun))
                {
                    CRecord = ContactIDMap.get(cun);
                    CRecord.Phone = cdhpFld.CDHPar.Broker_Consultant_Contact_Phone;
                    CRecord.Email = cdhpFld.CDHPar.Broker_Consultant_Contact_Email;
                    conToUpdate.add(CRecord);
                }
                
            }
            if(AccCosRelId.containsKey(qt.Opportunity.AccountId))
            {
                id cos= AccCosRelId.get(qt.Opportunity.AccountId);
                ContactRelationship__c CRecord = new ContactRelationship__c();
                if(CosRelIDMap.containsKey(cos))
                {
                    CRecord = CosRelIDMap.get(cos);
                    //CRecord.Name = cdhpFld.CDHPar.Broker_Consultant_Contact_Name;
                    brokerToUpdate.add(CRecord);
                }
                
            }
            
            //Broker Part end
        }
        if(brokerToUpdate.size()>0){
            System.debug('brokerToUpdate----->'+brokerToUpdate);
            update brokerToUpdate;
        } 
        if(accToUpdate.size()>0){
            System.debug('accToUpdate----->'+accToUpdate);
            update accToUpdate;
        }    
        if(oppToUpdate.size() > 0 ){
            System.debug('oppToUpdate----->'+oppToUpdate);
            update oppToUpdate;
        }
        if(conToUpdate.size() >0){
            update conToUpdate;
        }
        if(grpToUpdate.size() >0){
            update grpToUpdate;
        }
        
        updateFSA_Comm_HSA(cdhpFieldMap, QLImap, QliIdHRAMap);
        //System.debug('quotes--->'+quotes);
        
    }
    public static void updateFSA_Comm_HSA(Map<Id,CDHPService.CDHPFields> cdhpFieldMap,  Map<id,QuoteLineItem> QLImap,Map<id,HRA_Administration__c> QliIdHRAMap){
        
        List<QuoteLineItem> qLIToUpdate = new List<QuoteLineItem>();
        List<HRA_Administration__c> hraToUpdate = new List<HRA_Administration__c>();
        List<CDHPService.CDHPFSAAccount> newLstFsa = new List<CDHPService.CDHPFSAAccount>();
        List<CDHPService.CDHPHSAAccount> newLstHsa =new List<CDHPService.CDHPHSAAccount>();
        List<CDHPService.CDHPCommuterAccount> newLstComm = new List<CDHPService.CDHPCommuterAccount>();
        List<CDHPService.CDHPHRARepeatingAccount> newLstHra = new List<CDHPService.CDHPHRARepeatingAccount>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id,CloseDate from Opportunity where Id In : opportunityIDFromQuote]);
		List<Opportunity> oppLst = new List<Opportunity>();
        CDHPService.CDHParDetails cdhpParentDtls = new CDHPService.CDHParDetails();
        for(CDHPService.CDHPFields cdhpfld : cdhpFieldMap.values()){
            //map<id,CDHPService.CDHPFields> fsaMapValues= new map<id,CDHPService.CDHPFields>();
            system.debug('cdhpfld.CDHPFSAList--->'+cdhpfld.CDHPFSAList);
            if(cdhpfld.CDHPFSAList != NULL){
                if(!cdhpfld.CDHPFSAList.isEmpty())
                    newLstFsa = cdhpfld.CDHPFSAList;
            }
            system.debug('cdhpfld.CDHPHSAList--->'+cdhpfld.CDHPHSAList);
            if(cdhpfld.CDHPHSAList != NULL){
                if(!cdhpfld.CDHPHSAList.isEmpty())
                    newLstHsa = cdhpfld.CDHPHSAList;
            }
            system.debug('cdhpfld.CDHPCommuterList--->'+cdhpfld.CDHPCommuterList);
            if(cdhpfld.CDHPCommuterList != NULL){
                if(!cdhpfld.CDHPCommuterList.isEmpty())
                    newLstComm = cdhpfld.CDHPCommuterList;
            }
            system.debug('cdhpfld.CDHPHRAList--->'+cdhpfld.CDHPHRAList);
            if(cdhpfld.CDHPHRAList != NULL){
                if(!cdhpfld.CDHPHRAList.isEmpty())
                    newLstHra = cdhpfld.CDHPHRAList;
            }
            system.debug('cdhpfld.CDHPar--->'+cdhpfld.CDHPar);
			if(cdhpfld.CDHPar != null)
                    cdhpParentDtls = cdhpfld.CDHPar;
        }
        for(CDHPService.CDHPFSAAccount fsa : newLstFsa){
            QuoteLineItem q1=new QuoteLineItem();
            q1 = QLImap.get(fsa.SF_Quote_Item_Id);
            String fsaPlanType;
            if(fsa.FSA_Section_213_d_Plan){
                if(String.isBlank(fsaPlanType)){
                    fsaPlanType='FSA Section 213d Plan';
                }
                else {
                    fsaPlanType=fsaPlanType+';';
                    fsaPlanType=fsaPlanType+'FSA Section 213d Plan';
                }
            }
            if(fsa.Limited_Purpose_FSA_Plan){
                if(String.isBlank(fsaPlanType)){
                    fsaPlanType = 'Limited Purpose FSA Plan';
                }
                else {
                    fsaPlanType=fsaPlanType+';';                        
                    fsaPlanType=fsaPlanType+'Limited Purpose FSA Plan';
                }
            }
            if(fsa.Dependent_Care_FSA_Plan){
                if(String.isBlank(fsaPlanType)){
                    fsaPlanType = 'Dependent Care FSA Plan';
                }
                else {
                    fsaPlanType=fsaPlanType+';';
                    fsaPlanType=fsaPlanType+'Dependent Care FSA Plan';
                }
            }
            q1.FSA_Plan_Options__c = fsaPlanType;
            q1.FSA_Plan_End_Date__c = fsa.FSA_Plan_End_Date;
            q1.Subscribers__c = cdhpParentDtls.EstimatedNumberOfParticipanets;
            
            qLIToUpdate.add(q1);
            System.debug('qLIToUpdate ---->>>>> '+qLIToUpdate);
            
            
			if(oppMap.containsKey(q1.Quote.OpportunityId) && oppMap.get(q1.Quote.OpportunityId) != null){
				Opportunity oppNew = oppMap.get(q1.Quote.OpportunityId);
				oppNew.CloseDate = fsa.FSA_Plan_Start_Date;
				oppLst.add(oppNew);
			}
			
            
			if(oppLst.size() > 0){
				System.debug('oppLst ---->>>> '+oppLst);
				update oppLst;
			}
        }
        for(CDHPService.CDHPHSAAccount hsa : newLstHsa){
            QuoteLineItem q1=new QuoteLineItem();
            q1 = QLImap.get(hsa.SF_Quote_Item_Id);
            
            q1.HSABankingPartner__c = hsa.HSA_Custodian;
            q1.Administrative_Fees_Responsibility__c = hsa.Administrative_Fees_Responsibility;
            q1.Subscribers__c = cdhpParentDtls.EstimatedNumberOfParticipanets;
            qLIToUpdate.add(q1);
        }
        for(CDHPService.CDHPCommuterAccount com : newLstComm){
            QuoteLineItem q1=new QuoteLineItem();
            q1 = QLImap.get(com.SF_Quote_Item_Id);
            
            q1.Transit_Plan_Option__c = com.Transit_Plan_Option;
            q1.Parking_Plan_Option__c = com.Parking_Plan_Option;
            q1.Subscribers__c = cdhpParentDtls.EstimatedNumberOfParticipanets;
            qLIToUpdate.add(q1);
        }
        //Boolean flag=false;//To check Type of HRA
        system.debug('QliIdHRAMap, inside func======>'+QliIdHRAMap);
        system.debug('newLstHra--->'+newLstHra);
        for(CDHPService.CDHPHRARepeatingAccount hra : newLstHra){
            QuoteLineItem q1=new QuoteLineItem();
            q1 = QLImap.get(hra.SF_Quote_Item_Id);
			q1.Subscribers__c = cdhpParentDtls.EstimatedNumberOfParticipanets;
            qLIToUpdate.add(q1);
            HRA_Administration__c h1=new HRA_Administration__c();
            String HRA_Debit_CardDS;
            String HRA_Health_Act;
            String TypeOfHRA;
            String Specialty;
            String CoveredServices;
            String Medical;
            h1 = QliIdHRAMap.get(hra.SF_Quote_Item_Id);
            h1.Plan_Start_Date__c= hra.HRA_Plan_Start_Date;
            h1.Plan_End_Date__c=hra.HRA_Plan_End_Date;
            h1.HRA1_Group_Suffix__c=hra.HRA1_Group_Suffix;
            h1.CapEE__c = hra.HRA_Ann_Roll_Cap_Amt_Emp;
            h1.CapEA__c = hra.HRA_Ann_Roll_Cap_Amt_Emp_Adult;
            h1.CapEChild__c = hra.HRA_Ann_Roll_Cap_Amt_Emp_Child;
            h1.CapEChildren__c = hra.HRA_Ann_Roll_Cap_Amt_Emp_Children;
            h1.CapEFamily__c = hra.HRA_Ann_Roll_Cap_Amt_Family;
            h1.AllocationEA__c = hra.HRA_Annual_Alloc_Amt_Emp_Adult;
            h1.Allocation_EChild__c = hra.HRA_Annual_Alloc_Amt_Emp_Child;
            h1.AllocationEChildren__c = hra.HRA_Annual_Alloc_Amt_Emp_Children;
            h1.AllocationEE__c = hra.HRA_Annual_Alloc_Amt_Employee;
            h1.AllocationFamily__c = hra.HRA_Annual_Alloc_Amt_Family;
            h1.Annual_Allocation_Tiers__c = hra.HRA_Annual_Allocation_Tier_Selection;
            h1.Claim_Run_Out_Date__c = hra.HRA_Claim_Run_Out_Date;
            if(cdhpParentDtls.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay != null && cdhpParentDtls.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay){
				h1.HRA_Upfront_Deductible__c = 'Yes';
			}
            else if(cdhpParentDtls.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay != null && !cdhpParentDtls.Prov_Pay_HRA_w_Upfront_Ded_and_Auto_Pay){
                h1.HRA_Upfront_Deductible__c = 'No';
            }
            if(cdhpParentDtls.HRA_Rollover != null && cdhpParentDtls.HRA_Rollover){
				h1.HRA_Rollover__c = 'Yes';
			}
            else if(cdhpParentDtls.HRA_Rollover != null && !cdhpParentDtls.HRA_Rollover){
                h1.HRA_Rollover__c = 'No';
            }
            if(cdhpParentDtls.Provider_Pay_Split_HRA != null && cdhpParentDtls.Provider_Pay_Split_HRA){
				h1.HRA_Split_Percentage__c = 'Yes';
			}
            else if(cdhpParentDtls.Provider_Pay_Split_HRA != null && !cdhpParentDtls.Provider_Pay_Split_HRA){
                h1.HRA_Split_Percentage__c = 'No';
            }
            if(cdhpParentDtls.Member_Pay_HRA_with_Debit_Card != null && cdhpParentDtls.Member_Pay_HRA_with_Debit_Card){
				h1.Type_of_HRA__c = 'Member Pay (debit card) Only';
			}
            if(cdhpParentDtls.HRA_Provider_Pay != null && cdhpParentDtls.HRA_Provider_Pay){
				h1.Type_of_HRA__c = 'Auto-Pay Provider Only';
                h1.HRA_Upfront_Deductible__c = 'No';
                h1.HRA_Split_Percentage__c = 'No';
			}
                        
                
            if(hra.HRA_Debit_Card_Dental_Services){
                if(String.isBlank(HRA_Debit_CardDS)){
                    HRA_Debit_CardDS='Dental';
                }
                else {
                    HRA_Debit_CardDS=HRA_Debit_CardDS+';';
                    HRA_Debit_CardDS=HRA_Debit_CardDS+'Dental';
                }
            }
            if(hra.HRA_Debit_Card_Medical_Services){
                if(String.isBlank(HRA_Debit_CardDS)){
                    HRA_Debit_CardDS='Medical';
                }
                else {
                    HRA_Debit_CardDS=HRA_Debit_CardDS+';';
                    HRA_Debit_CardDS=HRA_Debit_CardDS+'Medical';
                }
            }
            if(hra.HRA_Debit_Card_OTC_Services){
                if(String.isBlank(HRA_Debit_CardDS)){
                    HRA_Debit_CardDS='OTC';
                }
                else {
                    HRA_Debit_CardDS=HRA_Debit_CardDS+';';
                    HRA_Debit_CardDS=HRA_Debit_CardDS+'OTC';
                }
            }
            if(hra.HRA_Debit_Card_Rx_Services){
                if(String.isBlank(HRA_Debit_CardDS)){
                    HRA_Debit_CardDS='Pharmacy';
                }
                else {
                    HRA_Debit_CardDS=HRA_Debit_CardDS+';';
                    HRA_Debit_CardDS=HRA_Debit_CardDS+'Pharmacy';
                }
            }
            if(hra.HRA_Debit_Card_Vision_Services){
                if(String.isBlank(HRA_Debit_CardDS)){
                    HRA_Debit_CardDS='Vision';
                }
                else {
                    HRA_Debit_CardDS=HRA_Debit_CardDS+';';
                    HRA_Debit_CardDS=HRA_Debit_CardDS+'Vision';
                }
            }
            
			h1.Debit_Card_Services__c= HRA_Debit_CardDS;
            h1.Has_Individual_Deductible__c = hra.HRA_Embedded_Ded;
			if(hra.HRA_Employee_Funds_Rollover_Amounts!=null)
				h1.Rollover_Percent_Value__c = integer.valueof(hra.HRA_Employee_Funds_Rollover_Amounts); 
            h1.Employee_Funds_Rollover_Next_Plan_Year__c = hra.HRA_Employee_Funds_Rollover_Options;
            h1.HRA_Funds_to_Employees_and_on_what_basis__c = hra.HRA_Fund_Allocation;
            h1.HRA_Funds_Pro_Rate_on_Entry_Date__c = hra.HRA_Funding_Pro_Rate;
            if(hra.HRA_Health_Activities !=null && hra.HRA_Health_Activities.contains('Yes'))
            	HRA_Health_Act = 'Yes';
            else if(hra.HRA_Health_Activities !=null && hra.HRA_Health_Activities.contains('No'))
                HRA_Health_Act = 'No';
            h1.Health_Activities_Incentives__c = HRA_Health_Act;    
            h1.Health_Incentive_Type__c = hra.HRA_Health_Activities_Options;
            h1.Individual_Deductible_Amount__c = hra.HRA_Individual_Embedded_Ded_Amt;
            h1.Rollover_Cap_Tiers__c = hra.HRA_Max_Rollover_Amt_Cap_Tier;
            h1.Member_Responsibility_by_Claim__c = hra.HRA_Member_Responsibility_by_Claim;
            h1.Minimum_Rollover_Amount__c = hra.HRA_Min_Rollover_Amt;
            if(hra.HRA_Prov_Pay_Med_w_Opt_Rx_Den_Vis_Deb_Cd)
            	TypeOfHRA = 'Provider Pay Medical with Optional Rx/Dental/Vision Debit Card';
            h1.Type_of_HRA__c = TypeOfHRA;
            if(hra.HRA_ProvPay_Opt_DebCd_Dental_Option){
                if(String.isBlank(Specialty)){
                    Specialty='Dental (Debit Card)';
                }
                else {
                    Specialty=Specialty+';';
                    Specialty=Specialty+'Dental (Debit Card)';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_Vision_Option){
                if(String.isBlank(Specialty)){
                    Specialty='Vision (Debit Card)';
                }
                else {
                    Specialty=Specialty+';';
                    Specialty=Specialty+'Vision (Debit Card)';
                }
            }
            
            h1.Specialty__c = Specialty;
            
          
            if(hra.HRA_ProvPay_Opt_DebCd_INN_Med_Coins){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='In Network Coinsurance';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'In Network Coinsurance';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_INN_Med_Copay){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='In Network Copays';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'In Network Copays';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_INN_Med_Ded){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='In Network Medical Deductible';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'In Network Medical Deductible';
                }
            }
         
            if(hra.HRA_ProvPay_Opt_DebCd_ONN_Med_Coins){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='Out of Network Coinsurance';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'Out of Network Coinsurance';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_ONN_Med_Copay){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='Out of Network Copays';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'Out of Network Copays';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_ONN_Med_Ded){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='Out of Network Medical Deductible';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'Out of Network Medical Deductible';
                }
            }
            if(hra.HRA_ProvPay_Opt_DebCd_Rx_Option){
                if(String.isBlank(CoveredServices)){
                    CoveredServices='Rx';
                }
                else {
                    CoveredServices=CoveredServices+';';
                    CoveredServices=CoveredServices+'Rx';
                }
            }
            
            
            h1.Covered_Services__c = CoveredServices;
            if(hra.HRA_ProvPay_Opt_DebCd_Medical){
                if(String.isBlank(Medical)){
                    Medical='Provider Pay';
                }
                else {
                    Medical=Medical+';';
                    Medical=Medical+'Provider Pay';
                }
            }
            h1.Medical__c = Medical;
            if(hra.HRA_Rollover != null && hra.HRA_Rollover)
            	h1.HRA_Rollover__c = 'Yes';
            else if(hra.HRA_Rollover_Offer != null && hra.HRA_Rollover_Offer == 'Yes')
                h1.HRA_Rollover__c = hra.HRA_Rollover_Offer;
            else if(hra.HRA_Rollover_Offer != null && hra.HRA_Rollover_Offer == 'No')
                h1.HRA_Rollover__c = hra.HRA_Rollover_Offer;
            //h1.HRA_Rollover_Date_recommend_3_months__c = hra.HRA_Rollover_Date_recommend_3_months;
            //h1.HRA_Rollover_Offer__c = hra.HRA_Rollover_Offer;
            h1.Terminated_can_submit_claims_for__c = hra.HRA_Termed_Emp_Claims_Run_out_Deadline;
			if(hra.HRA_Terminated_Employees_Other_Value != null)
				h1.Custom_Member_Responbsibility__c = integer.valueof(hra.HRA_Terminated_Employees_Other_Value);
            h1.Rollover_Different_Admin__c = hra.HRA_Unused_rollovrfund_diff_Adm_last_yr;
            h1.UpfrontDedEE__c = hra.HRA_Upfront_Ded_Amt_Emp;
            h1.UpFrontDedEA__c = hra.HRA_Upfront_Ded_Amt_Emp_Adult;
            h1.UpfrontDedEChild__c = hra.HRA_Upfront_Ded_Amt_Emp_Child;
            h1.UpFrontDedEEChildren__c = hra.HRA_Upfront_Ded_Amt_Emp_Children;
            h1.UpFrontDedFamily__c = hra.HRA_Upfront_Ded_Amt_Family;
            h1.Up_Front_Deductible_Tiers__c = hra.HRA_Upfront_Deductible_Tier_Selection;
            h1.HRA_Lites_Rollover__c = hra.Legacy_Lumenos_HRA;
            if(hra.Member_Pay_HRA_with_Debit_Card)
            	h1.Type_of_HRA__c = 'Member Pay (debit card) Only';
            
            if(hra.Provider_Pay_Split_HRA)
            	h1.HRA_Split_Percentage__c = 'Yes';
            else 
                h1.HRA_Split_Percentage__c = 'No';
            
            hraToUpdate.add(h1);
        }
        
        if(qLIToUpdate.size()>0)
            update qLIToUpdate;
        if(hraToUpdate.size()>0)
            update hraToUpdate;
        
    }
    //33173 code ends
    
}