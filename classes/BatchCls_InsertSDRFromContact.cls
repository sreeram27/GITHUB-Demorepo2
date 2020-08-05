global class BatchCls_InsertSDRFromContact implements Database.Batchable<Sobject>{
    
    global  database.queryLocator start(Database.BatchableContext Bc){
        return database.getQueryLocator('Select id, Lastname,SDR__c, DC_Completed_Date__c, DC_Completed_Date_Vault__c, DC_Scheduled_Date__c, DC_Scheduled_Date_Vault__c, Demo_Performed_Date__c,Demo_Performed_Date_Vault__c, Demo_Scheduled_Date__c from Contact where DC_Completed_Date__c != Null OR DC_Completed_Date_Vault__c!= Null OR DC_Scheduled_Date__c!= Null OR DC_Scheduled_Date_Vault__c != Null OR Demo_Performed_Date__c != Null OR Demo_Performed_Date_Vault__c != Null OR Demo_Scheduled_Date__c != Null');
    }
    
    global static void Execute(Database.BatchableContext bc,List<contact> listOfContactsToBeInsertedAsSdr){
        
        list<SDR_Metrics__c> sdrList = new list<SDR_Metrics__c>();

		for(Contact c : listOfContactsToBeInsertedAsSdr)
		{
            if(c.DC_Completed_Date__c != Null)
            {
                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();

        		sdrRecord.Contact__c = c.Id;
                sdrRecord.Date__c = c.DC_Completed_Date__c;

        		sdrRecord.DC_Demo__c = 'DC Completed';

        		sdrRecord.SDR_Name__c = c.SDR__c;

        		sdrList.add(sdrRecord);

    		}

 

    		if(c.DC_Completed_Date_Vault__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.DC_Completed_Date_Vault__c;
        
                sdrRecord.DC_Demo__c = 'DC Completed Date (Vault)';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(c.DC_Scheduled_Date__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.DC_Scheduled_Date__c;
        
                sdrRecord.DC_Demo__c = 'DC Scheduled';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(c.DC_Scheduled_Date_Vault__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.DC_Scheduled_Date_Vault__c;
        
                sdrRecord.DC_Demo__c = 'DC Scheduled (Vault)';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(c.Demo_Performed_Date__c != Null)

    		{
        
                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.Demo_Performed_Date__c;
        
                sdrRecord.DC_Demo__c = 'Demo Performed';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(c.Demo_Performed_Date_Vault__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.Demo_Performed_Date_Vault__c;
        
                sdrRecord.DC_Demo__c = 'Demo_Performed(Vault)';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   

    		if(c.Demo_Scheduled_Date__c != Null)

    		{

                SDR_Metrics__c sdrRecord = new SDR_Metrics__c();
        
                sdrRecord.Contact__c = c.Id;
        
                sdrRecord.Date__c = c.Demo_Scheduled_Date__c;
        
                sdrRecord.DC_Demo__c = 'Demo Scheduled';
        
                sdrRecord.SDR_Name__c = c.SDR__c;
        
                sdrList.add(sdrRecord);

    		}

   		}
        
        if(sdrList.size()>0){
			insert sdrList;
        }
    }

    
     global void finish(Database.BatchableContext Bc){
        
    }
    
}