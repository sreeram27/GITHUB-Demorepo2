/*
    Name               :    LGP2AJSON 
    Description        :    Apex Class generated based on JSON Structure and methods to deserialize and serialize
    Created By         :    Arun Siddappa
*/
public class LGP2AJSON {
  public String GroupName;
  public String GroupNumber;
  public String GroupSize;
  public String sfdcAccountId;
  public Integer totalNoOfUnionWorkers;
  public String RequestedBy;
  public String SFDCQuoteId;
  public String ENVIRONMENT;
  public String Action;
  public List<QuoteLineItems> QuoteLineItems;
  //-GLD-PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
  public List<ParentQli> listParentQli;

  public class QuoteLineItems {
    public String SFDCQuoteLineItemId;
    public String GroupIdentifier;
    public String GroupSize;
    public String OpportunityEffectiveDate;
    public String ImplementationRecordStatus;
    public String QuoteLineItemStage;
    public String ProductContractCode;
    public String CyPyAdministrativeType;
    public String FundingType;
    public String hpccCode;
    //PRDCRM-50634 -GLD - 201.2 - added 2 new parameters for Modify
    public String sStateRegulator;
    public String sHcrStatus;  
  }
   //-GLD-PRDCRM-51890 - Send parameters to P2A on Create CEP Case Button from QLI
   public class ParentQli {
        public String sParentQliId;
        public String sProductName;
        public String sProductType;
        public String sProductState;
        public List<QuoteLineItems> listChildQuoteLineItems;
    }

  
  public static LGP2AJSON parse(String json) {
    return (LGP2AJSON) System.JSON.deserialize(json, LGP2AJSON.class);
  }
    public static String parse(LGP2AJSON jsonObj) {
        return System.JSON.serializePretty(jsonObj, true);
    }
}