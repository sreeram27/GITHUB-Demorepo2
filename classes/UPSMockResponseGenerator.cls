@isTest
global class UPSMockResponseGenerator {
    global class UPSSinglePackageSuccessResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"TrackResponse":{"Response":{"ResponseStatus":{"Code":"1", "Description":"Success"}, ' + 
            '"TransactionReference":{"CustomerContext":"Test Case Summary Description"}}, ' + 
            '"Shipment":{"InquiryNumber":{"Code":"01", "Description":"ShipmentIdentificationNumber", ' + 
            '"Value":"1ZA692F70196635379"}, "ShipperNumber":"A692F7", "ShipmentAddress":[{"Type":{"Code":"01", ' + 
            '"Description":"Shipper Address"}, "Address":{"AddressLine":"5221 N O CONNOR BLVD", "City":"IRVING", ' + 
            '"StateProvinceCode":"TX", "PostalCode":"75039   4422", "CountryCode":"US"}}, {"Type":{"Code":"02", ' + 
            '"Description":"ShipTo Address"}, "Address":{"City":"NASHVILLE", "StateProvinceCode":"TN", "PostalCode":"37214", ' + 
            '"CountryCode":"US"}}], "ShipmentWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"11.00"}, ' + 
            '"Service":{"Code":"001", "Description":"UPS NEXT DAY AIR"}, "ReferenceNumber":[{"Code":"01", "Value":"AXEGU001"}, ' + 
            '{"Code":"01", "Value":"JOSHUA.SNYDER"}], "PickupDate":"20170227", "Package":{"TrackingNumber":"1ZA692F70196635379", ' + 
            '"Activity":{"ActivityLocation":{"Address":{"City":"NASHVILLE", "StateProvinceCode":"TN", "PostalCode":"37214", ' + 
            '"CountryCode":"US"}, "Code":"PF", "Description":"INSIDE DELIV", "SignedForByName":"WARWICK"}, ' + 
            '"Status":{"Type":"D", "Description":"DELIVERED", "Code":"KB"}, "Date":"20170228", "Time":"100000"}, ' + 
            '"PackageWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"11.00"}, "ReferenceNumber":[{"Code":"01", "Value":"AXEGU001"}, ' + 
            '{"Code":"01", "Value":"JOSHUA.SNYDER"}]}}}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class UPSMultiplePackageSuccessResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"TrackResponse":{"Response":{"ResponseStatus":{"Code":"1", "Description":"Success"}, ' + 
                '"TransactionReference":{"CustomerContext":"Test Case Summary Description"}}, ' + 
                '"Shipment":{"InquiryNumber":{"Code":"01", "Description":"ShipmentIdentificationNumber", ' + 
                '"Value":"1Z6F814F0323777546"}, "ShipperNumber":"6F814F", ' + 
                '"ShipmentAddress":[{"Type":{"Code":"01", "Description":"Shipper Address"}, ' + 
                '"Address":{"AddressLine":"5500 12TH AVE  E", "City":"SHAKOPEE", "StateProvinceCode":"MN", ' + 
                '"PostalCode":"55379   1812", "CountryCode":"US"}}, {"Type":{"Code":"02", "Description":"ShipTo Address"}, ' + 
                '"Address":{"City":"LOUISVILLE", "StateProvinceCode":"KY", "PostalCode":"40241", "CountryCode":"US"}}], ' + 
                '"ShipmentWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"18.00"}, "Service":{"Code":"003", "Description":"UPS GROUND"}, ' + 
                '"PickupDate":"20170411", "Package":[{"TrackingNumber":"1Z6F814F0323777546", ' + 
                '"Activity":{"ActivityLocation":{"Address":{"City":"LOUISVILLE", "StateProvinceCode":"KY", "PostalCode":"40241", "CountryCode":"US"}, ' + 
                '"Code":"M6", "Description":"OFFICE", "SignedForByName":"HUNDLEY"}, "Status":{"Type":"D", "Description":"DELIVERED", "Code":"KB"}, ' + 
                '"Date":"20170413", "Time":"115100"}, "PackageWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"4.00"}, ' + 
                '"ReferenceNumber":[{"Code":"01", "Value":"LG&E AND KU ENERGY, LL"}, {"Code":"01", "Value":"0000177427"}, ' + 
                '{"Code":"01", "Value":"00102"}, {"Code":"01", "Value":"LG&E AND KU ENERGY, LLC"}]}, ' + 
                '{"TrackingNumber":"1Z6F814F0323855925", "Activity":{"ActivityLocation":{"Address":{"City":"LOUISVILLE", ' + 
                '"StateProvinceCode":"KY", "PostalCode":"40241", "CountryCode":"US"}, "Code":"M6", "Description":"OFFICE", ' + 
                '"SignedForByName":"HUNDLEY"}, "Status":{"Type":"D", "Description":"DELIVERED", "Code":"KB"}, ' + 
                '"Date":"20170413", "Time":"115100"}, "PackageWeight":{"UnitOfMeasurement":{"Code":"LBS"}, "Weight":"14.00"}, ' + 
                '"ReferenceNumber":[{"Code":"01", "Value":"LG&E AND KU ENERGY, LL"}, {"Code":"01", "Value":"0000177427"}, ' + 
                '{"Code":"01", "Value":"00102"}, {"Code":"01", "Value":"LG&E AND KU ENERGY, LLC"}]}]}}}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class UPSErrorResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Fault":{"faultcode":"Client", "faultstring":"An exception has been raised as a result of client data.", "detail":{"Errors":{"ErrorDetail":{"Severity":"Hard", "PrimaryErrorCode":{"Code":"151018", "Description":"Invalid tracking number"}}}}}}');
            res.setStatusCode(200);
            return res;
        }
    }
   
}