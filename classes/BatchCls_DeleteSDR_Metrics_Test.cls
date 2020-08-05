@isTest
public class BatchCls_DeleteSDR_Metrics_Test {
    @isTest
    public static void TestDeletionSDR_Metrics(){
        Account accInfo = new Account(Name= 'acc1');
        Insert accInfo;
        
        Contact cntctInfo = new Contact(AccountId  = accInfo.id,LastName = 'XYZ',Phone = '123456790',Email ='xyz@autorabbit.com',DC_Completed_Date__c = date.today(),DC_Completed_Date_Vault__c = date.today() + 2,DC_Scheduled_Date__c = DATE.today() + 4,
                                       DC_Scheduled_Date_Vault__c = Date.today() + 6,Demo_Performed_Date__c = date.today() -3,Demo_Performed_Date_Vault__c = date.today() - 2,Demo_Scheduled_Date__c = date.today() + 3);
        
        insert cntctInfo;
        
        Lead leadInfo = new Lead(SDR__c = 'sdr1',Company = 'autorabbit',Status = 'Qualified',Email = 'xyz@autorabbit.com',LastName = 'xyz',	Partner_Enterprise__c = 'Enterprise',DC_Completed_Date__c = date.today() + 4,
                               DC_Completed_Date_Vault__c = date.today() - 3,DC_Scheduled_On__c = date.today() + 7,DC_Scheduled_On_Vault__c = date.today() + 2,Demo_Performed_Date__c = date.today() + 6,Demo_Performed_Date_VaultI0__c = date.today() -3,Demo_Scheduled_Date__c = date.today() + 2);
        
        Insert leadInfo;
        
        List<SDR_Metrics__c> sdrList = new List<SDR_Metrics__c>();
		for(Integer i = 0 ;i<100;i++){
    		SDR_Metrics__c sdrinfo  = new SDR_Metrics__c();
    		sdrinfo.name = 'sdr'+i;
    		sdrList.add(sdrInfo);
		}
		insert sdrList;
        
        Test.startTest();
        String query = 'Select id from SDR_Metrics__c limit 50000';
        BatchCls_DeleteSDR_Metrics  btchDeletesdRMetrics= new BatchCls_DeleteSDR_Metrics(query);
        database.executeBatch(btchDeletesdRMetrics);
        Test.stopTest();
        
    } 
}