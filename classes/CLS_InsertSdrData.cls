global class CLS_InsertSdrData implements Database.Batchable<Sobject> {
    
    global  database.queryLocator start(Database.BatchableContext Bc){
        return database.getQueryLocator('Select id, name,SDR__c, DC_Completed_Date__c, DC_Completed_Date_Vault__c, DC_Scheduled_On__c, DC_Scheduled_On_Vault__c, Demo_Performed_Date__c,Demo_Performed_Date_VaultI0__c, Demo_Scheduled_Date__c from Lead where DC_Completed_Date__c != Null OR DC_Completed_Date_Vault__c!= Null OR DC_Scheduled_On__c!= Null OR DC_Scheduled_On_Vault__c != Null OR Demo_Performed_Date__c != Null OR Demo_Performed_Date_VaultI0__c != Null OR Demo_Scheduled_Date__c != Null');
    }
    
    global static void Execute(Database.BatchableContext bc,List<Lead> listOfLeadsToBeInsertedAsSdr){
        list<SDR_Metrics__c> sdrList = new list<SDR_Metrics__c>();

		for(Lead l : listOfLeadsToBeInsertedAsSdr)
        {

    		if(l.DC_Completed_Date__c != Null)

    		{

        		SDR_Metrics__c sdrRecord = new SDR_Metrics__c();

        		sdrRecord.Lead_1__c = l.Id;

                sdrRecord.Date__c = l.DC_Completed_Date__c;

        		sdrRecord.DC_Demo__c = 'DC Completed';

        		sdrRecord.SDR_Name__c = l.SDR__c;

        		sdrList.add(sdrRecord);

    		}

   

    		if(l.DC_Completed_Date_Vault__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.DC_Completed_Date_Vault__c;
        
                sdrRecord.DC_Demo__c = 'DC Completed Date (Vault)';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(l.DC_Scheduled_On__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.DC_Scheduled_On__c;
        
                sdrRecord.DC_Demo__c = 'DC Scheduled';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(l.DC_Scheduled_On_Vault__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.DC_Scheduled_On_Vault__c;
        
                sdrRecord.DC_Demo__c = 'DC Scheduled (Vault)';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(l.Demo_Performed_Date__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.Demo_Performed_Date__c;
        
                sdrRecord.DC_Demo__c = 'Demo Performed';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(l.Demo_Performed_Date_VaultI0__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.Demo_Performed_Date_VaultI0__c;
        
                sdrRecord.DC_Demo__c = 'Demo_Performed(Vault)';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(l.Demo_Scheduled_Date__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Lead_1__c = l.Id;
        
                sdrRecord.Date__c = l.Demo_Scheduled_Date__c;
        
                sdrRecord.DC_Demo__c = 'Demo Scheduled';
        
                sdrRecord.SDR_Name__c = l.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

 	}
        if(SdrList.size()>0){
		insert sdrList;
        }
        
    }
    
    global void finish(Database.BatchableContext Bc){
        
        Database.executeBatch(new BatchCls_InsertSDRFromContact());
    }
    
}