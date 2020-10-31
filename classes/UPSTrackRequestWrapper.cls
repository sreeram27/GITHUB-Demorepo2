public class UPSTrackRequestWrapper{
    public cls_UPSSecurity UPSSecurity;
    public cls_TrackRequest TrackRequest;
    public class cls_UPSSecurity {
        public cls_UsernameToken UsernameToken;
        public cls_ServiceAccessToken ServiceAccessToken;
    }
    public class cls_UsernameToken {
        public String Username; //Your Username
        public String Password; //Your Password
    }
    public class cls_ServiceAccessToken {
        public String AccessLicenseNumber;  //Your Access License Number
    }
    public class cls_TrackRequest {
        public cls_Request Request;
        public String InquiryNumber;    //YourTrackingNumber
        public String TrackingOption;
    }
    public class cls_Request {
        public String RequestOption;    //1
        public cls_TransactionReference TransactionReference;
    }
    public class cls_TransactionReference {
        public String CustomerContext;  //Your Test Case Summary Description
    }
    
    public static String buildTrackRequest(String trackingNumber, String description, String requestOption){
        UPSTrackRequestWrapper trw = new UPSTrackRequestWrapper();
        
        trw.UPSSecurity = new cls_UPSSecurity();
        trw.UPSSecurity.UsernameToken = new cls_UsernameToken();
        trw.UPSSecurity.UsernameToken.Username = UPS_Constants.UPS_USERNAME;
        trw.UPSSecurity.UsernameToken.Password = UPS_Constants.UPS_PASSWORD;
        trw.UPSSecurity.ServiceAccessToken = new cls_ServiceAccessToken();
        trw.UPSSecurity.ServiceAccessToken.AccessLicenseNumber = UPS_Constants.UPS_ACCESS_KEY;
        
        trw.TrackRequest = new cls_TrackRequest();
        trw.TrackRequest.InquiryNumber = trackingNumber;
        
        trw.TrackRequest.Request = new cls_Request();
        trw.TrackRequest.Request.RequestOption = requestOption;
        trw.TrackRequest.Request.TransactionReference = new cls_TransactionReference();
        trw.TrackRequest.Request.TransactionReference.CustomerContext = description;
        
        return JSON.serialize(trw);
        
    }
    
    public static UPSTrackRequestWrapper parse(String json){
        return (UPSTrackRequestWrapper) System.JSON.deserialize(json, UPSTrackRequestWrapper.class);
    }
    


}