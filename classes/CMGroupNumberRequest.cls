public class CMGroupNumberRequest{
	public cls_eventMetaData eventMetaData;
	public cls_customerInfo customerInfo;
	public class cls_eventMetaData {
		public String userId;	
		public String sourceSystemId;	
		public String trackingId;	
		public String eventType;	
		public String masterId;	
		public String subTrackingId;	
	}
	public class cls_customerInfo {
		public String accountId;	
		public String customerName;	
		public String state;	
		public String[] productTypes;
		public String marketSegment;	
		public String requestedWgsCaseId;	
		public String existingCaseId;	
		public String existingSchemeId;	
	}
}