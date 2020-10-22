/*
@Author : Accenture Offshore Dev team
@name : ANA_AP07_ServiceProviderRecord
@CreateDate : 12-06-2017
@Description : This class is used to create or update the Service Provider Relationship when the QLI record get updated
*/
public class ANA_AP07_ServiceProviderRecord {
    private static final string SYMB='-';
    private static final string SOLD='Sold';
    private static final string LOST='Lost';
    private static final string IGAPSOLD='IGAP Sold';
    private static final string IGAPLOST='IGAP Lost';
    private static final string TERMED='Termed';
    private static final string STRBLANK='';
    @Testvisible private static set<Id> qlineitemids = new set<Id>();
    @Testvisible private static set<string> setqlaccids = new set<string>();
    @Testvisible private static set<string> setqlcompids = new set<string>();
    @Testvisible private static map<String,ServiceProviderRelationship__c> mapsprrecord = new map<String,ServiceProviderRelationship__c>();
    @Testvisible private static set<string> setprodstage= new set<string>();
    private static final String SELECT_SPR ='Select Id,Account__c,Vendor__c,Competitor__c \n'+
                                            ' from ServiceProviderRelationship__c where \n'+
                                            ' Account__c IN: setqlaccids and Vendor__c IN: setqlcompids limit 1000';
    
    private static final String SELECT_SPR2 ='Select Id,Account__c,Vendor__c,Competitor__c from \n'+    
                                             ' ServiceProviderRelationship__c where Id IN: setsprids limit 100';
    
    private static final String SELECT_QL = 'Select Id,associatedAccountId__c,Competitor__c,Competitor_Won__c from Quotelineitem \n'+
                                            ' where id IN : qlineitemids limit 100';                                         
                                
    /*
    The method is used to Create/ update the Service Provider Relationship record when Quote line item 
    product stage values with “Sold”, “Lost”, “IGAP Sold”, “IGAP Lost”, “Termed”.
    */
    public static void serviceProviderRecordupsert(map<Id,QuotelineItem> mapqlitem){
        setprodstage = new set<string>{SOLD,LOST,IGAPSOLD,IGAPLOST,TERMED};     
        setqlaccids = new set<string>();
        setqlcompids = new set<string>();
        mapsprrecord = new map<String,ServiceProviderRelationship__c>();
        //list<ServiceProviderRelationship__c> listsproreq = new list<ServiceProviderRelationship__c>();
        assignsetidalignment(mapqlitem);
        //setqlcompids.add(null);
        setSPRidalignment();
        list<ServiceProviderRelationship__c> sprlist = listSPRassignment(mapqlitem);
        if(!sprlist.isEmpty()){
            qlineitemids.addAll(mapqlitem.keyset());
            assignsprtoqlitem(sprlist,mapqlitem);
        }
    }
    /*This method is used to add the QuotelineItem Account Id & Competitor ids into set*/
    public static void assignsetidalignment(map<Id,QuotelineItem> mapqlitem){
        for(Id mapid:mapqlitem.keyset()){ 
            if(mapqlitem.get(mapid).associatedAccountId__c != null ){
                setqlaccids.add(mapqlitem.get(mapid).associatedAccountId__c);
            }
            if(mapqlitem.get(mapid).Competitor__c != null){
                setqlcompids.add(mapqlitem.get(mapid).Competitor__c);
            }
        }
    }
    /* This method is used to assign the ServiceProviderRelationship records to map*/
    public static void setSPRidalignment(){
        if(!setqlaccids.isEmpty() && !setqlcompids.isEmpty()){
            for(ServiceProviderRelationship__c sprdata: Database.query(SELECT_SPR)){
                String straid =sprdata.Account__c;String strvid =sprdata.Vendor__c;
                String strdata = straid != null && straid !=STRBLANK?straid.subString(0,15):STRBLANK+SYMB+strvid != null && strvid !=STRBLANK?strvid.subString(0,15):STRBLANK;
                //system.debug('strdata====sprovider======'+strdata);
                mapsprrecord.put(strdata,sprdata);
            }
        }
    }
    /*This method is used to create/update ServiceProviderRelationship record from QuotelineItem */
    public static list<ServiceProviderRelationship__c> listSPRassignment(map<Id,QuotelineItem> mapqlitem){
        list<ServiceProviderRelationship__c> sprlist = new list<ServiceProviderRelationship__c>();
        for(Id mapqlrec:mapqlitem.keyset()){
            if(setprodstage.contains(mapqlitem.get(mapqlrec).ProductStage__c) && 
                                        mapqlitem.get(mapqlrec).Competitor__c != null ){
                String straid = mapqlitem.get(mapqlrec).associatedAccountId__c;
                String strcomid = mapqlitem.get(mapqlrec).Competitor__c;
                string spriden = straid != null && straid !=STRBLANK ? straid.subString(0,15):STRBLANK+SYMB+strcomid != null && strcomid !=STRBLANK ? strcomid.subString(0,15) : STRBLANK;
                ServiceProviderRelationship__c spr = new ServiceProviderRelationship__c();
                if(!mapsprrecord.isEmpty() && mapsprrecord.containskey(spriden)){
                    if(!mapsprrecord.get(spriden).Competitor__c){
                        spr = mapsprrecord.get(spriden);
                        spr.Competitor__c = true;
                        sprlist.add(spr);
                    }
                }else{
                    spr.Vendor__c = mapqlitem.get(mapqlrec).Competitor__c;
                    if(mapqlitem.get(mapqlrec).associatedAccountId__c != null){
                        spr.Account__c = Id.valueOf(mapqlitem.get(mapqlrec).associatedAccountId__c);
                    }
                    spr.Competitor__c = true;
                    spr.EffectiveDate__c = system.today();
                    sprlist.add(spr);
                }
            }
        }
        return sprlist;
    }
    /*This method is used to assign ServiceProviderRelationship record id to QuotelineItem*/
    public static void assignsprtoqlitem(list<ServiceProviderRelationship__c> sprlist,map<Id,QuotelineItem> mapqlitem){
        set<Id> setsprids = new set<Id>();
        setsprids = ANA_UTIL05_AccessSPRDataUtil.upsertServiceProviderRecord(sprlist);
        if(!setsprids.isEmpty()){
            list<QuotelineItem> listqlitems = new list<QuotelineItem>();
            map<String,ServiceProviderRelationship__c> mapsuccessrecord = new map<String,ServiceProviderRelationship__c>();
            for(ServiceProviderRelationship__c sprdata: Database.query(SELECT_SPR2)){ 
                String straid =sprdata.Account__c;String strvid =sprdata.Vendor__c;
                String strdata = straid != null && straid !=STRBLANK ? straid.subString(0,15):STRBLANK+SYMB+strvid != null && strvid !=STRBLANK ? strvid.subString(0,15) :STRBLANK;
                mapsuccessrecord.put(strdata,sprdata);
            }
            for(QuotelineItem qli: Database.query(SELECT_QL)){
                String straid = qli.associatedAccountId__c;
                String strcomid = qli.Competitor__c;
                string spriden = straid != null && straid !=STRBLANK ?straid.subString(0,15):STRBLANK+SYMB+strcomid != null && strcomid !=STRBLANK ?strcomid.subString(0,15):STRBLANK;
                if(!mapsuccessrecord.isEmpty() && mapsuccessrecord.containskey(spriden)){
                    qli.Competitor_Won__c =mapsuccessrecord.get(spriden).Id; 
                    listqlitems.add(qli);
                }
            }
            
            if(!listqlitems.isEmpty()){
                //Database.SaveResult[] dbres = database.update(listqlitems,false);
                ANA_UTIL05_AccessSPRDataUtil.updateQuotelineitem(listqlitems);
            }
        }
    }
}