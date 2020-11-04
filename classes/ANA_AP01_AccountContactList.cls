/**
@Author : Accenture Offshore Dev team
@name : ANA_AP01AccountContactList
@CreateDate :05-05-2017
@Description : This class will return the contacts related to a account which is used in omniscript.
*/
global with sharing class ANA_AP01_AccountContactList implements vlocity_ins.VlocityOpenInterface{  
    public static final String POPULATEPICKLIST='PopulatePicklist';
    public static final String NAME='name';
    public static final String VALUE='value';
    public static final String OPTIONS='options';
    public static final String CONTEXTID='ContextId';
    public static final String CLASSNAME = ANA_AP01_AccountContactList.class.getName();
    public static final String SELECTCON='select id,name from contact where accountid=:accId limit 1000';
    /**
*  This method is an implementation to  vlocity_ins.VlocityOpenInterface interface.
*  @name :invokeMethod
*  @param : String,Map<String,Object>,Map<String,Object>,Map<String,Object> .
*  @return <parameter> - Boolean
*/
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap,
                                Map<String,Object> optns) {                                    
                                    if(POPULATEPICKLIST.equalsIgnoreCase(methodName)){
                                        populatePicklist(inputMap, outMap, optns);
                                    }
                                    return true;
                                }
    /**
*  This method will get the AccountId from the record that the omniscript gets invoked and prepares the contact list.
*  @name :invokeMethod
*  @param : String,Map<String,Object>,Map<String,Object>,Map<String,Object> .
*  @return <parameter> - Boolean
*/
    public void populatePicklist(Map<String,Object> input, Map<String, Object> outMap, Map<String, Object> optns)
    {
        try
        {
            List<Map<String,String>> options1=new List<Map<String,String>>();            
            string rec=(string)input.get(CONTEXTID);           
            Map<String,String> tempMap;
            Id accId = Id.valueOf(rec);
            ANA_UTIL08_AccessContactDataUtil.accId=accId;
            List<Contact> conList=ANA_UTIL08_AccessContactDataUtil.queryContacts(SELECTCON);
            for(Contact c:conList)
            {
                tempMap=new Map<String,String>();
                tempMap.put(NAME,c.id);
                tempMap.put(VALUE,c.Name);
                options1.add(tempMap);
            }
            outMap.put(OPTIONS,options1); 
        }
        catch(Exception qExcp)
        {
            UTIL_LoggingService.logHandledException(qExcp, ANA_UTIL03_Constants.ORGID, ANA_UTIL03_Constants.APPNAME, CLASSNAME, POPULATEPICKLIST,null,LoggingLevel.ERROR); 
        }
        
    }
}