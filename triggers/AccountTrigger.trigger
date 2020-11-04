trigger AccountTrigger on Account (before Delete, before Insert, before Update, after Insert, after Update, after Delete, after UnDelete) 
{
    //System.debug('***** stopTrigger ' + staticVariableClass.stopTrigger);
    if(staticVariableClass.stopTrigger==false){ 
    
        AccountTriggerHandler handler = new AccountTriggerHandler();
        
       
         
       
    }
}