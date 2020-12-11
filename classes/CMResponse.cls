/*
* @Author : Legato Health Technologies LLP
* @Date   : 26 - November - 2019
*/

public class CMResponse{
    public cls_eventMetaData eventMetaData;
    public cls_responseMsg[] responseMsg;
    public class cls_eventMetaData {
        public String userId;
        public String sourceSystemId;
        public String trackingId;
        public String eventType;
        public String masterId;
        public String subTrackingId;
    }
    public class cls_responseMsg {
        public String globalCustomerId;
        public String accountID;
        public String statusCode;
        public String statusMsg;
        public String SystemID;
        public cls_responseDetails responseDetails;
    }
    public class cls_responseDetails {
        public cls_listOfErrorCodes[] listOfErrorCodes;
        public cls_AccountInfo accountInfo;
        //public cls_customerInfo customerInfo;
    }
    public class cls_listOfErrorCodes {
        public String category; 
        public String errorCode;
        public String bindingField;
        public String entityName;
        public String errorMessage;
    }
    public class cls_AccountInfo {
        public cls_customerInfo customerInfo;
        public cls_AccountBillGroups[] accountBillGroups;
    }
    public class cls_customerInfo {
        public cls_customer[] customers;
    }
    public class cls_customer {
        public cls_ids[] ids;
        public cls_demographic demographic;
        public cls_status status;
        public cls_subGroups[] subGroups;
        public cls_miscellaneousInfo miscellaneousInfo;
    }
    public class cls_demographic{
        public cls_organizationName organizationName;
    }
    public class cls_organizationName{
        public String name;
        public String dbaName;
    }
    public class cls_status{
        public cls_timeline[] timeline;
    }
    public class cls_timeline{
        public String status;
        public String effectiveDate;
        public String endDate;
        public cls_reasons[] reasons;
    }
    public class cls_subGroups{
        public String TargetSystem;
        public String TargetSystemId;
        public String groupNumber;
        public String sfgroupNumber;
        public String groupName;
        public String employmentCategoryCode;
        public String employmentClass;
        public String contractCode;
        public String productType;
        public String productNumber;
        public String memberProductCode;
        public String groupSuffixId;
        public String billGroupId; // This is not part of JSON but will be populated part of code
        
    }
    public class cls_miscellaneousInfo{
        public cls_idcards idcards;
    }
    public class cls_idcards{
        public String triggereddate;
    }
    public class cls_reasons
    {
        public String code;
        public String description;
    }
    public class cls_ids {
        public String sourceSystem;
        public String name;
        public String value;
    }
    public class cls_AccountBillGroups {
        public cls_ids[] ids;
        public cls_demographic demographic;
        public cls_billConfig billConfig;
    }
    public class cls_billConfig{
        public cls_billArrangements[] billArrangements;
        public cls_billLevelParameters[] billLevelParameters;
        public cls_billDates billDates;
    }
    public class cls_billArrangements{
        public String customerId;
        public String productType;
        public String contractCode;
        public String employmentCategory;
        public String employmentClass;
    }
    public class cls_billLevelParameters{
        public String sourceSystem;
        public String sequence;
        public String billLevel1;
        public String billLevel2;
        public String billLevel3;
        public String billLevel4;
        public String billGroupId;
        public String effectiveDate;
        public String expirationDate;
        public String contractCD;
        public String productName;
        public String productType;
    }
    public class cls_billDates{
        public String paidToDate;
        public String billToDate;
    }
    
    public static CMResponse parse(String json){
        return (CMResponse) System.JSON.deserialize(json, CMResponse.class);
    }
}