public class UPSTrackResponseWrapper{
    public cls_TrackResponse TrackResponse;
    public class cls_TrackResponse {
        public cls_Response Response;
        public cls_Shipment Shipment;
    }
    public class cls_Response {
        public cls_ResponseStatus ResponseStatus;
        public cls_TransactionReference TransactionReference;
    }
    public class cls_ResponseStatus {
        public String Code; //1
        public String Description;  //Success
    }
    public class cls_TransactionReference {
        public String CustomerContext;  //Test Case Summary Description
    }
    public class cls_Shipment {
        public cls_InquiryNumber InquiryNumber;
        public String ShipperNumber;    //A692F7
        public cls_ShipmentAddress ShipmentAddress;
        public cls_ShipmentAddress[] ShipmentAddress_Arr;
        public cls_ShipmentWeight ShipmentWeight;
        public cls_Service Service;
        public cls_ReferenceNumber ReferenceNumber;
        public cls_ReferenceNumber[] ReferenceNumber_Arr;
        public String PickupDate;   //20170227
        public cls_Package[] Package_Arr;
        public cls_Package Package_x;
    }
    public class cls_InquiryNumber {
        public String Code; //01
        public String Description;  //ShipmentIdentificationNumber
        public String Value;    //1ZA692F70196635379
    }
    public class cls_ShipmentAddress {
        public cls_Type Type;
        public cls_Address Address;
    }
    public class cls_Type {
        public String Code; //04
        public String Description;  //POD Letter
    }
    public class cls_Address {
        public String City; //NASHVILLE
        public String StateProvinceCode;    //TN
        public String PostalCode;   //37214
        public String CountryCode;  //US
    }
    public class cls_ShipmentWeight {
        public cls_UnitOfMeasurement UnitOfMeasurement;
        public String Weight;   //11.00
    }
    public class cls_UnitOfMeasurement {
        public String Code; //LBS
    }
    public class cls_Service {
        public String Code; //001
        public String Description;  //UPS NEXT DAY AIR
    }
    public class cls_ReferenceNumber {
        public String Code; //01
        public String Value;    //AXEGU001
    }
    public class cls_Package {
        public String TrackingNumber;   //1ZA692F70196635379
        public cls_Activity Activity; //[] can be array depending on request option
        //public cls_Activity Activity1;
        public cls_PackageWeight PackageWeight;
        public cls_ReferenceNumber ReferenceNumber;
        public cls_ReferenceNumber[] ReferenceNumber_Arr;
    }
    public class cls_Activity {
        public cls_ActivityLocation ActivityLocation;
        public cls_Status Status;
        public String Date_x; //20170228
        public String Time_x; //100000
        public cls_Document Document;
    }
    public class cls_ActivityLocation {
        public cls_Address Address;
        public String Code; //PF
        public String Description;  //INSIDE DELIV
        public String SignedForByName;  //WARWICK
    }
    public class cls_Status {
        public String Type; //D
        public String Description;  //Delivered
        public String Code; //KB
    }
    public class cls_Document {
        public cls_Type Type;
        public String Content;  
        public cls_Format Format;
    }
    public class cls_Format {
        public String Code; //03
        public String Description;  //HTML
    }
    public class cls_PackageWeight {
        public cls_UnitOfMeasurement UnitOfMeasurement;
        public String Weight;   //11.00
    }
    public static UPSTrackResponseWrapper parse(String json){
        return (UPSTrackResponseWrapper) System.JSON.deserialize(json, UPSTrackResponseWrapper.class);
    }

}