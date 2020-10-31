@isTest 
private class UPSTrackResponseWrapper_Test {
    
    @istest static void testParseResponse() {
        String res = '{"TrackResponse":{"Response":{"ResponseStatus":{"Code":"1", "Description":"Success"}, ' + 
            '"TransactionReference":{"CustomerContext":"Test Case Summary Description"}}, ' + 
            '"Shipment":{"InquiryNumber":{"Code":"01", "Description":"ShipmentIdentificationNumber", ' + 
            '"Value":"1ZA692F70196635379"}, "ShipperNumber":"A692F7", "ShipmentAddress_Arr":[{"Type":{"Code":"01", ' + 
            '"Description":"Shipper Address"}, "Address":{"AddressLine":"5221 N O CONNOR BLVD", "City":"IRVING", ' + 
            '"StateProvinceCode":"TX", "PostalCode":"75039   4422", "CountryCode":"US"}}, {"Type":{"Code":"02", ' + 
            '"Description":"ShipTo Address"}, "Address":{"City":"NASHVILLE", "StateProvinceCode":"TN", "PostalCode":"37214", ' + 
            '"CountryCode":"US"}}], "ShipmentWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"11.00"}, ' + 
            '"Service":{"Code":"001", "Description":"UPS NEXT DAY AIR"}, "ReferenceNumber_Arr":[{"Code":"01", "Value":"AXEGU001"}, ' + 
            '{"Code":"01", "Value":"JOSHUA.SNYDER"}], "PickupDate":"20170227", "Package":{"TrackingNumber":"1ZA692F70196635379", ' + 
            '"Activity":{"ActivityLocation":{"Address":{"City":"NASHVILLE", "StateProvinceCode":"TN", "PostalCode":"37214", ' + 
            '"CountryCode":"US"}, "Code":"PF", "Description":"INSIDE DELIV", "SignedForByName":"WARWICK"}, ' + 
            '"Status":{"Type":"D", "Description":"DELIVERED", "Code":"KB"}, "Date":"20170228", "Time":"100000"}, ' + 
            '"PackageWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"11.00"}, "ReferenceNumber_Arr":[{"Code":"01", "Value":"AXEGU001"}, ' + 
            '{"Code":"01", "Value":"JOSHUA.SNYDER"}]}}}}';
       
       UPSTrackResponseWrapper rw = null;
       Test.startTest();
           rw = UPSTrackResponseWrapper.parse(res);
       Test.stopTest();
       
       System.assert(rw != null && rw.TrackResponse != null);
       System.assertEquals('Success', rw.TrackResponse.Response.ResponseStatus.Description);
    }
}