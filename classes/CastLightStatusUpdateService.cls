@RestResource(urlMapping = '/CSLTStatusUpdate/*')
global class CastLightStatusUpdateService{
 
    @HttpPost
    global static void doPost() {
        
        CastLightRequestResponse data;
        //ResponseWrapper res = new ResponseWrapper();
        RestResponse res = RestContext.response;
        try {
            Organization org = [select id, issandbox, instancename from organization];
            data = (CastLightRequestResponse) JSON.deserialize(RestContext.request.requestBody.toString(), CastLightRequestResponse.class);
            system.debug('Req body--->'+RestContext.request.requestBody.toString());
            system.debug('deserializedstring--->' + data);
            
            system.debug('fetched---' + data.Accounts);
            
            List < Castlight_Opportunity__c > castlightoppfullist= new List < Castlight_Opportunity__c > ();
            List<Engage_Scoping_And_Engage_Standard__c> engageformlist=new List<Engage_Scoping_And_Engage_Standard__c>();
            set<Id> engagestandardscopingformid=new set<Id>();
            Map<Id,string> engageformid=new Map<Id,string>();
            
            Castlight_Opportunity__c o;
            for(CastLightRequestResponse.Account eachacc: data.Accounts)
            {
                
                for(CastLightRequestResponse.Opportunity eachopp: eachacc.Opportunities)
                {
                    
                    o = new Castlight_Opportunity__c();
                    o.CSLT_Account_Owner__c = eachacc.CSLT_AccountOwnerName;
                    system.debug('Account Owner Name:' + eachacc.CSLT_AccountOwnerName);
                    o.CSLT_Acnt_Owner_Email__c = eachacc.CSLT_AccountOwnerEmail;
                    system.debug('Account Owner Email:' + eachacc.CSLT_AccountOwnerEmail);
                    if(eachacc.CSLT_Open_Enrollment_End_Date!=null)
                    {
                    o.CSLT_OE_End_Date__c = Date.valueof(eachacc.CSLT_Open_Enrollment_End_Date);
                     system.debug('Account open enrollment end date:' + eachacc.CSLT_Open_Enrollment_End_Date);
                    }
                    if(eachacc.CSLT_Open_Enrollment_Start_Date!=null)
                    {
                    o.CSLT_OE_Start_Date__c = Date.valueof(eachacc.CSLT_Open_Enrollment_Start_Date);
                    system.debug('Account start enrollment:' + eachacc.CSLT_Open_Enrollment_Start_Date);
                    }
                    o.CSLT_OE_Type__c = eachacc.CSLT_Open_Enrollment_Type;
                    system.debug('Account enrollment type:' + eachacc.CSLT_Open_Enrollment_Type);
                    o.AccountId__c = eachacc.AccountID;
                    system.debug('Anthem Account Id:' + eachacc.AccountID);
                    o.SF_Org_Name__c = eachacc.AnthemORGID;
                    system.debug('Anthem SF Org Id:' + eachacc.AnthemORGID);
                    if(eachopp.CSLT_CloseDate!=null)
                    {
                    o.CSLT_Opp_Close_Date__c = Date.valueof(eachopp.CSLT_CloseDate);
                    system.debug('Opportunity CSLT_CloseDate:' + eachopp.CSLT_CloseDate);
                    }
                    o.CSLT_Opportunity_Stage__c = eachopp.CSLT_StageName;
                    system.debug('Opportunity stagename:' + eachopp.CSLT_StageName);
                    o.CSLT_Opportunity_Id__c = eachopp.CSLT_OpportunityID;
                    system.debug('Opportunity id from CSLT:' + eachopp.CSLT_OpportunityID);
                    o.OpportunityId__c = eachopp.OpportunityID;
                    system.debug('Anthem Opportunity Id:' + eachopp.OpportunityID);
                    castlightoppfullist.add(o);
                    if(eachopp.ScopingForms!=null)
                    {
                    for(CastLightRequestResponse.ScopingForm eachscopform:eachopp.ScopingForms)
                    {
                        if(eachscopform.CSLTFormStatus!=null && eachscopform.CSLTFormStatus!='')
                        {
                            engagestandardscopingformid.add(eachscopform.AnthemRecordID);
                            engageformid.put(eachscopform.AnthemRecordID,eachscopform.CSLTFormStatus);
                            
                        }
                    }
                    }
                    if(eachopp.StandardForms!=null)
                    {
                        for(CastLightRequestResponse.StandardForm  eachstandardform:eachopp.StandardForms)
                    {
                        if(eachstandardform.CSLTFormStatus!=null && eachstandardform.CSLTFormStatus!='')
                        {
                            engagestandardscopingformid.add(eachstandardform.AnthemRecordID);
                            engageformid.put(eachstandardform.AnthemRecordID,eachstandardform.CSLTFormStatus);
                            
                        }
                    }
                    }
                    
                }
                
                
            }
            system.debug('castlightoppfullist:'+castlightoppfullist);
            system.debug('engagestandardscopingformid:'+engagestandardscopingformid);
            
            if (!castlightoppfullist.isempty() || castlightoppfullist.size() > 0) {
                upsert castlightoppfullist CSLT_Opportunity_Id__c;
            }
            if(engagestandardscopingformid.size() >0)
            {
            for(Engage_Scoping_And_Engage_Standard__c eachform: [select id,Form_Status__c from Engage_Scoping_And_Engage_Standard__c where id in :engagestandardscopingformid])
            {
                eachform.Form_Status__c=engageformid.get(eachform.id);
                engageformlist.add(eachform);
                
            }
            if(!engageformlist.isempty() || engageformlist.size() > 0)
            {
                update engageformlist;
            }
                
            }
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('Opportunity status processed successfully');
            //added for SIT testing purpose
            if(org.IsSandbox){
            	CastLightProcessBatchStatus.CSLTToAnthProcessStatusEmail(RestContext.request.requestBody.toString(), 'Success');
            }

        }
        Catch(Exception ex) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(String.valueOf(ex) + '\n\n' + ex.getStackTraceString());
            
            CastLightProcessBatchStatus.CSLTToAnthProcessStatusEmail(RestContext.request.requestBody.toString(), String.valueOf(ex) + '\n\n' + ex.getStackTraceString());
          
        }
        
        //return res;
    }
}