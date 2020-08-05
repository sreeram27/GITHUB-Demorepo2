public class AccountHandler {
    
    public static void CreateContractFortheOpportunity(List<Account> accountListFromtrigger){
         List<Contract> NewContractList =new List<Contract>();
         Map<String,Contract> ContractMap = new Map<String,Contract>();
         List<Contract> ContractToBeUpserted = new List<Contract>();
        
         NewContractList = [select id,Accountid,Opportunity__c,Name,ContractTerm from contract where accountid in: accountListFromtrigger];
         
        for(Contract ContractInfo:NewContractList){
            ContractMap.put(ContractInfo.Opportunity__c,ContractInfo);
        }
        List<Account> AccountList = [select id,AccountID__c,Total_of_AR_Subs_Closed_Won__c,(Select id,Name,OpportunityID__c,StageName,Active_Oppty__c from Opportunities) from account where id in:accountListFromtrigger];
        
        for(Account accInfo: AccountList){
            for(Opportunity oppInfo:accInfo.opportunities){
                if(ContractMap.ContainsKey(oppInfo.Id)){
                    system.debug(OppInfo.StageName + OppInfo.Active_oppty__c);
                    if(OppInfo.StageName == 'Closed Won'){
                        Contract ContractObjForUpdation = new Contract();
                        ContractObjForUpdation = ContractMap.get(oppInfo.Id);
                        ContractObjForUpdation.accountid = accInfo.Id;
                        ContractObjForUpdation.Opportunity__c = oppInfo.id;
                        if(ContractObjForUpdation.ContractTerm == null){
                            ContractObjForUpdation.ContractTerm = 12;
                        }
                        ContractObjForUpdation.Account_ID__c = accInfo.AccountID__c;
                        ContractObjForUpdation.Total_AR_Subs_Closed_Won__c = accInfo.Total_of_AR_Subs_Closed_Won__c;
                        ContractToBeUpserted.add(ContractObjForUpdation);
                    }
                }
                else{
                    if(OppInfo.StageName == 'Closed Won'){
                        Contract ContractObjForInsertion = new Contract();
                        ContractObjForInsertion.accountid = accInfo.Id;
                        ContractObjForInsertion.ContractTerm = 12;
                        ContractObjForInsertion.Account_ID__c = accInfo.AccountID__c;
                        ContractObjForInsertion.Opportunity__c = oppInfo.id;
                        ContractObjForInsertion.Total_AR_Subs_Closed_Won__c = accInfo.Total_of_AR_Subs_Closed_Won__c;
                        ContractToBeUpserted.add(ContractObjForInsertion);
                    }
                }
            }
        }
        if(ContractToBeUpserted.size()>0){
            Upsert ContractToBeUpserted;
        }
    }
}