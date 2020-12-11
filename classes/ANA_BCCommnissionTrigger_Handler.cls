/*@author        :Accenture 
@date           27/09/2017
@name           ANA_BrokerConCommnissionTrigger_Handler
@description    Populates consultant lookup on BBrokerage consultant commission record.  
*/
public with sharing class ANA_BCCommnissionTrigger_Handler
{ 
/*This method updates consultant lookup of brokerage consultant commission with consultant of corressponding brokerage and consultant.*/
    public static void afterCreate(List<Broker_Consultant_Commissions__c>  BCCList){
        for(Broker_Consultant_Commissions__c bcc : BCCList){
            if(bcc.BCContactRealtionshipID__c != null) {
              bcc.Contact_Relationship__c = ID.ValueOf(bcc.BCContactRealtionshipID__c);
            }
        }
    }
}