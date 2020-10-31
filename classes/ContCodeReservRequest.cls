public class ContCodeReservRequest {

	public String baseContract;
	public String planModifiedInd;
	public String actwiseIndicator;
	public String engageIndicators;
	public String hpcc;
	public String fundingTypeCode;
	public String stateCode;
	public String quoteLineItem;
	public String effectiveDate;
	public String groupSize;
    public String lob;
    public String implRecordId;
    public String wgsGroupName;
    public String groupType;
    public String wgsGroupMigrationDate;
    public String hcrStatus;
	public String baseContractType;
	public String cepIndicator;
	public String performanceGuarantee;
	public String wgsCaseId;
	public String wgsGroupId;
    public String poolingStatus;
    public String callingSystem;
	public String transactionId;
	public String transactionTimestamp;
    public riders[] riders;
    
    public class riders{
        public String name;
        public String riderId;
    }
	
	public static ContCodeReservRequest parse(String json) {
		return (ContCodeReservRequest) System.JSON.deserialize(json, ContCodeReservRequest.class);
	}
}