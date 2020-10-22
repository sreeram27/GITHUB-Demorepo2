/**
* @author Deloitte
* @date 21st Aug 2019
* @description This is a wraper class which eventually maintains the bridge between Vlocity Omniscript and ContCodeReservService.
*/
global with sharing class LG_ContCodeReservServiceWrapper implements vlocity_ins.VlocityOpenInterface2{
    
    /**
        @description implementation of invokeMEthod from VlocityOpenInterface2 interface.
        @param a String which will contain the method name to be invoked from omniscript.
        @param a Map<String,Object> which will carry the data into "invokeMethod" method of this class from omniScript.
        @param a Map<String,Object> which will carry the data form this apex class to the vlocity output screen.
        @param a Map<String,Object> which is optional.
        @return this method will return a boolean value, which will be true or false.
    */
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> optns){
        contractCodeReserveServiceCallWrapper(inputMap, outMap, true);   
        return true;
    }
    
    /**
        @description this method is being called from "invokeMethod" only.
        @param a Map<String,Object> which will get the data from "invokeMethod" method of this class.
        @param a Map<String,Object> which will get the data form "invokeMethod" method of this class and containes the output for vlocity screen.
        @param a boolean parameter which is used to identify that it's a omniScriptCall or not.
        @returnt this method don't return anything.
    */
    global static void contractCodeReserveServiceCallWrapper(Map<String, Object> inputMap, Map<String,Object> outMap, Boolean omniScriptCall){
        ID orderId = (ID)inputMap.get(staticVariableClass.CreateGrpQUOTEID);
        List<ContCodeReserveResponse> responseStatus = ContCodeReservService.contractCodeReserveServiceCalloutImpl(orderId);
        List<List<String>> responseList = new List<List<String>>();
        if(!responseStatus.isEmpty()){
            for(Integer i = 0; i < responseStatus.size(); i++){
                responseList.add(new List<String>{responseStatus.get(i).Status.code, responseStatus.get(i).Status.message});
            }
            outMap.put('SoldProduct', responseList);
        }
    }
}