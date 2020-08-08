public class ContCodeReserveResponse {
    public String transactionId;
	public String transactionTimestamp;
    public String callingSystem;
	public Status status;
	public Input input;
	public String contractCode;

	public class Status {
		public String code;
		public String message;
	}

	public class Input {
		public String baseContract;
		public String modifiedByP2A;
		public String hpcc;
		public String fundingType;
		public String state;
		public String groupSize;
	}

	public static ContCodeReserveResponse parse(String json) {
		return (ContCodeReserveResponse) System.JSON.deserialize(json, ContCodeReserveResponse.class);
	}
}