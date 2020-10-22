/*
@Author : Accenture Offshore Dev team
@name : ANA_UTIL06_AccessQLIADataUtil
@CreateDate :25-05-2017
@Description : This class queries the Approval related objects records.
*/
public with sharing class ANA_UTIL06_AccessQLIADataUtil {
    public static Id targetId;
    public static Id procInstId;
    /*Method to query process instance records*/
    public static ProcessInstance[] queryProcInst(string queryProcInst){
        string queryStr = queryProcInst;
        List<ProcessInstance> piLst; 
        piLst = Database.query(queryStr);
        return piLst;        
    }
    /*Method to query process instance step records*/
    public static ProcessInstanceStep[] queryProcInstStep(string queryProcInst){
        string queryStr = queryProcInst;
        List<ProcessInstanceStep> piLst; 
        piLst = Database.query(queryStr);
        return piLst;        
    }
}