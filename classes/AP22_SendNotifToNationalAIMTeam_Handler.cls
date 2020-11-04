/*
@Author : Accenture Offshore Dev team
@name : AP22_SendNotifToNationalAIMTeam_Handler
@CreateDate :25-04-2018
@Description : This class calls AP22_SendNotifToNationalAIMTeam to send the notifications.
*/
// This Method sends notifications to AIM Team
public with sharing class AP22_SendNotifToNationalAIMTeam_Handler {
   /*
    *  Method will be executed after  Order record is updated.
    */ 
   public static void AfterOrderUpdate(List<Order> newList,Map<Id,Order> oldMap){ 
    if(AP22_SendNotifToNationalAIMTeam.firstRun){
       AP22_SendNotifToNationalAIMTeam.mailBuildermethod(newList,oldMap);
       AP22_SendNotifToNationalAIMTeam.firstRun = false; 
    }
     if(AP26_NotifyUsers_On_ICStatusChange.firstRun==true){
         AP26_NotifyUsers_On_ICStatusChange.mailBuildermethod(newList,oldMap);
         AP26_NotifyUsers_On_ICStatusChange.firstRun=false;
       }      
   }
     
      /*
    *  Method will be executed Before update 
    */ 
  
    
   public static void BeforeInsertUpdate(List<Order> newList,Map<id,order>oldMap){   
        if(!newList.isEmpty()){
           AP26_NotifyUsers_On_ICStatusChange.beforeUpdateValidate(newList,oldMap);
        }
   }    
 

}