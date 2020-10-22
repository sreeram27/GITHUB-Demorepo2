/**
@Author : Accenture Offshore Dev team
@name : AP20_Intakereturnreasoncount
@Description :This class creates 'SME Revision Approval' records based on 'Manually-ENgaged' departments.
*/
global without sharing class AP20_Intakereturnreasoncount implements vlocity_ins.VlocityOpenInterface2  {
     
       
    /*Implementation of invokeMEthod from VlocityOpenInterface2 interface.*/
    global static Boolean invokeMethod(String methodName,Map<String,Object> inputMap,
                                        Map<String,Object> outMap,Map<String,Object> optns)
    {                                                                        
        Integer count =0;
    if(UtilConstants.REASON_COUNT.equalsIgnoreCase(methodName))
    {
       if((inputMap.get(UtilConstants.ADDRETURN)) !=null )
       {
       List<Object> addIntakeReturn = new List<Object>{inputMap.get(UtilConstants.ADDRETURN)}; 
         
        Map<string,Object> addIntakeReturnMap;    
       for (Object tempObj : addIntakeReturn)
       {
         addIntakeReturnMap = (Map<String,Object>) tempObj;                              
       } 
       System.debug(addIntakeReturnMap.get(UtilConstants.RC));
      // List<Object> addIntakeReturn = new List<Object>{inputMap.get(UtilConstants.ADDRETURN)};    
       System.debug(addIntakeReturnMap);
       System.debug(addIntakeReturnMap.get(UtilConstants.RC));
       if(addIntakeReturnMap.get(UtilConstants.RC) == 1)
       {
             Map<String,Object> engageDeptMapfinal1 = (Map<String,Object>) addIntakeReturnMap.get(UtilConstants.ADDINRETURN);
             System.debug(engageDeptMapfinal1.get(UtilConstants.IMPREASONS));
            if(engageDeptMapfinal1.get(UtilConstants.IMPREASONS) == null)          
            {
                count = count + 1;                        
            }       
       }
       else{
        List<Object> engageDeptMap = (List<Object>) addIntakeReturnMap.get(UtilConstants.ADDINRETURN);    
        System.debug(addIntakeReturnMap.get(UtilConstants.ADDINRETURN));
       for(Object tempEngage : engageDeptMap)
       {
         Map<String,Object> engageDeptMapfinal = (Map<String,Object>) tempEngage;                    
         if(engageDeptMapfinal.get(UtilConstants.IMPREASONS) == null)          
         {
                count = count + 1;                        
         }                    
        } 
        }  
        outmap.put('NullCount',count);                                      
    }
    }
    return true; 
    }
}