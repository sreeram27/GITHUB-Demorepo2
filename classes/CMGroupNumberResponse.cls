public class CMGroupNumberResponse{
	public cls_responseMsg responseMsg;
	public class cls_responseMsg {
		public String statusCode;	
		public cls_externalNumber[] externalNumber;
		public String globalCustomerNumber;	
		public String customerNumber;	
		public cls_responseDetails responseDetails;
	}
	public class cls_externalNumber {
		public String productType;	
		public String id;	
		public String claimSystem;	//wgs/compass Need to get this attribute renamed from system to claimSystem?? 
	}
	public class cls_responseDetails {
		public cls_listOfErrorCodes[] listOfErrorCodes;
	}
	public class cls_listOfErrorCodes {
		public String category;	
		public String errorCode;	
		public String bindingField; // Need to correct the spelling for bindingField	
		public String entityName;	
		public String errorMessage;	
	}
}