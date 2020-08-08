/*
@author         Accenture offshore
@date           12/07/2017
@name           ANA_AP14_IGAPRenewalOpportunity
@description    Used in vlocity omniscript to create a quote & quote line item records under renewal opportunity clone.  
Request : 
#1021
If the IGAP opportunity stage is Closed Won/Initiated/Quoting/Submitted to Customer/Finalist/Verbal Commitment, then the products & programs: 
a) In an IGAP Dead/IGAP Lost should NOT appear on the quote after the cloned Renewal opportunity record is created. 
b) In a IGAP Sold/IGAP In Progress should appear on the quote after the cloned Renewal opportunity record is created.
*/
public with sharing class ANA_AP14_IGAPRenewalOpportunity {
    
    private static final String OPPSTAGCW='Closed Won';
    private static final String OPPINIT='Initiated'; 
    private static final String OPPSQUOTE='Quoting';
    private static final String OPPSSTOC='Submitted to Customer';
    private static final String OPPSFINA='Finalist';
    private static final String OPPSVERBCOMM='Verbal Commitment';
    private static final String OPPSTRQRY = 'Select id,closedate,ParentOppty__c from Opportunity where recordtypeId =:devRecordTypeId and ParentOppty__c=:oppnewid '+
                              ' and accountId=: oppaccid and StageName IN:setoppstage ORDER BY CreatedDate ASC';
    //and ParentOppty__c=:oppnewid --> As per latest KAD 1196 removed the condition
    public static final string IGAPNAME='In Group Add Product'; 
    public static final string STRQRY='';
    private static list<opportunity> listigapopps;
    private static set<string> setoppstage;
    private static Id devRecordTypeId;
    private static String oppnewid;
    private static String oppaccid;
    /*Method returns list of opportunity ids related to IGAP*/
    public static list<opportunity> getOpportunityids(Opportunity opprec){
        listigapopps = new list<opportunity>();
        setoppstage = new set<string>{OPPSTAGCW,OPPINIT,OPPSQUOTE,OPPSSTOC,OPPSFINA,OPPSVERBCOMM};
        // Start : Deloitte Offshore
        //if([Select Name from Profile where ID =: userinfo.getProfileId()].Name == 'Local Sales')
        if( ([Select Name from Profile where ID =: userinfo.getProfileId()].Name == 'Local Sales') ||( [Select Name from Profile where ID =: userinfo.getProfileId()].Name == 'Local Sales Dual'))
        {
            devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('In Group Add Product Local').getRecordTypeId();
        }
        // End
        else
        {
            devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(IGAPNAME).getRecordTypeId();
        }
        oppnewid = opprec.id;
        oppaccid = opprec.accountid;
       
        for(Opportunity opp: Database.query(OPPSTRQRY)){
            listigapopps.add(opp);
        }
        return listigapopps;
    }
}