/*****************************************************************************************
Class Name   : LGA_Util16_OrderDataAccessHelper
Date Created : 4/8/2019
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Oder(Implementation Case) object.
Which is used to fetch the details from Oder(Implementation Case) based 
on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/

public with sharing class LGA_Util16_OrderDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static Set<Id> OrderIdSet;
    
    /****************************************************************************************************
Method Name : fetchApplicationMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Order>
Description : This method is used to fetch the Order record based on 
parameters passed.
It will return the Map<ID,Order> if user wants the Map, 
they can perform the logic on Map, else they can covert the map to list of accounts.
******************************************************************************************************/
    
     public static Map<ID,Order> fetchOrderMap
        (String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        String dynaQuery = LGA_Constants.BLANK;
        Map<ID,Order> IMPcaseMap = NULL;
        dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : LGA_Constants.BLANK;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
        dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
        
       // System.debug('dynaQuery>>'+dynaQuery);
        if(String.isNotBlank(dynaQuery))
        {
            //System.debug('dynaQuery in LGA_Util16_OrderDataAccessHelper::>'+dynaQuery);
            IMPcaseMap = new Map<ID,Order>((List<Order>)Database.query(dynaQuery));
        }
        
        //System.debug('applicationMap in LGA_Util16_OrderDataAccessHelper::>'+IMPcaseMap);  
        
        return IMPcaseMap;
    } 
    

}