public class BMSQuotingObject {
    
public class BMSQuoteOpportunity { 
    public String StageName;
    public String OwnerId;
    public Date CloseDate;
    public string CloseDatereq;
    public String MarketSegment;
    public String QuotedHealth;
    public String CompositeMorbidityFactor;
    public String OpportunityName;
    public String RecordTypeId;
    public String BrokerNumber;
    public String AccountCode;
    public String SalesRepCode;
    public Date ReceivedDate;
    public String CMF;
    public String totalLives;
    public String totalMembership;
    public String healthLives;
    public String femaleFamilyCovLives;
    public String familyContractCount;
    public String employeeChildContractCount;
    public String employeeContractCount;
    public String employeeChildrenContractCount;
    public String femaleChildCovLives;
    public String employeeSpouseContractCount;
}
public  BMSQuoteOpportunity getOpportunityObj(BMSQuotingServiceSalesForce.SendQuoteReq sendQuoteReq){
    BMSQuoteOpportunity bmsQOppObj = new BMSQuoteOpportunity();
    BMSSendEmail sendEmail = new BMSSendEmail();
    

    bmsQOppObj.BrokerNumber=null;
//  try{
        BMSQuotingServiceSalesForce.GroupDetails grpDets = sendQuoteReq.User.GroupDetails;
        BMSQuotingServiceSalesForce.Brokers[] brokers = grpDets.Brokers;
        BMSQuotingServiceSalesForce.SalesReps[] salesReps = grpDets.SalesReps;
        BMSQuotingServiceSalesForce.SalesReps salesRep;         
        bmsQOppObj.AccountCode = grpDets.accountCode;
        if (bmsQOppObj.AccountCode != null) 
            if(bmsQOppObj.AccountCode.length()==0) bmsQOppObj.AccountCode = null;  
        if(salesReps != null)
            salesRep = grpDets.SalesReps[0];      
        if(salesRep != null)
            bmsQOppObj.SalesRepCode = salesRep.SalesRep;
            if(bmsQOppObj.SalesRepCode!= null)
                if(bmsQOppObj.SalesRepCode.length()==0) bmsQOppObj.SalesRepCode = null;
        if(brokers !=null)
            bmsQOppObj.BrokerNumber = brokers[0].eMail;
        if(bmsQOppObj.BrokerNumber =='0') bmsQOppObj.BrokerNumber = null;
        BMSQuotingServiceSalesForce.Presets presets = grpDets.Presets;        
        if (presets!= null) bmsQOppObj.CMF = getCMF(presets);
        String effDt = grpDets.effectiveDate;
        if(effDt != null && effDt != '') {
           String effDtStr = grpDets.effectiveDate;
            String[] dts = effDtStr.split('-');         
            Date effectiveDate = date.newinstance(Integer.valueOf(dts[0]), Integer.valueOf(dts[1]), Integer.valueOf(dts[2]));
            //string effectiveDate = date.newinstance(Integer.valueOf(dts[0]), Integer.valueOf(dts[1]), Integer.valueOf(dts[2])).format();
            bmsQOppObj.CloseDate = effectiveDate;
            bmsQOppObj.CloseDatereq=dts[1]+'/'+dts[2]+'/'+dts[0];
            //bmsQOppObj.CloseDate = Date.parse(effectiveDate);
              system.debug('bmsQOppObj.CloseDate inner class:'+bmsQOppObj.CloseDate);
              if (bmsQOppObj.BrokerNumber != null)
              bmsQOppObj.OpportunityName =  'NEW SALE OPPORTUNITY --'+dts[1]+'/'+dts[2]+'/'+dts[0]+'--'+bmsQOppObj.BrokerNumber+'-'+bmsQOppObj.SalesRepCode;
                else
                bmsQOppObj.OpportunityName =  'NEW SALE OPPORTUNITY --'+dts[1]+'/'+dts[2]+'/'+dts[0]+'--'+bmsQOppObj.SalesRepCode;
                
        }
        ServiceInterface__mdt mc;
        
        mc = [Select Id, OpportunityRecordTypeId__c From ServiceInterface__mdt Where DeveloperName = 'WLQIntegration'];//ServiceInterface__c.getValues('WLQIntegration');
       
      
        //bmsQOppObj.RecordTypeId=mc.OpportunityRecordTypeId__c; 
        bmsQOppObj.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business Local').getRecordTypeId();
        bmsQOppObj.StageName = 'Quoting';
        bmsQOppObj.ReceivedDate = system.today();
        bmsQOppObj.MarketSegment = 'Large Group';           
        BMSQuotingServiceSalesForce.Members member = grpDets.Members;
        if(member != null)
        {
            bmsQOppObj.QuotedHealth = member.healthLives;
            bmsQOppObj.marketSegment = member.marketSegment;
            bmsQOppObj.familyContractCount = member.familyContractCount;
            bmsQOppObj.employeeChildContractCount = member.employeeChildContractCount;
            bmsQOppObj.employeeChildrenContractCount = member.employeeChildrenContractCount;
            bmsQOppObj.employeeSpouseContractCount = member.employeeSpouseContractCount;
            bmsQOppObj.employeeContractCount = member.employeeContractCount;
        }    
//  }catch(Exception e){
//      system.debug(e.getMessage());
//  }   
    return bmsQOppObj;
}
public String getCMF(BMSQuotingServiceSalesForce.Presets presets){
    BMSQuotingServiceSalesForce.Adjustment[] adjustmentArr = presets.Adjustment;
    String cmf;
            for (BMSQuotingServiceSalesForce.Adjustment adjustment : adjustmentArr)
            if ((adjustment.type_x == 'tentativeCMF') && (adjustment.product == 'health')) {                          //Employee Only 
                cmf = adjustment.factor;
            }
            return cmf;
}
}