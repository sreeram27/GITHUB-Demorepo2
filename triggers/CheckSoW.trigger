trigger CheckSoW on Opportunity (before update) {
    Set<Id> accountIds = new Set<Id>();
    //get Opportunity and Attachments
    List <Opportunity> oppty = new List<Opportunity>([select id, StageName from Opportunity where Id IN:Trigger.new]); 
    //Map<id,Attachment> att = new Map<id, Attachment>([select id, Name, ParentId from Attachment where ( Name = '%SOW%' AND ParentID IN:Trigger.new)]);
    list<Attachment> att = new list<Attachment>([select id, Name, ParentId from Attachment where ( Name = '%SOW%' AND ParentID IN:Trigger.new)]);
    For(Opportunity opp : Trigger.new){
       accountIds.add(opp.AccountId);
        if(oppty.get(0).Stagename == 'Closed Won')
        {
            for(Attachment attach:att){
                if(attach.parentId!=opp.id){
                    system.debug('------------------------------entered--------------------');
                    opp.adderror('For "Closed Won" Opportunities, please attach an SoW. The name of the Document should contain SoW');
                    break;
                }
            }
        }
    }
    
    If(trigger.isbefore && trigger.isUpdate){
        list<opportunity> sl = trigger.new;
        list<opportunityLineItem> slnu = new list<opportunityLineItem>([select id ,product2.name,Quantity, opportunityId from opportunitylineitem where opportunityId =: trigger.new[0].id]); 
        string productName='';
        
        Date Closedate=Date.newInstance(1,1, 1);
        for(opportunityLineItem opp : slnu){
            productName += opp.product2.name +';'; // + operator for concatenation.        
        } 
        for(Opportunity opp : trigger.new){        
            opp.Product_Name__c = productName; 
              opp.Total_Product_Subs__c=0;
              opp.This_year_Subs__c=0;
          //  List<opportunity> oppLst = [Select createdDate,closedate,Total_Product_Subs__c,Number_of_Product_Subscriptions__c  from Opportunity  where closedate = LAST_FISCAL_YEAR   ] ;
            for(Account a :[SELECT Id, (SELECT Id,createdDate,closedate,Total_Product_Subs__c,Number_of_Product_Subscriptions__c, StageName from Opportunities where closedate = LAST_FISCAL_YEAR ) FROM Account WHERE Id IN :accountIds    ]){
            System.debug('s'+a);    
            For(Opportunity opprange: a.Opportunities){
                opp.Total_Product_Subs__c +=opprange.Number_of_Product_Subscriptions__c;
                System.debug('Total'+opp.Total_Product_Subs__c);
            }
            }
        } 
        
    } 
    
    If(trigger.isBefore && trigger.isUpdate){
        list<opportunity> sl = trigger.new;
        list<opportunityLineItem> slnu = new list<opportunityLineItem>([select id ,product2.name, opportunityId,Total_Price__c  from opportunitylineitem where opportunityId =: trigger.new[0].id]); 
        string productName='';
        Decimal TotalAmount=0;
        Decimal TotalAmountAr=0;
        Decimal TotalAmountPro=0;
        Decimal TotalAmountVault=0;
        Decimal TotalAmountARMule=0;
        Decimal TotalAmountPaid_POC=0;
        Decimal TotalAmountAWS=0;
        Decimal TotalAmountOn_Premise=0;
        Decimal TotalAmountPartner=0;
        Decimal TotalAmountServices=0;
        Decimal TotalAmountSupport=0;
        
        for(opportunityLineItem opp : slnu){
            
            productName += opp.product2.name +';'; 
            if(opp.product2.name.contains('Adv') ){
                TotalAmount += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('AR') ){
                TotalAmountAr = opp.Total_Price__c+TotalAmountAr ;
            }/* else if(opp.product2.name.contains('Pro') ){
TotalAmountPro += opp.Total_Price__c ;
System.debug('TotalAmountPro'+TotalAmountPro);
} */
            else if(opp.product2.name.contains('Vault') ){
                TotalAmountVault += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('Mule') ){
                TotalAmountARMule += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('AWS') && !opp.product2.name.contains('AWS EC-2')  ){
                TotalAmountAWS += opp.Total_Price__c ;
                System.debug('TotalAmountAWS'+TotalAmountAWS);
            }else if(opp.product2.name.contains('On-Premise') ){
                TotalAmountOn_Premise += opp.Total_Price__c ;
                System.debug('TotalAmountOn_Premise'+TotalAmountOn_Premise);
            } else if(opp.product2.name.contains('Paid POC') ){
                TotalAmountPaid_POC += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('Partner') ){
                TotalAmountPartner += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('Services') ){
                TotalAmountServices += opp.Total_Price__c ;
            }else if(opp.product2.name.contains('Support') ){
                TotalAmountSupport += opp.Total_Price__c ;
            }
            
        }
        
        for(Opportunity opp : trigger.new){        
            opp.Product_Name__c = productName;
            if(TotalAmount!=0){
                opp.Opportunity_Amount_Advisory__c=TotalAmount;
            } else{opp.Opportunity_Amount_Advisory__c=0;}
            if( TotalAmountAr!=0 ){
                opp.OpportunityAmount_AR__c=TotalAmountAr;
            } else{opp.OpportunityAmount_AR__c=0;}
            /* if( TotalAmountPro!=0 ){
opp.Opportunity_Amount_Professional_Service__c=TotalAmountPro;
}*/
            if( TotalAmountVault!=0){
                opp.Opportunity_Amount_ARVault__c=TotalAmountVault;
            } else{opp.Opportunity_Amount_ARVault__c=0;}
            if( TotalAmountARMule!=0 ){
                opp.Opportunity_Amount_ARMule__c=TotalAmountARMule;
            }else{opp.Opportunity_Amount_ARMule__c=0;}
            if( TotalAmountAWS!=0 ){
                opp.Opportunity_Amount_AWS__c=TotalAmountAWS;
            } else{opp.Opportunity_Amount_AWS__c=0;}
            if( TotalAmountOn_Premise!=0){
                opp.Opportunity_Amount_On_Premise__c=TotalAmountOn_Premise;
            }else{opp.Opportunity_Amount_On_Premise__c=0;}
            if( TotalAmountPaid_POC!=0 ){
                opp.Opportunity_Amount_Paid_POC__c=TotalAmountPaid_POC;
            }else{opp.Opportunity_Amount_Paid_POC__c=0;}
            if( TotalAmountPartner!=0) {
                opp.Opportunity_Amount_Partner__c=TotalAmountPartner;
            }else{opp.Opportunity_Amount_Partner__c=0;}
            if( TotalAmountServices!=0) {
                opp.Opportunity_Amount_Service__c=TotalAmountServices;
            }else{opp.Opportunity_Amount_Service__c=0;}
            if( TotalAmountSupport!=0) {
                opp.Opportunity_Amount_Support__c=TotalAmountSupport;
            }  else{opp.Opportunity_Amount_Support__c=0;}
        }
        
    }
    
}