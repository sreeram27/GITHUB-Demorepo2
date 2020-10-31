/**
@author : Ravideep (XMEN)
@createdDate 03/06/2020
@description This is the server side class for metricFilter lightning web component
*/
public with sharing class CatalogController {
    static Integer PAGE_SIZE = Integer.valueOf(system.label.MetricListPageSize);
    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] pgtypes { get; set; }
        @AuraEnabled
        public String[] contractcategories { get; set; }
        @AuraEnabled
        public String[] performancecategories { get; set; }
    }
   
    @AuraEnabled(cacheable=true)
    public static PagedResult getPGCatalogItems(Filters filters, Integer pageNumber) {
        String key, whereClause = '';
        String[] pgtypes, contractcategories, performancecategories, criteria = new List<String>{};
        system.debug('filters--->' + filters);
        
        if (filters != null) {
            pgtypes = filters.pgtypes;
            contractcategories = filters.contractcategories;
            performancecategories = filters.performancecategories;
            if (!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';
                criteria.add('(Performance_Category__c LIKE :key OR Broad_Contract_Category__c LIKE :key)');
            }
            
            if (filters.pgtypes != null && !filters.pgtypes.isEmpty()) {
                pgtypes = filters.pgtypes;
                criteria.add('PG_Type__c IN :pgtypes');
            }
            if (filters.performancecategories != null && !filters.performancecategories.isEmpty()) {
                performancecategories = filters.performancecategories;
                criteria.add('Performance_Category__c IN :performancecategories');
            }
            if (filters.contractcategories != null && !filters.contractcategories.isEmpty()) {
                contractcategories = filters.contractcategories;
                criteria.add('Broad_Contract_Category__c IN :contractcategories');
            }
            if (criteria.size() > 0) {
                system.debug('criteria--> ' + criteria);
                whereClause = 'AND ' + String.join(criteria, ' AND ');
            }
        }
        Integer pageSize = CatalogController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        system.debug('whereClause--> ' + whereClause);
        
        try{
        result.totalItemCount = Database.countQuery(
            'SELECT count() FROM PG_Catalog_Item__c WHERE active__c = true ' + whereClause  
        );
        } 
        catch(Exception e) {
             System.debug('Exception caught: ' + e.getMessage()); 
        }
        
        
        try{
        result.records = Database.query(
            'SELECT Id,active__c , Name, PG_Type__c, Performance_Category__c,Broad_Contract_Category__c FROM PG_Catalog_Item__c WHERE active__c = true ' +
            whereClause + 
            ' WITH SECURITY_ENFORCED' +
            ' ORDER BY sequence__c LIMIT :pageSize OFFSET :offset'
        );
        } 
        catch(Exception e) {
             System.debug('Exception caught: ' + e.getMessage()); 
        }
        system.debug('result.records--->' + result.records);
        return result;
    }
}