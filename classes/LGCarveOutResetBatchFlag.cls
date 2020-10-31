/**
@Author : Deloitte
@name : LGCarveOutResetBatchFlag
@CreateDate :30-03-2019
@Description : This class will stamp the value of Pening Correction time from SME object to corresponding Implementation Case when the SME tracking record exists.
*/
global class LGCarveOutResetBatchFlag implements Database.Batchable<sObject>,Database.Stateful {
    
    public Map<Id, String> errorMap = new Map<Id, String>();
    public Map<Id, String> successMap = new Map<Id, String>();
    String queryString;
    set<Id> orderIdSet = new set<ID>();
    //public  Map<Id,List<string>> orderIdToPendingDepartments {get;set;}
    
    public LGCarveOutResetBatchFlag()
    {
        //queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Tracking_Record_Exists__c from order where Tracking_Record_Exists__c=true and Carve_Out_Process_Records__c=true and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
        queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Tracking_Record_Exists__c from order where Carve_Out_Process_Records__c=true and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
    }
    
    public LGCarveOutResetBatchFlag(Set<Id> orderIdSet_actual)
    {
        orderIdSet = orderIdSet_actual;
        //queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Tracking_Record_Exists__c from order where id IN : orderIdSet and Tracking_Record_Exists__c=true and Carve_Out_Process_Records__c=true and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
        queryString ='select Carve_Out_Process_Records__c,id,Anthem_Entity__c,Tracking_Record_Exists__c from order where id IN : orderIdSet and Carve_Out_Process_Records__c=true and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
	{
        return database.getQueryLocator(queryString);
    }
    
    global void execute(Database.BatchableContext BC, List<Order> orderList) 
    { 
        set<Id> orderid=new set<Id>();
        for(order o:orderList)
        {
            orderid.add(o.id);
        }
        
        Map<string,string> OrderidtoImpTrackId=new Map<string,string>();
        for(Implementation_Tracking__c eachtrackrec:[select id,Implementation_Record_ID__c from Implementation_Tracking__c where Implementation_Record_ID__c in :orderid])
        {
            OrderidtoImpTrackId.put(eachtrackrec.Implementation_Record_ID__c,eachtrackrec.id);
        }
        
		//update Carve_Out_Process_Records__c on Order
        List<order>orderToBeUpdated1=new List<Order>();
        for(order Resetorder: [select id,Carve_Out_Process_Records__c,Tracking_Record_Exists__c from order where id in: orderid])
        {
            Resetorder.Carve_Out_Process_Records__c=false;
            orderToBeUpdated1.add(Resetorder);
        }
        
        
        if(!orderToBeUpdated1.isempty() && orderToBeUpdated1.size() >0)
        {
            //update orderToBeUpdated;
            Database.SaveResult[] srList = Database.update(orderToBeUpdated1, false);
            for(Integer i=0;i<srList.size();i++)
            {
                if (!srList.get(i).isSuccess())
                {
                    //orderToBeUpdated.get(i);//failed record from the list
                    system.debug('Failed ID'+orderToBeUpdated1.get(i).Id);
                    errorMap.put(orderToBeUpdated1.get(i).Id,srList.get(i).getErrors().get(0).getMessage());
                }
            }
        }
        
        list<ExceptionLog__c> excepreclst=new list<ExceptionLog__c>();

        for(Id i: errorMap.keyset())
        {
            excepreclst.add(new ExceptionLog__c(ClassName__c='LGCarveOutResetBatchFlag', ExceptionLogTimestamp__c=Datetime.now(),
                                                Order__c=i,ExceptionDetails__c=errorMap.get(i),Order_Id__c=i));
        }
        Database.upsert(excepreclst,false);
    }
    
    global void finish(Database.BatchableContext BC){}
}