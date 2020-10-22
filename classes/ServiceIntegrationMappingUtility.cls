public class ServiceIntegrationMappingUtility {

    static Map<String, String> fieldValueMapping = new Map<String, String>();
    
    static{
        List<Service_Integration_Field_Mappings__mdt> serviceIntmappingList =[Select Id, Integration_Process__c, SFDC_Field_Name__c,
                                                                              SFDC_Field_Value__c, External_System_Mapping__c
                                                                              FROM Service_Integration_Field_Mappings__mdt
                                                                              WHERE Integration_Process__c != null
                                                                              AND SFDC_Field_Name__c != null
                                                                              AND SFDC_Field_Value__c != null
                                                                              AND External_System_Mapping__c != null];
        if(serviceIntmappingList.size() > 0){
            for(Service_Integration_Field_Mappings__mdt intMap : serviceIntmappingList){
                fieldValueMapping.put(intMap.Integration_Process__c+intMap.SFDC_Field_Name__c+intMap.SFDC_Field_Value__c, intMap.External_System_Mapping__c);
            }
            System.debug('Map Size: '+fieldValueMapping.size());
        }
    }
    
    public static String getExternalSystemValue(String processName, String fieldName, String fieldValue){
    
        String extValue = fieldValueMapping.containsKey(processName+fieldName+fieldValue) ? fieldValueMapping.get(processName+fieldName+fieldValue) : null;
        System.debug('Ext System Value: '+extValue);
        return extValue;
    }
    
  /*  public static String getSFDCSystemValue(String processName, String fieldName, String extSysValue){
        
        String sfdcValue = fieldValueMapping.containsKey(processName+fieldName+extSysValue) ? fieldValueMapping.get(processName+fieldName+extSysValue) : null;
        System.debug('Ext System Value: '+sfdcValue);
        return sfdcValue;
    } */
}