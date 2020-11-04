/*
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Name              CreateGroupNumber
* Author            Deloitte offshore (Gladiators)
* ModifiedBy		 Deloitte offshore (Gladiators)
* CreatedDate       23st March 2018
* UsedBy			 Generate GroupNumber (Vlocity Button)
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Description	     
* Used by "Generate GroupNumber" vlocity button to generate the group # in sequence.
* 
* Additional information
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Changes
* Version					v1.1
* Date						22 August2019						
* Explanation				Updated the class as part of JIRA ID PRDCRM- 41010
* ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

global  without sharing class CreateGroupNumber implements vlocity_ins.VlocityOpenInterface2{
    // changed as part of Code Coverage fix
    public static final String GETGROUPNUMBER = staticVariableClass.CreateGrpGETGROUPNUMBER;
    public static final String UPDATENEXTNUMBERUTILITY = staticVariableClass.CreateGrpUPDATENEXTNUMBERUTILITY;
    private static final String STATUSCODE =staticVariableClass.CreateGrpSTATUSCODE;
    private static final String SUCCESS =staticVariableClass.CreateGrpSUCCESS;
    private static final String FAILURE =staticVariableClass.CreateGrpFAILURE;
    private static final String REQUESTGROUPNUMBERSTEP = staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP;
    private static final String ACCTID = staticVariableClass.CreateGrpACCTID;
    private static final String GROUPNUMBER = staticVariableClass.CreateGrpGROUPNUMBER;
    private static final String ERROR = staticVariableClass.CreateGrpERROR;
    private static final String NOSTATERECORD = staticVariableClass.CreateGrpNOSTATERECORD;
    private static final String WARNINGFLAG = staticVariableClass.CreateGrpWARNINGFLAG;
    private String abbreviation = '';
    
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> optns){
        if(staticVariableClass.CreateGrpGETGROUPNUMBER.equalsIgnoreCase(methodName)){
            //This method will be called when Generate Group # button is clicked
            getGroupNumber(inputMap, outMap, true);   
        }else if(staticVariableClass.CreateGrpUPDATENEXTNUMBERUTILITY.equalsIgnoreCase(methodName)){
            //This method will be called post all actions to update Next Number utility record
            updateNextNumberUtility(inputMap, outMap);
        }
        return true;
    }
    
    global Map<String,Object> getGroupNumber(Map<String, Object> inputMap, Map<String,Object> outMap, Boolean omniScriptCall){
        Map<String, Object> requestGroupNumberStepMap = (Map<String, Object>) inputMap.get(staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP);
        Integer lastGeneratedNumber;
        String currentStatePrefix;
        ID accountID = (ID)inputMap.get(staticVariableClass.CreateGrpACCTID);
        String accountSitusStatus;
        
        //Query Situs status value from acount using the account ID fetched from inputMap.
        accountSitusStatus = [select Situs_State__c from Account where ID =: accountID].Situs_State__c;
        if(String.isNotBlank(accountSitusStatus)){
            //Query the Next Number utility record using Situs status.
            List<Next_Number_Utility__c> lastNumberlist = [select Last_Number_Used__c,Warning_Value__c , Max_Value__c,Current_State_Prefix__c,Name from Next_Number_Utility__c 
                                                            where Name =: accountSitusStatus];
            //Fetching Situs state's abbreviation from custom meta data types //PRDCRM-21257 
            
            List<Situs_State_Mapping__mdt> stateAbbreviationList = new List<Situs_State_Mapping__mdt>();
            if(accountSitusStatus == staticVariableClass.CreateGroupNumberNH){
                stateAbbreviationList = [select State_Abbreviation__c from Situs_State_Mapping__mdt 
                                         where DeveloperName =: staticVariableClass.CreateGroupNumberNH1];
                
            }else{
                stateAbbreviationList = [select State_Abbreviation__c from Situs_State_Mapping__mdt 
                                         where DeveloperName =: accountSitusStatus ];
            }
            
            String stateAbbreviation = !stateAbbreviationList.isEmpty() ? stateAbbreviationList.get(0).State_Abbreviation__c : null;
            currentStatePrefix =  !lastNumberlist.isEmpty() ? lastNumberlist.get(0).Current_State_Prefix__c : null;
            
            if(!lastNumberlist.isEmpty()){
                String lastGeneratedNumberString;
                if( lastNumberlist.get(0).Current_State_Prefix__c!=null && lastNumberlist.get(0).Last_Number_Used__c == lastNumberlist.get(0).Max_Value__c && Label.LGPrefixedStates.contains(lastNumberlist.get(0).Name)){
                    //Generate Next Prefix(ex: GB - GC) using ASCII values
                    Integer charcode = currentStatePrefix.charAt(1);
                    String previousChar = string.fromCharArray(new List<Integer>{charcode});
                    String nextChar = string.fromCharArray(new List<Integer>{charcode+1});
                    
                    //Replace Old char with New Char
                    abbreviation = currentStatePrefix.replace(previousChar,nextChar);
                    
                    //Reset LAst number used to 000 in case of Exceptional states from Custom Lable : LGPrefixedStates
                    lastNumberlist.get(0).Current_State_Prefix__c = abbreviation;
                    currentStatePrefix = abbreviation;
                    lastGeneratedNumberString = staticVariableClass.CreateGroupNumberGAReset; //As per PRDCRM-40549 - after GA9999 -- value is initialized to GB0000
                }
                
                lastGeneratedNumber =  lastGeneratedNumberString ==null ? Integer.valueOf(lastNumberlist.get(0).Last_Number_Used__c + 1) :  Integer.valueOf(lastGeneratedNumberString);  
                
                String lastNumberSubString = (String.valueOf(lastGeneratedNumber)).subString(0,1)+'%';
                
                //Query all Group Number to check the group number do not generate duplicate on using Generate Group # button.
                List<Group__c> groupNumberlist = [select Name  from Group__c 	where isActive__c = true 
                                                   and Name NOT IN ('TBD', 'TBD Customer') 
                                                   and Name like: lastNumberSubString];
                Set<String> groupNumberSet = new Set<String>();
                //Iterate through the Group Number list and drop all the Group Name to the set
                for(Group__c G : groupNumberlist){
                    groupNumberSet.add(G.Name);
                }
                
                //Iterate the last generated number against Max_Value__c, If duplicate found then increment LastGeneratedNumber by 1.
                for(Integer i= lastGeneratedNumber; i <= Integer.valueOf(lastNumberlist.get(0).Max_Value__c); i++){
                    //Checking if the group number generated is not in the list to avoid duplicates
                    if(!groupNumberSet.contains(String.valueOf(i))){
                        //Show error if the generated value is about to reach Max_Value__c
                        String isError ='No';
                        String groupNumberLocal;
                        
                        //Setting Groupnumber based on the exceptional states //PRDCRM-21257
                        //Populate isError if Situs_State__c is Georgia and auto generated number is in the buffer (last 100)
                        
                        
                        if(Label.LGPrefixedStates.contains(lastNumberlist.get(0).Name)){
                            
                            groupNumberLocal = currentStatePrefix ==  null ? String.valueOf(i) : currentStatePrefix + (String.valueOf(i)).leftPad(staticVariableClass.CreateGroupNumberDigits,'0') ;
                            isError =   (lastNumberlist.get(0).Max_Value__c - lastNumberlist.get(0).Last_Number_Used__c) <= lastNumberlist.get(0).Warning_Value__c 
                                &&
                                lastNumberlist.get(0).Max_Value__c != lastNumberlist.get(0).Last_Number_Used__c
                                ? 
                                'LGPrefixedStates' : 'No'; }
                        else if(Label.LGNEStates.contains(lastNumberlist.get(0).Name)){
                            
                            groupNumberLocal = stateAbbreviation ==  null ? String.valueOf(i) : stateAbbreviation + (String.valueOf(i)).leftPad(staticVariableClass.CreateGroupNumberDigits,'0') ;
                            isError =   (lastNumberlist.get(0).Max_Value__c - lastNumberlist.get(0).Last_Number_Used__c) <= lastNumberlist.get(0).Warning_Value__c 
                                &&
                                lastNumberlist.get(0).Max_Value__c != lastNumberlist.get(0).Last_Number_Used__c
                                ? 
                                'LGNEStates' : 'No';
                        }
                        
                        else if(!(Label.LGPrefixedStates.contains(lastNumberlist.get(0).Name) || Label.LGNEStates.contains(lastNumberlist.get(0).Name))){
                            groupNumberLocal = stateAbbreviation ==  null ? String.valueOf(i) : stateAbbreviation + String.valueOf(i) ;
                        }
                        
                        
                        if(omniScriptCall){
                            //Set the value to the map
                            requestGroupNumberStepMap.put(staticVariableClass.CreateGrpGROUPNUMBER, groupNumberLocal);
                            requestGroupNumberStepMap.put(staticVariableClass.CreateGrpWARNINGFLAG, isError);
                        }
                        else{
                            //Set the value to the map
                            requestGroupNumberStepMap.put(GROUPNUMBER, String.valueOf(i));
                            requestGroupNumberStepMap.put(staticVariableClass.CreateGrpWARNINGFLAG, isError);
                        }
                        
                        //put the above map to OutMap used by Omni-script
                        outMap.put(REQUESTGROUPNUMBERSTEP, requestGroupNumberStepMap);
                        break;
                    }
                }
            }
            else{
                //Below statements are for Error handling
                outMap.put(staticVariableClass.CreateGrpSTATUSCODE, staticVariableClass.CreateGrpFAILURE);
                outMap.put(staticVariableClass.CreateGrpERROR, staticVariableClass.CreateGrpNOSTATERECORD);
            }
        }
        return inputMap;
    }
    
    global void updateNextNumberUtility(Map<String, Object> inputMap, Map<String,Object> outMap){
        try{
            ID accountID = (ID)inputMap.get(staticVariableClass.CreateGrpACCTID);
            String accountSitusStatus;
            String generatedGroupNumber, inputGeneratedGroupNumber;
            
            Map<String, Object> requestGroupNumberStepMap = (Map<String, Object>) inputMap.get(staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP);
            generatedGroupNumber = String.valueOf(requestGroupNumberStepMap.get(staticVariableClass.CreateGrpGROUPNUMBER));
            
            //Query Situs status value from acount using the account ID fetched from inputMap.
            List<Account> accountList = [select Situs_State__c from Account where ID =: accountID];
            if(accountList.size() > 0){
                accountSitusStatus = accountList.get(0).Situs_State__c;
                if(accountSitusStatus != null){
                    //Query the Next Number utility record using Situs status.
                    List<Next_Number_Utility__c> lastNumberlist = [select Last_Number_Used__c,Current_State_Prefix__c  from Next_Number_Utility__c 
                                                                    where Name =: accountSitusStatus limit 1];
                    
                    //Fetching Situs state's abbreviation from custom meta data types and putting it into a set //PRDCRM-21257 
                    Set<String> exceptionalStateAbbreviationSet = new Set<String>();
                    for(Situs_State_Mapping__mdt s : [select DeveloperName from Situs_State_Mapping__mdt]){
                        exceptionalStateAbbreviationSet.add(S.DeveloperName);
                        exceptionalStateAbbreviationSet.add(staticVariableClass.CreateGroupNumberNH);}
                    
                    if(!lastNumberlist.isEmpty() && lastNumberlist.size() > 0){
                        Map<String,Object> inputGeneratedGroupNumberMap = getGroupNumber(inputMap, outMap, false);
                        Map<String, Object> inputRequestGroupNumberStepMap = (map<String, Object>)inputGeneratedGroupNumberMap.get(staticVariableClass.CreateGrpREQUESTGROUPNUMBERSTEP);
                        inputGeneratedGroupNumber = String.valueOf(inputRequestGroupNumberStepMap.get(staticVariableClass.CreateGrpGROUPNUMBER));
                        
                        if(inputGeneratedGroupNumber == generatedGroupNumber || exceptionalStateAbbreviationSet.contains(accountSitusStatus)){
                            if(exceptionalStateAbbreviationSet.contains(accountSitusStatus) && generatedGroupNumber.contains(inputGeneratedGroupNumber)){
                                //Set the GeneratedGroupNumber to the Last Number Used, if User input contains system generated for exceptional states
                                lastNumberlist.get(0).Last_Number_Used__c = Integer.valueOf(inputGeneratedGroupNumber);}
                            else if(inputGeneratedGroupNumber == generatedGroupNumber){
                                //Set the GeneratedGroupNumber to the Last Number Used, if User input and system generated are equal.
                                lastNumberlist.get(0).Last_Number_Used__c = Integer.valueOf(inputGeneratedGroupNumber);}
                            
                            // Update Current_State_Prefix__c with updated Prefix
                            lastNumberlist.get(0).Current_State_Prefix__c = abbreviation == '' ? lastNumberlist.get(0).Current_State_Prefix__c : abbreviation  ;
                            if(!lastNumberlist.isEmpty()){
                                update lastNumberlist;
                           }
                            outMap.put(staticVariableClass.CreateGrpSTATUSCODE,staticVariableClass.CreateGrpSUCCESS);
                        }
                    }
                }
            }
        }
        //Below exception statements are for error handling
        catch(Exception excn){
            outMap.put(staticVariableClass.CreateGrpSTATUSCODE, staticVariableClass.CreateGrpFAILURE);
            outMap.put(staticVariableClass.CreateGrpERROR, excn.getMessage()); 
        }
    }
}