public class LGRateRequest {
    public String groupName{ get; set; }    //Rosetta CO
    public String requestedBy{ get; set; }  //SFDC_User_Name
    public String effectiveDate{ get; set; }    //2019-01-01
    public String environment{ get; set; }  //DEV
    public String sfOpportunityId{ get; set; }  //0061K00000d20WsQAI
    public String sourceSystem{ get; set; } //ABACUS
    public String customerMasterKey{ get; set; }    //E&B Customer Master Id
    public String caseNumber{ get; set; }   //123456
    public String sourceRecordId{ get; set; }   //SourceRecordIdentifier
    public String sfOpportunityType{ get; set; }    //New Business
    public List<rateInfo> rateInfo{ get; set; }
    
    public class rateInfo {
        public String sfdcQuoteLineItemId;	//18CHARALPHANUMERIC
        public String rateIdentifier;	//RATE_ID_1
        public String contractCode;	//3XYY
        public String classCode;	//Hourly
        public String employmentCategoryCode;	//ACTSB
        public String productCategory;	//MEDICAL
        public String productName;	//Blue Advantage HMO
        public String commissionLevel;	//10
        public String commissionType;	//PSPM
        public Double single;	//703.2
        public Double twoParty;	//1547.04
        public Double eeChild;	//1265.76
        public Double family;	//2179.92
        public Double eeChildren;	//1265.76
        public Double medicareElgSpouseL65;	//703.2
        public Double medicareElgSpouseChildL65;	//1476.72
        public Double embeddedVisionPSPM;	//1.6
    }
    public static LGRateRequest parse(String json){
        return (LGRateRequest) System.JSON.deserialize(json, LGRateRequest.class);
    }
    
}