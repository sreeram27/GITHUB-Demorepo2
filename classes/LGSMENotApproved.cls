/**
@Author : Deloitte
@name : LGSMENotApproved
@CreateDate :18-01-2019
@Description : This class will stamp the value in current SME Stage field in order object when the SME tracking record exists.
*/
global class LGSMENotApproved implements Database.Batchable<sObject>,Database.Stateful {

    public Map<Id, String> errorMap {get; set;}
    public Map<Id, String> successMap{get; set;}
       
        //public  Map<Id,List<string>> orderIdToPendingDepartments {get;set;}
        
      public LGSMENotApproved()
      {
          //orderIdToPendingDepartments=new Map<Id,List<string>>();
          successMap=new Map<Id, String>();
          errorMap=new Map<Id, String>();
      }
        global Database.QueryLocator start(Database.BatchableContext BC) {
            
            string q='select Batch_Processed_Records__c,id,Anthem_Entity__c,Current_SME_Stage__c,Implementation_Status__c,Tracking_Record_Exists__c from order where Implementation_Status__c='+'\'Pending SME Review\' and Tracking_Record_Exists__c=true and Batch_Processed_Records__c=false and Anthem_Entity__c in ('+ '\'Local/Large Group\'' +',' + '\'Labor and Trust\'' +')';
            
            return database.getQueryLocator(q);
            
        }
        
        global void execute(Database.BatchableContext BC, List<Order> orderList) { 
        Map<string,string>statustopriority=new Map<string,string>();
        statustopriority.put('N/A','N/A');
        statustopriority.put('Not Started','01');
        statustopriority.put('Work In Progress','02');
        statustopriority.put('Pending Correction','03');
        statustopriority.put('Approved','04');
        statustopriority.put('Declined','05');
        
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
                
                Map<Id,List<Dental_Complete__c>> orderToDentalListRec=new Map<Id,List<Dental_Complete__c>>();
                for(Dental_Complete__c eachdental:[select id,Stage__c,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Dental_Complete__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToDentalListRec.containskey(eachdental.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToDentalListRec.put(eachdental.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Dental_Complete__c>{eachdental});
                    }
                    else
                    {
                        List<Dental_Complete__c> dentalRecFetched=orderToDentalListRec.get(eachdental.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        dentalRecFetched.add(eachdental);
                        orderToDentalListRec.put(eachdental.Implementation_Tracking_ID__r.Implementation_Record_ID__c,dentalRecFetched);
                    }
                    
                }
                
                Map<Id,List<Vision__c>> orderToVisionListRec=new Map<Id,List<Vision__c>>();
                for(Vision__c eachvision:[select Stage__c,id,Implementation_Tracking__c,Implementation_Tracking__r.Implementation_Record_ID__c from Vision__c where Implementation_Tracking__c in :OrderidtoImpTrackId.values()  order by createddate desc])
                {
                    if(!orderToVisionListRec.containskey(eachvision.Implementation_Tracking__r.Implementation_Record_ID__c))
                    {
                        orderToVisionListRec.put(eachvision.Implementation_Tracking__r.Implementation_Record_ID__c,new List<Vision__c>{eachvision});
                    }
                    else
                    {
                        List<Vision__c> visionRecFetched=orderToVisionListRec.get(eachvision.Implementation_Tracking__r.Implementation_Record_ID__c);
                        visionRecFetched.add(eachvision);
                        orderToVisionListRec.put(eachvision.Implementation_Tracking__r.Implementation_Record_ID__c,visionRecFetched);
                    }
                    
                }
                
                //placeholder for other SME object
                
                Map<Id,List<Underwriting__c>> orderToUnderWritingListRec=new Map<Id,List<Underwriting__c>>();
                for(Underwriting__c eachunderwriting:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Underwriting__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToUnderWritingListRec.containskey(eachunderwriting.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToUnderWritingListRec.put(eachunderwriting.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Underwriting__c>{eachunderwriting});
                    }
                    else
                    {
                        List<Underwriting__c> underwritingRecFetched=orderToUnderWritingListRec.get(eachunderwriting.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        underwritingRecFetched.add(eachunderwriting);
                        orderToUnderWritingListRec.put(eachunderwriting.Implementation_Tracking_ID__r.Implementation_Record_ID__c,underwritingRecFetched);
                    }
                }
                
                Map<Id,List<Enrollment_and_Billing__c>> orderToMembershipListRec=new Map<Id,List<Enrollment_and_Billing__c>>();
                for(Enrollment_and_Billing__c eachmembership:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Enrollment_and_Billing__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values()  order by createddate desc])
                {
                    if(!orderToMembershipListRec.containskey(eachmembership.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToMembershipListRec.put(eachmembership.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Enrollment_and_Billing__c>{eachmembership});
                    }
                    else
                    {
                        List<Enrollment_and_Billing__c> membershipRecFetched = orderToMembershipListRec.get(eachmembership.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        membershipRecFetched.add(eachmembership);
                        orderToMembershipListRec.put(eachmembership.Implementation_Tracking_ID__r.Implementation_Record_ID__c,membershipRecFetched);
                    }
                }
                
                Map<Id,List<InterPlan__c>> orderToInterplanListRec=new Map<Id,List<InterPlan__c>>();
                for(InterPlan__c eachInterplan:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from InterPlan__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToInterplanListRec.containskey(eachInterplan.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToInterplanListRec.put(eachInterplan.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<InterPlan__c>{eachInterplan});
                    }
                    else
                    {
                        List<InterPlan__c> interplanRecFetched = orderToInterplanListRec.get(eachInterplan.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        interplanRecFetched.add(eachInterplan);
                        orderToInterplanListRec.put(eachInterplan.Implementation_Tracking_ID__r.Implementation_Record_ID__c,interplanRecFetched);
                    }
                }
                
                Map<Id,List<Issue_Control__c>> orderToIssueControlListRec=new Map<Id,List<Issue_Control__c>>();
                for(Issue_Control__c eachIssueControl:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Issue_Control__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToIssueControlListRec.containskey(eachIssueControl.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToIssueControlListRec.put(eachIssueControl.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Issue_Control__c>{eachIssueControl});
                    }
                    else
                    {
                        List<Issue_Control__c> issueControlRecFetched=orderToIssueControlListRec.get(eachIssueControl.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        issueControlRecFetched.add(eachIssueControl);
                        orderToIssueControlListRec.put(eachIssueControl.Implementation_Tracking_ID__r.Implementation_Record_ID__c,issueControlRecFetched);
                    }
                }
                
                Map<Id,List<Life_and_Disability__c>> orderToLifeandDisabilityListRec=new Map<Id,List<Life_and_Disability__c>>();
                for(Life_and_Disability__c eachLifeDisability:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Life_and_Disability__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToLifeandDisabilityListRec.containskey(eachLifeDisability.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToLifeandDisabilityListRec.put(eachLifeDisability.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Life_and_Disability__c>{eachLifeDisability});
                    }
                    else
                    {
                        List<Life_and_Disability__c> lifeDisabilityRecFetched=orderToLifeandDisabilityListRec.get(eachLifeDisability.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        lifeDisabilityRecFetched.add(eachLifeDisability);
                        orderToLifeandDisabilityListRec.put(eachLifeDisability.Implementation_Tracking_ID__r.Implementation_Record_ID__c,lifeDisabilityRecFetched);
                    }
                }
                
                Map<Id,List<Rx__c>> orderToRxListRec=new Map<Id,List<Rx__c>>();
                for(Rx__c eachRx:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Rx__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToRxListRec.containskey(eachRx.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToRxListRec.put(eachRx.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Rx__c>{eachRx});
                    }
                    else
                    {
                        List<Rx__c> rxRecFetched=orderToRxListRec.get(eachRx.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        rxRecFetched.add(eachRx);
                        orderToRxListRec.put(eachRx.Implementation_Tracking_ID__r.Implementation_Record_ID__c,rxRecFetched);
                    }
                }
                
                Map<Id,List<SBC__c>> orderToSBCListRec=new Map<Id,List<SBC__c>>();
                for(SBC__c eachSBC:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from SBC__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToSBCListRec.containskey(eachSBC.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToSBCListRec.put(eachSBC.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<SBC__c>{eachSBC});
                    }
                    else
                    {
                        List<SBC__c> sbcRecFetched=orderToSBCListRec.get(eachSBC.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        sbcRecFetched.add(eachSBC);
                        orderToSBCListRec.put(eachSBC.Implementation_Tracking_ID__r.Implementation_Record_ID__c,sbcRecFetched);
                    }
                }
                
                Map<Id,List<Contracts__c>> orderToContractListRec=new Map<Id,List<Contracts__c>>();
                for(Contracts__c eachContract:[select Stage__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from Contracts__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToContractListRec.containskey(eachContract.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToContractListRec.put(eachContract.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Contracts__c>{eachContract});
                    }
                    else
                    {
                        List<Contracts__c> contractRecFetched=orderToContractListRec.get(eachContract.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        contractRecFetched.add(eachContract);
                        orderToContractListRec.put(eachContract.Implementation_Tracking_ID__r.Implementation_Record_ID__c,contractRecFetched);
                    }
                }
                
                system.debug('orderToContractListRec-->'+orderToContractListRec);
                
                
                  Map<Id,List<ID_Cards__c>> orderToIdCardsRec=new Map<Id,List<ID_Cards__c>>();
                for(ID_Cards__c eachidcard:[select id,Stage__c,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c from ID_Cards__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToIdCardsRec.containskey(eachidcard.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToIdCardsRec.put(eachidcard.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<ID_Cards__c>{eachidcard});
                    }
                    else
                    {
                        List<ID_Cards__c> idcardRecFetched=orderToIdCardsRec.get(eachidcard.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        idcardRecFetched.add(eachidcard);
                        orderToIdCardsRec.put(eachidcard.Implementation_Tracking_ID__r.Implementation_Record_ID__c,idcardRecFetched);
                    }
                }
                
                system.debug('orderToIdCardListRec-->'+orderToIdCardsRec);
                
                
                      Map<Id,List<Medical_Benefit__c>> orderToMedicalBenefitRec=new Map<Id,List<Medical_Benefit__c>>();
                for(Medical_Benefit__c eachmedicalbenefit:[select Stage__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c,id,Implementation_Tracking_ID__c,Implementation_Tracking_ID__r.Engage_Medical_Benefits__c from Medical_Benefit__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToMedicalBenefitRec.containskey(eachmedicalbenefit.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToMedicalBenefitRec.put(eachmedicalbenefit.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<Medical_Benefit__c>{eachmedicalbenefit});
                    }
                    else
                    {
                        List<Medical_Benefit__c> medicalBenefitRecFetched=orderToMedicalBenefitRec.get(eachmedicalbenefit.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        medicalBenefitRecFetched.add(eachmedicalbenefit);
                        orderToMedicalBenefitRec.put(eachmedicalbenefit.Implementation_Tracking_ID__r.Implementation_Record_ID__c,medicalBenefitRecFetched);
                    }
                }
                
                system.debug('orderToMedicalBenefitRec-->'+orderToMedicalBenefitRec);
                
                
                  Map<Id,List<First_Impressions__c>> orderToFirstImpressionRec=new Map<Id,List<First_Impressions__c>>();
                for(First_Impressions__c eachfirstimpression:[select First_Impressions_Stage__c,Implementation_Tracking_ID__r.Implementation_Record_ID__c,id,Implementation_Tracking_ID__c from First_Impressions__c where Implementation_Tracking_ID__c in :OrderidtoImpTrackId.values() order by createddate desc])
                {
                    if(!orderToFirstImpressionRec.containskey(eachfirstimpression.Implementation_Tracking_ID__r.Implementation_Record_ID__c))
                    {
                        orderToFirstImpressionRec.put(eachfirstimpression.Implementation_Tracking_ID__r.Implementation_Record_ID__c,new List<First_Impressions__c>{eachfirstimpression});
                    }
                    else
                    {
                        List<First_Impressions__c> firstImpressionRecFetched=orderToFirstImpressionRec.get(eachfirstimpression.Implementation_Tracking_ID__r.Implementation_Record_ID__c);
                        firstImpressionRecFetched.add(eachfirstimpression);
                        orderToFirstImpressionRec.put(eachfirstimpression.Implementation_Tracking_ID__r.Implementation_Record_ID__c,firstImpressionRecFetched);
                    }
                }
                
                system.debug('orderToFirstImpressionRec-->'+orderToFirstImpressionRec);
                
                
                //Dental
                Map<Id,List<string>> orderIdToPendingDepartments=new Map<Id,List<string>>();
                for(Id eachorder:orderToDentalListRec.keyset())
                {
                    for(Dental_Complete__c eachdental: orderToDentalListRec.get(eachorder))
                    {
                        if(!orderIdToPendingDepartments.containskey(eachorder))
                         {
                             //system.debug('eachdental.Stage__c-->'+eachdental.Stage__c);
                             if(eachdental.Stage__c!=null)
                             {
                                 string stage;
                                 if(eachdental.Stage__c!='N/A')
                                 {
                               stage=eachdental.Stage__c.substring(0,2);
                                 }
                                 else
                                 {
                                   stage=eachdental.Stage__c;
                                 }
                            orderIdToPendingDepartments.put(eachorder,new List<string>{'Dental-'+stage});
                             }
                             else
                             {
                             //string stage=eachdental.Stage__c.substring(0,2);
                             orderIdToPendingDepartments.put(eachorder,new List<string>{'Dental-00'});
                             }
                         }
                    }
                }
                
                //Vision
                for(Id eachordervision:orderToVisionListRec.keyset())
                {
                    for(Vision__c eachvision: orderToVisionListRec.get(eachordervision))
                    {
                         if(orderIdToPendingDepartments.containskey(eachordervision))
                         {
                               List<string> valfetchedDental=orderIdToPendingDepartments.get(eachordervision);
                               
                               
                               if(eachvision.Stage__c!=null)
                               {
                                string stage=eachvision.Stage__c.substring(0,2);
                               valfetchedDental.add('Vision-'+stage);
                               orderIdToPendingDepartments.put(eachordervision,valfetchedDental);
                               }
                               else
                               {
                                valfetchedDental.add('Vision-00');
                               orderIdToPendingDepartments.put(eachordervision,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                               if(eachvision.Stage__c!=null)
                               {
                               string stage=eachvision.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachordervision,new List<string>{'Vision-'+stage});
                               }
                               else
                               {
                                   orderIdToPendingDepartments.put(eachordervision,new List<string>{'Vision-00'});
                               }
                              break;
                         }
                    }
                }
                
                //UnderWriting
                for(Id eachorderunderwriting:orderToUnderWritingListRec.keyset())
                {
                    for(Underwriting__c eachunderwriting: orderToUnderWritingListRec.get(eachorderunderwriting))
                    {
                         if(orderIdToPendingDepartments.containskey(eachorderunderwriting))
                         {
                               List<string> valfetchedDental=orderIdToPendingDepartments.get(eachorderunderwriting);
                               
                               if(eachunderwriting.Stage__c!=null)
                               {
                                   string stage;
                                   if(eachunderwriting.Stage__c!='N/A')
                                   {
                                stage=eachunderwriting.Stage__c.substring(0,2);
                                   }
                                   else{
                                        stage=eachunderwriting.Stage__c;
                                   }
                               valfetchedDental.add('UW-'+stage);
                               orderIdToPendingDepartments.put(eachorderunderwriting,valfetchedDental);
                               }
                               else
                               {
                            valfetchedDental.add('UW-00');
                               orderIdToPendingDepartments.put(eachorderunderwriting,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                                if(eachunderwriting.Stage__c!=null)
                               {
                                   string stage;
                                   if(eachunderwriting.Stage__c!='N/A')
                                   {
                               stage=eachunderwriting.Stage__c.substring(0,2);
                                   }
                                   else{
                                       stage=eachunderwriting.Stage__c;
                                   }
                              orderIdToPendingDepartments.put(eachorderunderwriting,new List<string>{'UW-'+stage});
                               }
                               else
                               {
                                   orderIdToPendingDepartments.put(eachorderunderwriting,new List<string>{'UW-00'});
                               }
                              break;
                         }
                    }
                }
                
                //Membership
                for(Id eachOrderMembership: orderToMembershipListRec.keyset())
                {
                    for(Enrollment_and_Billing__c eachmembership: orderToMembershipListRec.get(eachOrderMembership))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderMembership))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderMembership);
                               if(eachmembership.Stage__c!=null)
                               {
                                   string stage;
                                   if(eachmembership.Stage__c!='N/A')
                                   {
                                stage=eachmembership.Stage__c.substring(0,2);
                                   }
                                   else{
                                        stage=eachmembership.Stage__c;
                                   }
                               valfetchedDental.add('E&B-'+stage);
                               orderIdToPendingDepartments.put(eachOrderMembership,valfetchedDental);
                               }
                               else
                               {
                                   valfetchedDental.add('E&B-00');
                               orderIdToPendingDepartments.put(eachOrderMembership,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                              if(eachmembership.Stage__c!=null)
                              {
                                  string stage;
                                  if(eachmembership.Stage__c!='N/A')
                                  {
                              stage=eachmembership.Stage__c.substring(0,2);
                                  }
                                  else{
                                       stage=eachmembership.Stage__c;
                                  }
                              orderIdToPendingDepartments.put(eachOrderMembership,new list<string>{'E&B-'+stage});
                              }
                              else
                              {
                                  orderIdToPendingDepartments.put(eachOrderMembership,new list<string>{'E&B-00'});
                              }
                              break;
                         }
                    }
                }
                
                //Interplan
                for(Id eachOrderInterplan: orderToInterplanListRec.keyset())
                {
                    for(InterPlan__c eachInterPlan: orderToInterplanListRec.get(eachOrderInterplan))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderInterplan))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderInterplan);
                               if(eachInterPlan.Stage__c!=null)
                               {
                                string stage=eachInterPlan.Stage__c.substring(0,2);
                               valfetchedDental.add('IP-'+stage);
                               orderIdToPendingDepartments.put(eachOrderInterplan,valfetchedDental);
                               }
                               else
                               {
                                   valfetchedDental.add('IP-00');
                               orderIdToPendingDepartments.put(eachOrderInterplan,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                             if(eachInterPlan.Stage__c!=null)
                             {
                              string stage=eachInterPlan.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrderInterplan,new list<string>{'IP-'+stage});
                             }
                             else{
                                orderIdToPendingDepartments.put(eachOrderInterplan,new list<string>{'IP-00'}); 
                             }
                              break;
                         }
                    }
                }
                
                //Case Installation
                for(Id eachOrderIssueControl: orderToIssueControlListRec.keyset())
                {
                    for(Issue_Control__c eachIssueControl: orderToIssueControlListRec.get(eachOrderIssueControl))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderIssueControl))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderIssueControl);
                               if(eachIssueControl.Stage__c!=null)
                               {
                                   string stage;
                                   if(eachIssueControl.Stage__c!='N/A')
                                   {
                                   stage=eachIssueControl.Stage__c.substring(0,2);
                                   }
                                   else{
                                        stage=eachIssueControl.Stage__c;
                                   }
                               valfetchedDental.add('CIT-'+stage);
                               orderIdToPendingDepartments.put(eachOrderIssueControl,valfetchedDental);
                               }
                               else
                               {
                                   valfetchedDental.add('CIT-00');
                               orderIdToPendingDepartments.put(eachOrderIssueControl,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                             if(eachIssueControl.Stage__c!=null)
                             {
                                 string stage;
                                  if(eachIssueControl.Stage__c!='N/A')
                                  {
                                    stage=eachIssueControl.Stage__c.substring(0,2);
                                  }
                                  else
                                  {
                                    stage=eachIssueControl.Stage__c;
                                  }
                              orderIdToPendingDepartments.put(eachOrderIssueControl,new list<string>{'CIT-'+stage});
                             }
                             else
                             {
                                 orderIdToPendingDepartments.put(eachOrderIssueControl,new list<string>{'CIT-00'});
                             }
                              break;
                         }
                    }
                }
                
                //Life and Disability
                for(Id eachOrderLifeDisability: orderToLifeandDisabilityListRec.keyset())
                {
                    for(Life_and_Disability__c eachLifeDisability: orderToLifeandDisabilityListRec.get(eachOrderLifeDisability))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderLifeDisability))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderLifeDisability);
                               if(eachLifeDisability.Stage__c!=null)
                               {
                               string stage=eachLifeDisability.Stage__c.substring(0,2);
                               valfetchedDental.add('L&D-'+stage);
                               orderIdToPendingDepartments.put(eachOrderLifeDisability,valfetchedDental);
                               }
                               else{
                                valfetchedDental.add('L&D-00');
                               orderIdToPendingDepartments.put(eachOrderLifeDisability,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                             if(eachLifeDisability.Stage__c!=null)
                             {
                              string stage=eachLifeDisability.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrderLifeDisability,new list<string>{'L&D-'+stage});
                             }
                             else
                             {
                                 orderIdToPendingDepartments.put(eachOrderLifeDisability,new list<string>{'L&D-00'});
                             }
                              break;
                         }
                    }
                }
                
                //Rx
                for(Id eachOrderRx: orderToRxListRec.keyset())
                {
                    for(Rx__c eachRx: orderToRxListRec.get(eachOrderRx))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderRx))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderRx);
                               if(eachRx.Stage__c!=null)
                               {
                                   string stage;
                                   if(eachRx.Stage__c!='N/A')
                                   {
                                stage=eachRx.Stage__c.substring(0,2);
                                   }
                                   else{
                                        stage=eachRx.Stage__c;
                                   }
                               valfetchedDental.add('Rx-'+stage);
                               orderIdToPendingDepartments.put(eachOrderRx,valfetchedDental);
                               }
                               else{
                                valfetchedDental.add('Rx-00');
                               orderIdToPendingDepartments.put(eachOrderRx,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                              if(eachRx.Stage__c!=null)
                              {
                                  string stage;
                                if(eachRx.Stage__c!='N/A')
                                 { 
                               stage=eachRx.Stage__c.substring(0,2);
                              }
                                 else{
                                      stage=eachRx.Stage__c;
                                   }
                              orderIdToPendingDepartments.put(eachOrderRx,new list<string>{'Rx-'+stage});
                              }
                              else
                              {
                                  orderIdToPendingDepartments.put(eachOrderRx,new list<string>{'Rx-00'});
                              }
                              break;
                         }
                    }
                }
                
                //SBC
                for(Id eachOrderSBC: orderToSBCListRec.keyset())
                {
                    for(SBC__c eachSBC: orderToSBCListRec.get(eachOrderSBC))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderSBC))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderSBC);
                               if(eachSBC.Stage__c!=null)
                               {
                               string stage=eachSBC.Stage__c.substring(0,2);
                               valfetchedDental.add('SBC-'+stage);
                               orderIdToPendingDepartments.put(eachOrderSBC,valfetchedDental);
                               }
                               else
                               {
                                  valfetchedDental.add('SBC-00');
                               orderIdToPendingDepartments.put(eachOrderSBC,valfetchedDental); 
                               }
                               break;
                         }
                         else
                         {
                             if(eachSBC.Stage__c!=null)
                             {
                             string stage=eachSBC.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrderSBC,new list<string>{'SBC-'+stage});
                             }
                             else{
                                   orderIdToPendingDepartments.put(eachOrderSBC,new list<string>{'SBC-00'});
                             }
                              break;
                         }
                    }
                }
                
                //Contracts
                for(Id eachOrderContract: orderToContractListRec.keyset())
                {
                    for(Contracts__c eachContract: orderToContractListRec.get(eachOrderContract))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderContract))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderContract);
                               
                               //system.debug('eachContract.Stage__c-->'+eachContract.Stage__c);
                               if(eachContract.Stage__c!=null)
                               {
                               string stage=statustopriority.get(eachContract.Stage__c);
                               //system.debug('stage here-->'+stage);
                               valfetchedDental.add('C&B-'+stage);
                               orderIdToPendingDepartments.put(eachOrderContract,valfetchedDental);
                               }
                               else
                               {
                                valfetchedDental.add('C&B-00');
                               orderIdToPendingDepartments.put(eachOrderContract,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                             if(eachContract.Stage__c!=null)
                             {
                             string stage=statustopriority.get(eachContract.Stage__c);
                              orderIdToPendingDepartments.put(eachOrderContract,new list<string>{'C&B-'+stage});
                             }
                             else{
                                 orderIdToPendingDepartments.put(eachOrderContract,new list<string>{'C&B-00'});
                             }
                              break;
                         }
                    }
                }
                
                
                
                 //ID Card
                for(Id eachOrderIdCard: orderToIdCardsRec.keyset())
                {
                    for(ID_Cards__c eachid: orderToIdCardsRec.get(eachOrderIdCard))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderIdCard))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderIdCard);
                                if(eachid.Stage__c!=null)
                               {
                               string stage=eachid.Stage__c.substring(0,2);
                               valfetchedDental.add('ID-'+stage);
                               orderIdToPendingDepartments.put(eachOrderIdCard,valfetchedDental);
                               }
                               else
                               {
                                  valfetchedDental.add('ID-00');
                               orderIdToPendingDepartments.put(eachOrderIdCard,valfetchedDental); 
                               }
                               
                               break;
                         }
                         else
                         {
                               if(eachid.Stage__c!=null)
                             {
                             string stage=eachid.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrderIdCard,new list<string>{'ID-'+stage});
                             }
                             else{
                                   orderIdToPendingDepartments.put(eachOrderIdCard,new list<string>{'ID-00'});
                             }
                             
                              break;
                         }
                    }
                }
                
                
               //Medical Benefit
                for(Id eachOrdermedical: orderToMedicalBenefitRec.keyset())
                {
                    for(Medical_Benefit__c eachmedical: orderToMedicalBenefitRec.get(eachOrdermedical))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrdermedical))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrdermedical);
                                 if(eachmedical.Stage__c!=null)
                               {
                               string stage=eachmedical.Stage__c.substring(0,2);
                               valfetchedDental.add('EBA-'+stage);
                               orderIdToPendingDepartments.put(eachOrdermedical,valfetchedDental);
                               }
                               else
                               {
                                  valfetchedDental.add('EBA-00');
                               orderIdToPendingDepartments.put(eachOrdermedical,valfetchedDental); 
                               }
                               //valfetchedDental.add('EBA');
                               //orderIdToPendingDepartments.put(eachOrdermedical,valfetchedDental);
                               break;
                         }
                         else
                         {
                             
                              if(eachmedical.Stage__c!=null)
                             {
                             string stage=eachmedical.Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrdermedical,new list<string>{'EBA-'+stage});
                             }
                             else{
                                   orderIdToPendingDepartments.put(eachOrdermedical,new list<string>{'EBA-00'});
                             }
                              //orderIdToPendingDepartments.put(eachOrdermedical,new list<string>{'EBA'});
                              break;
                         }
                    }
                }
                
                   //First Impression
                for(Id eachOrderfirstimpression: orderToFirstImpressionRec.keyset())
                {
                    for(First_Impressions__c eachfi: orderToFirstImpressionRec.get(eachOrderfirstimpression))
                    {
                         if(orderIdToPendingDepartments.containskey(eachOrderfirstimpression))
                         {
                               list<string> valfetchedDental=orderIdToPendingDepartments.get(eachOrderfirstimpression);
                               if(eachfi.First_Impressions_Stage__c!=null)
                               {
                               string stage=eachfi.First_Impressions_Stage__c.substring(0,2);
                               valfetchedDental.add('F-I-'+stage);
                               orderIdToPendingDepartments.put(eachOrderfirstimpression,valfetchedDental);
                               }
                               else
                               {
                                   valfetchedDental.add('F-I-00');
                               orderIdToPendingDepartments.put(eachOrderfirstimpression,valfetchedDental);
                               }
                               break;
                         }
                         else
                         {
                             if(eachfi.First_Impressions_Stage__c!=null)
                             {
                             string stage=eachfi.First_Impressions_Stage__c.substring(0,2);
                              orderIdToPendingDepartments.put(eachOrderfirstimpression,new list<string>{'F-I-'+stage});
                             }
                             else
                             {
                                 orderIdToPendingDepartments.put(eachOrderfirstimpression,new list<string>{'F-I-00'});
                             }
                              break;
                         }
                    }
                }
                
                system.debug('orderIdToPendingDepartments-->'+orderIdToPendingDepartments);
           //placeholder for other SME Departments
           
           //string pendingDepartmentstring='';
           List<order>orderToBeUpdated=new List<Order>();
           for(order Pendingorder:[select id,Current_SME_Stage__c,Implementation_Status__c,Tracking_Record_Exists__c from order where id in:orderIdToPendingDepartments.keyset()])
           {
               
               //pendingDepartmentstring=String.join(orderIdToPendingDepartments.get(Pendingorder.id), ',');
               //pendingDepartmentstring=pendingDepartmentstring.removeend(',');
               Pendingorder.Current_SME_Stage__c=String.join(orderIdToPendingDepartments.get(Pendingorder.id), ',');
               Pendingorder.Batch_Processed_Records__c=true;
               orderToBeUpdated.add(Pendingorder);
               
           }
           
          
            if(!orderToBeUpdated.isempty() && orderToBeUpdated.size() >0)
            {
                //update orderToBeUpdated;
                Database.SaveResult[] srList = Database.update(orderToBeUpdated, false);
                for(Integer i=0;i<srList.size();i++)
                {
                  if (!srList.get(i).isSuccess()){
                // DML operation failed
                Database.Error error = srList.get(i).getErrors().get(0);
                String failedDML = error.getMessage();
                //orderToBeUpdated.get(i);//failed record from the list
                system.debug('Failed ID'+orderToBeUpdated.get(i).Id);
                errorMap.put(orderToBeUpdated.get(i).Id,failedDML);
                
                 }

                 }


             // Iterate through each returned result
             /*
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                        successMap.put(sr.getId(),'Success');
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage()+':' +sr.getId());
                            //System.debug('Account fields that affected this error: ' + err.getFields());
                            errorMap.put(sr.getId(),err.getMessage());
                        }
                    }
                }*/
             }
            List<ExceptionLog__c> excepreclst=new List<ExceptionLog__c>();
            for(Id i: errorMap.keyset())
            {
                excepreclst.add(new ExceptionLog__c(ClassName__c='LGSMENotApproved', ExceptionLogTimestamp__c=Datetime.now(),
                                Order__c=i,ExceptionDetails__c=errorMap.get(i),Order_Id__c=i));
            }
            try
            {
                if(!excepreclst.isempty() && excepreclst.size() >0)
                {
                    upsert excepreclst ExceptionLog__c.Fields.Order_Id__c;
                }
            }
            
           Catch(Exception ex) { system.debug('The exception is:'+ex.getmessage()+'and line no is:'+ex.getlinenumber());
           }
        
        }
      
        
        global void finish(Database.BatchableContext BC){
          
        }
    }