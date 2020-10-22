global class UPS {

    public static TrackingDetails getTracking(String UPS_Tracking_Number) {
        String url = UPS_Constants.UPS_ENDPOINT_URL;
        String opt = '0'; //Get Last Activity only
        
        //Build and send HTTP Request
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody(UPSTrackRequestWrapper.buildTrackRequest(UPS_Tracking_Number,'Test Case Summary Description',opt));
        req.setTimeout(UPS_Constants.UPS_REQUEST_TIMEOUT);
        
        HttpResponse res = h.send(req);
        String resBody = res.getBody();
        
        TrackingDetails td = new TrackingDetails();
        td.fullstatus = resBody;
        td.location = Label.UPS_Default_Error_Message; //should be replaced if a valid a response was retrieved and no error is encountered
        
        try{
            //Parse response, replace reserved names
            String replacedBody = resBody.replace('"Date":', '"Date_x":').replace('"Time":', '"Time_x":').replace('"Package":', '"Package_x":').replace('"Package_x":[', '"Package_Arr":[').replace('"ReferenceNumber":[', '"ReferenceNumber_Arr":[').replace('"ShipmentAddress":[', '"ShipmentAddress_Arr":[');
            //System.debug('replaced body: ' + replacedBody);
            UPSTrackResponseWrapper trw = (UPSTrackResponseWrapper) JSON.deserialize(replacedBody, UPSTrackResponseWrapper.class);
            
            
            if(trw != null && trw.TrackResponse != null)  {
                UPSTrackResponseWrapper.cls_Activity act = null;
                if(trw.TrackResponse.Shipment != null)  {
                    if(trw.TrackResponse.Shipment.Package_x != null) {
                        act = trw.TrackResponse.Shipment.Package_x.Activity;
                    } else if(trw.TrackResponse.Shipment.Package_Arr != null && !trw.TrackResponse.Shipment.Package_Arr.isEmpty()) {
                        for(UPSTrackResponseWrapper.cls_Package pkg : trw.TrackResponse.Shipment.Package_Arr) {
                            if(pkg.TrackingNumber == UPS_Tracking_Number) {
                                act = pkg.Activity;
                                break;
                            }
                        }
                    }
                }      
                if(act != null) {
                    td.status = act.Status != null ? act.Status.Description : null;
                    td.date_x = act.Date_x;
                    td.time_x = act.Time_x;
                    UPSTrackResponseWrapper.cls_ActivityLocation  loc = act.ActivityLocation;
                    td.signedBy = loc != null ? loc.SignedForByName : null;
                    td.leftAt = loc != null ? loc.Description : null;
                    UPSTrackResponseWrapper.cls_Address adrs = loc != null ? loc.Address  : null;
                    td.location = adrs != null ? adrs.City +' ' + adrs.StateProvinceCode +' ' + adrs.PostalCode +' ' + adrs.CountryCode : null;
                }
            }  
        }catch(Exception e){
            String errDetail = e.getMessage() + '\n' + e.getStackTraceString();
            td.fullstatus = errDetail.trim().length() > 131072? errDetail.trim().substring(0, 131072) : errDetail.trim();
        }
        return td;
    }
    
    webservice static void updateStatus(Id[] orderIds) {
        List<Order_Fulfillment__c> orderList = [SELECT Id, Tracking_Number__c, Status__c, Location__c, Left_At__c, Signed_By__c from Order_Fulfillment__c WHERE Id IN :orderIds];
        for(Order_Fulfillment__c order : orderList) {
            order.Location__c = Label.UPS_Default_Error_Message; //should be replaced when a valid response was retrieved from the callout
            try{
                if(Limits.getCallouts() < Limits.getLimitCallouts()) {
                    TrackingDetails td = UPS.getTracking(order.Tracking_Number__c);
                    if(td != null) {
                       order.Status__c = td.Status != null && td.Status != ''?td.status:order.Status__c;
                       if(td.Status != null && ('DELIVERED').equalsIgnoreCase(td.Status)) {
                            Datetime dt = Datetime.newInstance(Integer.valueOf(td.date_x.substring(0,4)), Integer.valueOf(td.date_x.substring(4,6)), Integer.valueOf(td.date_x.substring(6,8)),
                            Integer.valueOf(td.time_x.substring(0,2)), Integer.valueOf(td.time_x.substring(2,4)), Integer.valueOf(td.time_x.substring(4,5)));
                            order.Actual_Delivery_Date__c = dt;    
                        }
                        order.Signed_By__c = td.signedby != null && td.signedby != ''?td.signedby: order.Signed_By__c;
                        order.Location__c = td.location != null && td.location != ''?td.location:order.Location__c;
                        order.Left_At__c = td.leftAt != null && td.leftat!= ''?td.leftat:order.Left_At__c;
                        order.UPS_Full_Status__c = td.fullstatus!= null && td.fullstatus.trim().length() > 131072? td.fullstatus.trim().substring(0, 131072) : td.fullstatus.trim();
                     }
                 } else {
                     order.UPS_Full_Status__c = 'Reached maximum Apex callout limit for transaction';
                 }
             } catch (Exception e) {
                String errDetail = e.getMessage() + '\n' + e.getStackTraceString();
                order.UPS_Full_Status__c= errDetail.trim().length() > 131072? errDetail.trim().substring(0, 131072) : errDetail.trim();
                System.debug('Entered updating UPS Full status exception'+errDetail );
            }
        }
        
        update orderList;
    }
   
    public class TrackingDetails {
        String status;
        String date_x;
        String time_x;
        String signedBy;
        String leftAt;
        String location;
        String fullstatus;
    }
}