/**
* This helper class is to get the QLI rates info
* */

public class LGRateLoadServiceHelper {
    Public Id opptyId;
    Public String opptyName;
    public StatusDetails updateRates(LGRateRequest serviceReq) {
        String opptyIdFromReq;
        system.debug('Req:' +JSON.serializePretty(serviceReq));
        system.debug('serviceReq--->:' + serviceReq);
        StatusDetails respStatus = new StatusDetails();
        List<QuoteLineItem> qliList = new List<QuoteLineItem>();
        Set<String> contractCodes = new Set<String>();
        //  Map<String,String> rateMap = new Map<String,String>();
        List<QuoteLineItemRates__c> insertRateList = new List<QuoteLineItemRates__c>();
        List<QuoteLineItemRates__c> deleteRateList = new List<QuoteLineItemRates__c>();
        Map<String,List<QuoteLineItem>> qliMap = new Map<String,List<QuoteLineItem>>();
        Map<String,List<QuoteLineItemRates__c>> rateMap = new Map<String,List<QuoteLineItemRates__c>>();
        String groupName;
        List<QuoteLineItem> qliUpdateList= new List<QuoteLineItem>();
        try{
            if(serviceReq!= null){
                opptyIdFromReq = serviceReq.sfOpportunityId;
                System.debug('opptyIdFromReq--------:' + opptyIdFromReq);
                groupName =serviceReq.GroupName;
                
                if(opptyIdFromReq!=null){
                    //get oppty from object based on req
                    List<Opportunity> opptyList= [select id,name from Opportunity where Id =: opptyIdFromReq];
                    System.debug('opptyList---:' + opptyList);
                    if(opptyList!= null && opptyList.size()>0){
                        opptyId =opptyList[0].Id;
                        opptyName = opptyList[0].Name;
                    }
                } else {
                    respStatus.statusCode=1;
                    respStatus.statusMessage='No Opportunity id found in the request';
                    return respStatus;
                }
                if(opptyId == null){
                    respStatus.statusCode=1;
                    respStatus.statusMessage='No Opportunity record found with oppty id:'+opptyIdFromReq;
                    return respStatus;
                } else {
                    Set<String> qliSet = new Set<String>();
                    //get  QLIs based on oppty id
                    //TODO: Need to add more where conditions if requried
                    //ProductStage__c
                    qliList = [SELECT Id,Contract_Code_ASF__c,Quote.OpportunityId FROM QuoteLineItem WHERE
                               Quote.OpportunityId=:opptyId 
                               //and ProductCategory__c= 'Plan'
                              ];
                    
                    
                    List<QuoteLineItem> existingQliList;
                    //Create map with QLI and concode
                    
                    if(qliList.size()>0){
                        for(QuoteLineItem eachQli: qliList){
                            /*if(eachQli.Contract_Code_ASF__c==null){
                                respStatus.statusCode=1;
                                respStatus.statusMessage='No conract code assigned to QLI record:'+eachQli.id;
                                return respStatus;
                            }
							*/
                            if(eachQli.Contract_Code_ASF__c!=null){
                            if(qliMap.containsKey(eachQli.Contract_Code_ASF__c)){
                                existingQliList = qliMap.get(eachQli.Contract_Code_ASF__c);
                            }else {
                                existingQliList= new List<QuoteLineItem>();
                                
                            } 
                            existingQliList.add(eachQli);
                            qliMap.put(eachQli.Contract_Code_ASF__c,existingQliList);
                                qliSet.add(eachQli.id);
                            }
                        }
                    } else {
                        respStatus.statusCode=1; respStatus.statusMessage='No QLI records found with required criteria for oppty id:'+opptyIdFromReq;
                        return respStatus;
                    }
                    
                    //build rate id map for all QLI, 
                    List<QuoteLineItemRates__c> existingRateList;
                    List<QuoteLineItemRates__c> existingQliRateList = new  List<QuoteLineItemRates__c>();
                    
                    existingQliRateList = [select id,name,QuoteLineItem__c from QuoteLineItemRates__c 
                                           where QuoteLineItem__c=:qliSet];
                    
                    if(existingQliRateList.size()>0){
                        for (QuoteLineItemRates__c rate : existingQliRateList ){
                            if(ratemap.containsKey(rate.QuoteLineItem__c)){
                                existingRateList = rateMap.get(rate.QuoteLineItem__c);
                                
                            }else {
                                existingRateList= new List<QuoteLineItemRates__c>();
                            }
                            existingRateList.add(rate);
                            rateMap.put(rate.QuoteLineItem__c,existingRateList);
                        }
                    }
                    system.debug('serviceReq.rateInfo.size()************:' + serviceReq.rateInfo.size());
                    if(serviceReq.rateInfo!= null &&serviceReq.rateInfo.size()>0 ){
                        for(LGRateRequest.RateInfo rateInfo :serviceReq.rateInfo){
                            system.debug('--------------------');
                            if(rateInfo.ContractCode!= null) {
                                List<QuoteLineItem> existingQLI = qliMap.get(rateInfo.contractCode);
                                //If more than one QLI for given contract code, return error
                                if(existingQLI!= null && existingQLI.size()>1){
                                    respStatus.statusCode=1;
                                    respStatus.statusMessage='Found more than one Qli for contract code:' +rateInfo.contractCode;
                                    return respStatus;
                                }else if(existingQLI== null || existingQLI.size()==0){
                                    respStatus.statusCode=1;
                                    respStatus.statusMessage='No Qli record found for contract code:' +rateInfo.contractCode;
                                    return respStatus;
                                }
                                else {
                                    List<QuoteLineItemRates__c> qliRateList = rateMap.get(existingQLI[0].id);
                                    System.debug('qliRateList---------:' + qliRateList  );
                                    if(qliRateList!= null && qliRateList.size()>0){
                                        for(QuoteLineItemRates__c deleteRec : qliRateList){
                                            deleteRateList.add(deleteRec);
                                            //system.debug('delete list------------>' + deleteRateList);
                                        }
                                        system.debug('in update ------>');
                                    }
                                    QuoteLineItemRates__c createRate = new QuoteLineItemRates__c();
                                    createRate.QuoteLineItem__c=existingQLI[0].id;
                                    createRate.Rate_Id__c =rateInfo.rateIdentifier;
                                    createRate.Employment_Category_Code__c=rateInfo.employmentCategoryCode;
                                    //createRate.Network_Name__c=rateInfo.networkName;
                                    //createRate.Network_Id__c= rateInfo.networkId;
                                    // createRate.Rider_Description__c=rateInfo.riderDescription;
                                    createRate.Rate_Single__c=decimal.valueOf(rateInfo.single);
                                    createRate.Rate_TwoParty__c=decimal.valueOf(rateInfo.twoParty);
                                    createRate.Rate_EE_Child__c=decimal.valueOf(rateInfo.eeChild);
                                    createRate.Rate_Family__c=decimal.valueOf(rateInfo.family);
                                    createRate.Rate_EE_CHN__c=decimal.valueOf(rateInfo.eeChildren);
                                    createRate.Rate_65_Spouse_Ch_Med_Elig__c=decimal.valueOf(rateInfo.medicareElgSpouseChildL65);
                                    createRate.Rate_65_Spouse_Med_Elg__c=decimal.valueOf(rateInfo.medicareElgSpouseL65);
                                    createRate.Commission_Level__c = rateInfo.commissionLevel;
                                    createRate.Commission_Type__c = rateInfo.commissionType;
                                    
                                    createRate.Class_Code__c =rateInfo.classCode;
                                    createRate.Rate_Embedded_Vision__c =rateInfo.embeddedVisionPSPM;
                                    //create new QLI
                                    insertRateList.add(createRate);
                                    system.debug('Creating new Rate----');
                                } 
                            }else {
                                respStatus.statusCode=1;
                                respStatus.statusMessage='No Contract code in the request';
                                return respStatus;
                            }
                        }
                        // system.debug('before create rateList QLI List---->:'+ rateList);
                        if(insertRateList.size()>0){
                            insert insertRateList;

                        }
                        // system.debug('before deleted QLI List---->:'+ deleteRateList);
                        if(deleteRateList.size()>0){
                            Set<QuoteLineItemRates__c> myset = new Set<QuoteLineItemRates__c>();
                            List<QuoteLineItemRates__c> result = new List<QuoteLineItemRates__c>();
                            myset.addAll(deleteRateList);
                            result.addAll(myset);
                            system.debug('deleted QLI List---->:'+ result);
                            delete result;
                        }
                        respStatus.statusCode=0;
                        respStatus.statusMessage='Request processed successfully';
                        /*if(updateRateList.size()>0){
                        update updateRateList;
                        respStatus.statusCode=0;
                        respStatus.statusMessage='Request processed successfully';
                        }*/
                        
                        
                    } else{
                        respStatus.statusCode=1;
                        respStatus.statusMessage='No RateInfo found in the request';
                        return respStatus;
                    }
                }
            } else {
                    respStatus.statusCode=1;  respStatus.statusMessage='Not valid request to process';  return respStatus;
            }
        } catch (Exception ex){
            respStatus.StatusCode=1;respStatus.StatusMessage='Error occured while updating rate info: '+ ex.getMessage();return respStatus;
            
            
        }
        return respStatus;
    }
    
    /**
* This method is to create new QLI and update rate for oppty
* */
    /*  public StatusDetails createNewQLI(String opptyId,LGRateRequest.RateInfo rateInfo){
//1. get all quotes based on oppty
//if I get 5 quotes, then compare group numer and get the right Quote and then create new QLI and quote.
//2.If I have one quote but not matching and then link to that quote
//3. If no quoute 
Id quoteId;
String productId;
String planId;
StatusDetails respStatus = new StatusDetails();
List<Quote> quoteList = [SELECT Id,OpportunityId,GroupNumber__c ,GroupNumber__r.Name,Name FROM Quote WHERE OpportunityId = : opptyId];
//1.If I have one quote but not matching and then link to that quote
//get product/plan recs from product2
if(quoteList.size()> 0){
system.debug('quoteList*****:' + quoteList);
List<Product2> prodList = [Select id,Contract_code__c,name,vlocity_ins__ProductSpecId__c from Product2 
where Contract_code__c=:rateInfo.contractCode
and ProductActive__c=true LIMIT 1] ;
if(prodList.size()== 0 || prodList== null) {
respStatus.StatusCode = 1;
respStatus.StatusMessage= 'No product found with contract code :' + rateInfo.contractCode;
return respStatus;
}
system.debug('prodList*****:' + prodList);
QuoteLineItem qliNewParent = new QuoteLineItem();
if(prodList[0].vlocity_ins__ProductSpecId__c != null) {
//create new parent QLI

List<PricebookEntry> priceBookforParent = [select id from PricebookEntry where Product2Id=:prodList[0].vlocity_ins__ProductSpecId__c];
qliNewParent.PricebookEntryId = priceBookforParent[0].id;
qliNewParent.Product2Id= prodList[0].vlocity_ins__ProductSpecId__c;
qliNewParent.QuoteId=quoteList[0].id; 
qliNewParent.Quantity=1.00; 
qliNewParent.UnitPrice=1.00;
system.debug('qliNewParent before*****:' + qliNewParent);
insert qliNewParent;
system.debug('qliNewParent*****:' + qliNewParent);
//Create new child QLI
QuoteLineItem newQliChild = new QuoteLineItem();
List<PricebookEntry> priceBookforChild = [select id from PricebookEntry where 
Product2Id=: prodList[0].id];
newQliChild.PricebookEntryId = priceBookforChild[0].id;
newQliChild.vlocity_ins__ContractCode__c = prodList[0].contract_code__c;
newQliChild.Product2Id = prodList[0].id;
newQliChild.ParentQuoteLineItem__c= qliNewParent.Id;
newQliChild.Quantity=1; 
newQliChild.UnitPrice=1.00;
newQliChild.QuoteId=quoteList[0].id; 
//TODO: Need to set Rate
insert newQliChild;
system.debug('newQliChild*****:' + newQliChild);
respStatus.StatusCode = 0;
respStatus.StatusMessage= 'Request processed successfully';
//return respStatus;

}
} else {
//TODO : Error: No Quotes available for given oppty id
}
return respStatus;
}*/
    public class StatusDetails{
        public Integer statusCode{ get; set; }
        public String statusMessage { get; set; } 
        
    } 
}