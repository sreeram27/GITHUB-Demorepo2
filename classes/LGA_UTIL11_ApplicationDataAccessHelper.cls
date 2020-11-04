/*****************************************************************************************
Class Name   : LGA_UTIL11_ApplicationDataAccessHelper
Date Created : 14/06/2019
Created By   : IDC Offshore
Description  : 1. This is the util data access class for vlocity_ins__Application__c object.
Which is used to fetch the details from vlocity_ins__Application__c based 
on some parameters
**************************************************************/
public class LGA_UTIL11_ApplicationDataAccessHelper {
/****************************************************************************************************
Method Name : fetchApplicationMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,vlocity_ins__Application__c>
Description : This method is used to fetch the vlocity_ins__Application__c record based on 
parameters passed.
It will return the Map<ID,vlocity_ins__Application__c> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of accounts.
******************************************************************************************************/
public static Map<ID,vlocity_ins__Application__c> fetchApplicationMap
(String selectQuery,String whereClause,String orderByClause,String limitClause)
{
String dynaQuery = LGA_Constants.BLANK;
Map<ID,vlocity_ins__Application__c> applicationMap = NULL;
dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : LGA_Constants.BLANK;
dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;

// System.debug('dynaQuery>>'+dynaQuery);
if(String.isNotBlank(dynaQuery))
{
//System.debug('dynaQuery in SGA_Util03_ApplicationDataAccessHelper::>'+dynaQuery);
applicationMap = new Map<ID,vlocity_ins__Application__c>((List<vlocity_ins__Application__c>)Database.query(dynaQuery));
}

//System.debug('applicationMap in SGA_Util03_ApplicationDataAccessHelper::>'+applicationMap);  

return applicationMap;
} 

}