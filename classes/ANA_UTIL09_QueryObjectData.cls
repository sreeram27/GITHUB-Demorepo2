/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL09_QueryObjectData
@CreateDate : 11-07-2017
@Description : This class queries object data.
*/
public with sharing class ANA_UTIL09_QueryObjectData{       
    public static set<Id> idSet1;
    public static set<Id> iGapopptidsall;
    public static set<string> stringSet1;
    private static final string COMMA=',';
    private static final String EMPTY='';
    private static final String QRYSELECT = 'SELECT ';
    private static final String QRYFROM = ' FROM ';
    private static final string QRYWHERE = ' WHERE ';
    private static final String QRYLIMIT = ' LIMIT 2000';
    /*This method is used to prepare the desired query string by passing the objectname and where clause condition*/
    public static List<sObject> getObjectData(String sobjName, string fieldNameStr,string whereclause){
        Map<String, Schema.SObjectField> fieldsMap = Schema.getGlobalDescribe().get(sobjName.toLowerCase()).getDescribe().Fields.getMap();
        String fields = EMPTY;
        List<Sobject> objList = new List<Sobject>();
        for(Schema.SObjectField sf : fieldsMap.values()) {
            Schema.DescribeFieldResult fldr = sf.getDescribe();
            if(fldr.isCreateable()){
                fields += fldr.getName()+COMMA;
            }
        }
        if(fieldNameStr != null){
          fields = fields+fieldNameStr;
        }
        else if(fields.endsWith(COMMA)){
           fields = fields.substring(0,fields.lastIndexOf(COMMA));
        }
        if(whereclause!=null && whereclause != EMPTY){
            String qryString = QRYSELECT+fields+QRYFROM+sobjName+QRYWHERE+whereclause+QRYLIMIT;
            objList = database.query(qryString );            
        }
        return objList;
    }
}