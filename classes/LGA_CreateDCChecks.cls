/***********************************************************************
@class Name   : LGA_CreateDCChecks
@date Created : 08/19/2019 (MM/DD/YYYY)
@created By   : Accenture Offshore
@description  : This class is used called from LGA_CreateDocumentChecklist
@change History : 08/27/2019 (As a Part of PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610 )
**************************************************************************/
public with sharing class LGA_CreateDCChecks {
    
    /****************************************************************************************************
@method Name : createDocumentsforImplCase
@description : checkLOB This method checks the criteria for LOB.
@param : This method accepts Application_Document_Config__c & List of QuoteLineItem as parameters.
@return : This method returns a Boolean Values.
******************************************************************************************************/
    public Boolean checkLOB(Application_Document_Config__c docConfig, List<QuoteLineItem> qliList){
        Boolean checkLOB = LGA_Constants.CHECKLOB;
        Try{
            List<String> docConfigLOBList = new List<String>();
            if(String.isNotBlank(docConfig.Line_Of_Business__c)){
                for(String lob: docConfig.Line_Of_Business__c.split(';')){
                    docConfigLOBList.add(lob.toLowerCase());
                }
            }
            if(!docConfigLOBList.isEmpty() && String.isNotBlank(docConfig.Product_Category__c) 
               && String.isNotBlank(docConfig.Product_Stage__c) ){ 
                   for(QuoteLineItem qli: qliList){
                       system.debug('@@@condition55555' + docConfigLOBList.contains(qli.Product2.Product_Type__c.toLowerCase()));
                       if((String.isNotBlank(qli.ProductStage__c)) 
                          && (String.isNotBlank(qli.ProductCategory__c))
                          && qli.ProductCategory__c == docConfig.Product_Category__c 
                          && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                          && docConfigLOBList.contains(qli.Product2.Product_Type__c.toLowerCase())){
                              checkLOB=true;
                          }
                   }
               } 
           
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return checkLOB;
    }
    
    /****************************************************************************************************
@method Name : additionalChecks
@description : checkLOB This method checks Other Criteria for Document Check List Creation.
@param : This method accepts Application_Document_Config__c & List of QuoteLineItem as parameters.
@return : This method returns a Boolean Values.
******************************************************************************************************/    
    public Boolean additionalChecks(Application_Document_Config__c docConfig, List<QuoteLineItem> qliList, Order ord){
        Boolean additionalCheck = LGA_Constants.CHECKLOB;
        Try{
            if (docConfig.Additional_Checks__c){
                if(String.isNotBlank(docConfig.ERISA_Qualified__c) 
                   && (docConfig.ERISA_Qualified__c == ord.Account.Is_this_Group_subject_to_ERISA__c)){
                       for(QuoteLineItem qli: qliList){
                           if((String.isNotBlank(qli.ProductStage__c)) 
                              && (String.isNotBlank(qli.ProductCategory__c))
                              && qli.ProductCategory__c == docConfig.Product_Category__c 
                              && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                             ){
                                 additionalCheck = True;
                             }
                       }
                       
                   }
                else if(String.isNotBlank(docConfig.Funding__c) && String.isBlank(docConfig.Financing__c) ){  //
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                           && qli.ProductCategory__c == docConfig.Product_Category__c){
                               if(docConfig.Funding__c == qli.Funding__c){ 
                                   additionalCheck = True;
                               }  
                           }
                    }
                }
                else if(String.isNotBlank(docConfig.Product_Family__c) && String.isBlank(docConfig.Financing__c) ){ //
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c ))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                               if(docConfig.Product_Family__c == qli.Product2.Product_Family__c ){
                                   additionalCheck = True;
                               }  
                           }
                    }
                }
                else if(String.isNotBlank(docConfig.Pooled_Non_Pooled__c)){
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                               if(docConfig.Pooled_Non_Pooled__c == ord.Account.Pooled_Non_Pooled__c ){
                                   additionalCheck = True;
                               }  
                           }
                    }
                } 
                else if(String.isNotBlank(docConfig.CEP_Indicator__c)){
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                               if(docConfig.CEP_Indicator__c == qli.CEP_Indicator__c ){
                                   additionalCheck = True;
                               }  
                           }
                    }
                }  
                else if(docConfig.Employee_Assistance_Program__c){
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                               if(docConfig.Employee_Assistance_Program__c == ord.Quote.Employee_Assistance_Program__c){
                                   additionalCheck = True;
                               }  
                           }
                    }
                }
                else if(String.isNotBlank(docConfig.Product_Name__c)){
                    List<String> prdNames = New List<String>();
                    if(docConfig.Product_Name__c.indexOf(',') > 0){
                        for(String str : docConfig.Product_Name__c.split(',')){
                            prdNames.add(str);
                        }
                    } else{
                        prdNames.add(docConfig.Product_Name__c); 
                    }
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                               for(String str : prdNames){
                                   if(qli.product2.Name.Contains(str)){
                                       additionalCheck = True;
                                   }
                               }
                               
                           }
                    }
                }
                else if( String.isNotBlank(docConfig.Financing__c) && String.isBlank(docConfig.Funding__c) 
                        && String.isBlank(docConfig.Product_Family__c) ){ //
                            for(QuoteLineItem qli: qliList){
                                if((String.isNotBlank(qli.ProductStage__c)) 
                                   && (String.isNotBlank(qli.ProductCategory__c))
                                   && qli.ProductCategory__c == docConfig.Product_Category__c 
                                   && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                                   && docConfig.Financing__c.contains(qli.Financing__c) 
                                  ){
                                       additionalCheck = True; 
                                   }
                            }
                        } 
                else if( String.isNotBlank(docConfig.Financing__c) && String.isNotBlank(docConfig.Product_Family__c) ){ //
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                           && docConfig.Financing__c.contains(qli.Financing__c) 
                           && docConfig.Product_Family__c == qli.Product2.Product_Family__c ){
                               additionalCheck = True; 
                           }
                    }
                } 
                else if(String.isNotBlank(docConfig.Financing__c) && String.isNotBlank(docConfig.Funding__c) ){ // 
                    for(QuoteLineItem qli: qliList){
                        if((String.isNotBlank(qli.ProductStage__c)) 
                           && (String.isNotBlank(qli.ProductCategory__c))
                           && qli.ProductCategory__c == docConfig.Product_Category__c 
                           && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                           && docConfig.Financing__c.contains(qli.Financing__c) 
                           && docConfig.Funding__c == qli.Funding__c ){
                               additionalCheck = True; 
                           }
                    }
                } 
            }
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return additionalCheck;
    }
    
    
    /****************************************************************************************************
@method Name : dcNameExtension
@description : checkLOB This method checks Other Criteria for Document Check List Creation.
@param : This method accepts Application_Document_Config__c & List of QuoteLineItem as parameters.
@return : This method returns a Boolean Values.
******************************************************************************************************/    
    public List<String> dcNameExtension(Application_Document_Config__c docConfig, List<QuoteLineItem> qliList, Order ord){
        List<String> dcNameExtension = new List<String>();
        Try{
            if ((docConfig.Files_Parameter__c == LGA_Constants.LOB) 
                && (String.isNotBlank(docConfig.Line_Of_Business__c))){
                    List<String> docConfigLOBList = new List<String>();
                    for(String lob: docConfig.Line_Of_Business__c.split(';')){
                        docConfigLOBList.add(lob.toLowerCase());
                    }
                    if(!docConfigLOBList.isEmpty() && String.isNotBlank(docConfig.Product_Category__c) 
                       && String.isNotBlank(docConfig.Product_Stage__c)){
                           for(QuoteLineItem qli: qliList){
                              if((String.isNotBlank(qli.ProductStage__c)) 
                                  && (String.isNotBlank(qli.ProductCategory__c))
                                  && qli.ProductCategory__c == docConfig.Product_Category__c 
                                  && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                                  && docConfigLOBList.contains(qli.Product2.Product_Type__c.toLowerCase()) ) {
                                      dcNameExtension.add(qli.Product2.Product_Type__c.toUpperCase()) ;                              
                                  }
                           }
                       }
                }
            else if(docConfig.Files_Parameter__c == LGA_Constants.QLI  && String.isNotBlank(docConfig.Line_Of_Business__c)){
               List<String> docConfigLOBList = new List<String>();
                for(String dcLOB: docConfig.Line_Of_Business__c.split(';')){
                    docConfigLOBList.add(dcLOB.toLowerCase());
                }
                if(!docConfigLOBList.isEmpty() && String.isNotBlank(docConfig.Product_Category__c) 
                   && String.isNotBlank(docConfig.Product_Stage__c)){
                       for(QuoteLineItem qli: qliList){
                          
                           if((String.isNotBlank(qli.ProductStage__c)) 
                              && (String.isNotBlank(qli.ProductCategory__c))
                              && qli.ProductCategory__c == docConfig.Product_Category__c 
                              && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                              && docConfigLOBList.contains(qli.Product2.Product_Type__c.toLowerCase()) ) {
                                  if(qli.Product2.Name != Null ){
                                      dcNameExtension.add(qli.Product2.Name.toUpperCase()) ;
                                  }
                                  else if(qli.Product2.Name == Null ){
                                      dcNameExtension.add(' ') ;  
                                  }
                              }
                       }
                   }
            }
            else if(docConfig.Files_Parameter__c == LGA_Constants.QLI && String.isBlank(docConfig.Line_Of_Business__c)){
                for(QuoteLineItem qli: qliList){

                    if((String.isNotBlank(qli.ProductStage__c)) 
                       && (String.isNotBlank(qli.ProductCategory__c))
                       && qli.ProductCategory__c == docConfig.Product_Category__c 
                       && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                      ){
                          dcNameExtension.add(qli.Product2.Name.toUpperCase());
                      }
                }
            }
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return dcNameExtension;
    }
    
    
    /****************************************************************************************************
@method Name : checkNoOfDC
@description : checkNoOfDC This method gives the # of Document Checklist to be created for the  Implementation Case.
@param : This method accepts Application_Document_Config__c, Boolean & List of QuoteLineItem as parameters.
@return : This method returns a Integer.
******************************************************************************************************/
    public Integer checkNoOfDC(Application_Document_Config__c docConfig, Boolean checkLOB,List<QuoteLineItem> qliList){
        Integer counter = LGA_Constants.COUNTER ;
        Try{
            
            if(String.isNotBlank(docConfig.Files_Parameter__c)){
                if(checkLOB){
                    if(docConfig.Files_Parameter__c == LGA_Constants.ICR){
                        counter = 1;
                    }
                    
                    // Modified the code as a part of (PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610)
                    else if(docConfig.Files_Parameter__c == LGA_Constants.LOB && String.isNotBlank(docConfig.Line_Of_Business__c)){
                        //for each LOB 
                        List<String> docConfigLOBList = new List<String>();
                        Map<String,List<QuoteLineItem>> qliLOBMap = new Map<String,List<QuoteLineItem>>();
                        List<QuoteLineItem> qliList2;
                        if(String.isNotBlank(docConfig.Line_Of_Business__c)){
                            for(String dcLOB: docConfig.Line_Of_Business__c.split(';')){
                                docConfigLOBList.add(dcLOB.toLowerCase());
                            }
                        }
                        for(QuoteLineItem qli: qliList){
                            if(qliLOBMap.containskey(qli.Product2.Product_Type__c.toLowerCase())){
                                qliLOBMap.get(qli.Product2.Product_Type__c.toLowerCase()).add(qli);
                            }
                            else{
                                //List<QuoteLineItem> qliList2 = new List<QuoteLineItem>();
                                qliList2 = new List<QuoteLineItem>();
                                qliList2.add(qli);
                                qliLOBMap.put(qli.Product2.Product_Type__c.toLowerCase(),qliList2);
                            }
                        }
                        
                        if(!docConfigLOBList.isEmpty() && String.isNotBlank(docConfig.Product_Category__c) 
                           && String.isNotBlank(docConfig.Product_Stage__c)){
                               for(String lobString: docConfigLOBList){
                                   if(qliLOBMap.KeySet().contains(lobString) && !qliLOBMap.get(lobString).isEmpty()){
                                       Boolean increaseCount = False;
                                       for(QuoteLineItem qliRec : qliLOBMap.get(lobString)){
                                           if((String.isNotBlank(qliRec.ProductStage__c)) 
                                              && (qliRec.ProductCategory__c != Null || qliRec.ProductCategory__c != '')
                                              && qliRec.ProductCategory__c == docConfig.Product_Category__c 
                                              // && qliRec.ProductStage__c == docConfig.Product_Stage__c
                                              && docConfigLOBList.contains(qliRec.Product2.Product_Type__c.toLowerCase())){
                                                  increaseCount = True;
                                              }
                                       }
                                       If(increaseCount){
                                           counter++ ;
                                       }
                                       
                                   }
                               }
                               
                           }
                        //counter = Integer.valueOf(docConfig.Expected_No_of_Files__c)*counter;
                        counter = 1*counter;
                        system.debug('@@@counter2' + counter);               
                    }
                    
                    // Modified the code as a part of (PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610) 
                    //Try OR Product Or QLI
                    else if(docConfig.Files_Parameter__c == LGA_Constants.QLI && String.isNotBlank(docConfig.Line_Of_Business__c)){
                        //will be updated once we get the requirements
                        List<String> docConfigLOBList = new List<String>();
                        //if(String.isNotBlank(docConfig.Line_Of_Business__c)){
                        for(String dcLOB: docConfig.Line_Of_Business__c.split(';')){
                            docConfigLOBList.add(dcLOB.toLowerCase());
                        }
                        //}
                        if(!docConfigLOBList.isEmpty() && String.isNotBlank(docConfig.Product_Category__c) 
                           && docConfig.Product_Stage__c != Null){
                               for(QuoteLineItem qli: qliList){
                                   if((String.isNotBlank(qli.ProductStage__c)) 
                                      && (String.isNotBlank(qli.ProductCategory__c))
                                      && qli.ProductCategory__c == docConfig.Product_Category__c 
                                      && docConfig.Product_Stage__c.contains(qli.ProductStage__c )
                                      && docConfigLOBList.contains(qli.Product2.Product_Type__c.toLowerCase())){
                                          counter++ ;
                                      }
                               }
                           }
                        counter = 1*counter;
                        system.debug('@@@counter3' + counter);   
                    }
                    
                    // Modified the code as a part of (PRDCRM-41239, PRDCRM-40178, PRDCRM-41195, PRDCRM-41197, PRDCRM-40609, PRDCRM-41841 & PRDCRM-40610)
                    else if(docConfig.Files_Parameter__c == LGA_Constants.QLI && String.isBlank(docConfig.Line_Of_Business__c)){
                        //will be updated once we get the requirements
                        
                        for(QuoteLineItem qli: qliList){
                            if((String.isNotBlank(qli.ProductStage__c)) 
                               && (String.isNotBlank(qli.ProductCategory__c) )
                               && qli.ProductCategory__c == docConfig.Product_Category__c 
                               && docConfig.Product_Stage__c.contains(qli.ProductStage__c )){
                                   counter++ ;
                               }
                        }
                        //counter = Integer.valueOf(docConfig.Expected_No_of_Files__c)*counter;
                        counter = 1*counter;
                    }
                    
                }
            }
          
        }
        Catch(Exception ex){
            System.debug('****The following exception has occurred: '+ex.getMessage());
        }
        return counter;
    }
    
}