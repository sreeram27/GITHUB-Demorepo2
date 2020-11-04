/*****************************************************************
* Class Name     : LGA_Opportunity_Trigger_Handler
* Created By     : Prabir 
* Description    : This is the Handler class for the Opportunity Trigger to updatethe status of the existing Application or Create a new one
* Change History :
* Date			 : 21st June, 2019
* ***************************************************************/ 

Public With Sharing  class LGA_Opportunity_Trigger_Handler  {
    
    Private List<id> oppAccList = new List<id> ();
    //Private List<Account> accList = new List<Account> ();
    Private Map<Id, Account> accMap = new Map<Id,Account> ();
    Private List<vlocity_ins__Application__c> appList = new List<vlocity_ins__Application__c>();
    //Private List<vlocity_ins__Application__c> appListtoUpdate = new List<vlocity_ins__Application__c>();
    Private Map<Id, vlocity_ins__Application__c> appMap = new Map<Id, vlocity_ins__Application__c>();
    Private List<Id> oppList = new List<Id>() ;
    
    //Private Map<Id,QuoteLineItem> oppQLIMap = new Map<Id,QuoteLineItem>();
    Private Map<Id,List<QuoteLineItem>> oppQLIMap = new Map<Id,List<QuoteLineItem>>();
    Private Map<String,RecordType > appRecdTypes = new Map<String,RecordType > ();
    Private Map<Id,RecordType > oppRecdTypes = new Map<Id,RecordType > ();
    
    // Constants/Strings used
    Private String oppClosedWon = 'Closed Won';
    Private String appName1 = 'Local Large Application for ';
    Private String appName2 = ' Effective:  ';
    Private String newAppStatus = 'Application Not Started';
    Private String appStatusPC = 'Pending Change In Progress';
    Private String appStatusIP = 'In Progress';
    Private String productStageRenew = 'Renewed';
    Private String productStageSold = 'Sold';
    Private String productStageIGAPSold = 'IGAP Sold';
    Private String applicationAPI = 'vlocity_ins__Application__c' ;
    Private String opportunityAPI = 'Opportunity' ;
    
    /************************************************************************
* Description : Constructor
* Created By     : Prabir 
* Change History :
* Date			 : 21st June, 2019
************************************************************************/ 
    
    Public LGA_Opportunity_Trigger_Handler(List<Opportunity> ListOpp){
        
        Try{
            For(RecordType RT: [select Id,Name,DeveloperName  from RecordType where sObjectType = :applicationAPI Limit 50000] ){
                appRecdTypes.put(RT.DeveloperName , RT);
            }
            
            For(RecordType RT: [select Id,Name,DeveloperName  from RecordType where sObjectType = :opportunityAPI Limit 50000] ){
                oppRecdTypes.put(RT.Id, RT);
            }            
            for(Opportunity opp:ListOpp){
                oppList.add(opp.id);
                oppAccList.add(opp.AccountId);
                
            }
            //accList = [SELECT Id, Name, SICName__c,SIC__c,Situs_State_Abbrev__c,Situs_State__c, Status__c FROM Account Where Id in :oppAccList Limit 50000];
            
            for (Account acc: [SELECT Id, Name, SICName__c,SIC__c,Situs_State_Abbrev__c,Situs_State__c,
                               Status__c FROM Account Where Id in :oppAccList Limit 50000]){
                                   accMap.put(Acc.Id, Acc);
                               }
            
            System.debug('****Updated Opportunity****' + oppList);
            //qliList = [SELECT Id, ProductStage__c,QuoteId, Quote.OpportunityId FROM QuoteLineItem 
            //Where QuoteId  IN (SELECT Id FROM Quote Where opportunityId IN :oppList) Limit 50000];
            
            for (QuoteLineItem QLI : [SELECT Id, ProductStage__c,QuoteId, Quote.OpportunityId 
                                      FROM QuoteLineItem Where QuoteId  IN 
                                      (SELECT Id FROM Quote Where opportunityId IN :oppList) Limit 50000]){
                                          If(oppQLIMap.containsKey(QLI.Quote.OpportunityId)){
                                              //Add to existing List
                                              oppQLIMap.get(QLI.Quote.OpportunityId).add(QLI);
                                          } else {
                                              //Create new list
                                              List<QuoteLineItem> qliList = new List<QuoteLineItem>();
                                              qliList.add(QLI);
                                              oppQLIMap.put(QLI.Quote.OpportunityId, qliList);
                                          }
                                          //oppQLIMap.put(QLI.Quote.OpportunityId, QLI); //QLIId,
                                      }

            
            For(vlocity_ins__Application__c app: [SELECT Id, vlocity_ins__Status__c,vlocity_ins__OpportunityId__c 
                                                  FROM vlocity_ins__Application__c 
                                                  Where vlocity_ins__OpportunityId__c IN :oppList Limit 50000]){
                                                      appMap.put(app.vlocity_ins__OpportunityId__c, app);
                                                  }
        } Catch (Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());            
        }        
    }
    
    
    /************************************************************************
* Method Name : createUpdateApplication
* Description : To create Application based on Opportunity Stage/ Update Appliaction Status based on Opportunity Stage.
* Created By     : Prabir 
* Change History :
* Date			 : 21st June, 2019
************************************************************************/ 
    
    Public  void createUpdateApplication(List<Opportunity> oppList, Map<id, Opportunity> mapOldOpp){
        
        Try{            
            
            List<vlocity_ins__Application__c> appListUpdate = new List<vlocity_ins__Application__c>();
            vlocity_ins__Application__c app = New vlocity_ins__Application__c();
            vlocity_ins__Application__c apptoUpdate1 = New vlocity_ins__Application__c();
            vlocity_ins__Application__c apptoUpdate2 = New vlocity_ins__Application__c();
            for (Opportunity opp: oppList){ 
                if(mapOldOpp.get(opp.Id).StageName != opp.StageName){
                    //System.debug('********** Appliction Check *******' + (mapOldOpp.get(opp.Id).StageName != opp.StageName));
                    //This part is to create Application based on Opportunity status
                    If (opp.StageName == oppClosedWon && !(appMap.keySet().contains(opp.Id)) && 
                        (oppRecdTypes.get(opp.RecordTypeId).DeveloperName == 'New_Business_Local') ){
                            for(QuoteLineItem QLI : oppQLIMap.get(opp.Id)){
                                if (QLI.ProductStage__c == productStageRenew || QLI.ProductStage__c == productStageSold || QLI.ProductStage__c == productStageIGAPSold){
                                    String accountState = accMap.get(opp.AccountId).Situs_State_Abbrev__c;
                                    String effectiveDateString = String.valueOf(opp.CloseDate.month())  + '/' + String.valueOf(opp.CloseDate.day()) + '/' + String.valueOf(opp.CloseDate.year());
                                    //System.debug('******* Entered firstIf*******' );
                                    //vlocity_ins__Application__c app = New vlocity_ins__Application__c();
                                    app.Name = appName1 + accMap.get(opp.AccountId).Name + appName2 + effectiveDateString; //String.valueOf(opp.CloseDate) ;
                                    app.RecordTypeId = appRecdTypes.get(accountState).Id ; 
                                    app.vlocity_ins__OpportunityId__c = opp.ID;
                                    app.AccountLegalName__c = opp.AccountId;
                                    //app.vlocity_ins__AccountId__c = opp.AccountId;
                                    app.Association_Name__c = opp.AccountId;
                                    app.vlocity_ins__Status__c = newAppStatus;
                                    appList.add(app);
                                }
                            }
                        }
                    //This part is to update the Existing Application's Status based on Opportunity status
                    else if ((appMap.keySet().contains(opp.Id))){
                        
                        If (opp.StageName != oppClosedWon){
                            
                            apptoUpdate1.vlocity_ins__Status__c = appStatusPC ;
                            apptoUpdate1.id = appMap.get(opp.Id).Id; 
                            appListUpdate.add(apptoUpdate1);
                            //System.debug('******* Entered Secondif*******'+(opp.StageName != oppClosedWon) );
                            
                        }else If (opp.StageName == oppClosedWon && appMap.get(opp.Id).vlocity_ins__Status__c != 'Application Not Started'){
                            
                            apptoUpdate2.vlocity_ins__Status__c = appStatusIP ;
                            apptoUpdate2.id = appMap.get(opp.Id).Id;
                            appListUpdate.add(apptoUpdate2);
                            //System.debug('******* Entered Thirdif*******'+(opp.StageName == oppClosedWon) );
                            
                        } else{} 
                    }else{}
                }
            }
            If (appList.size()> 0){
                system.debug('*** Before Creating Application ****' + appList);
                Database.insert(appList, false);
                system.debug('*** After Creating Application ****' + appList);
            }
            Else If (appListUpdate.size()> 0){
                system.debug('***** Updating Existing Application ******' + appListUpdate);
                Database.update(appListUpdate, false);
            }
        }
        Catch (Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
    }
    
}