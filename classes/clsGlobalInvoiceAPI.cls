/********************************************************************
*   Name        : clsGlobalInvoiceAPI
*   Date        : 29-July-2019
*   Author      : Pragati Goel(FOS TEAM) 
*   Description : This class is used for Invoice functionality. dfsf

*   Change History: 
*   Author: Pragati Goel(FOS TEAM)
*   Date:   24-Sep-2020
*   Reason: (R9.0.00/BS-6309/BS-6101) - This class is used for Invoice functionality. SaiSRC1223 dsf
*******************************************************************/
global with sharing class clsGlobalInvoiceAPI {
    Private Static Final String CLASSNAME = 'clsGlobalInvoiceAPI';
    /**
    asdfasdfa < < > > && & % $ # @ ! * () <>sai 1234
    */
    Private Static Final String SOBJECTNAME = 'Work Order Line Item';
    Private static Final string  APIMETHOD = 'POST';
    Private static Final string  CONTENTTYPE = 'Content-Type';
    Private static Final string  APPLICATIONXML = 'application/xml';
    Private static Final string  AUTHORIZATION = 'Authorization';
    Private static Final string  BASICKEYWORD = 'BASIC ';
    Private static Final string  ENDPOINT = 'callout:GLOBAL_ASSET_INSTALLATION';
    Private static Final String TRANSACTIONHEADER = 'Transaction';
    Private static Final String TRANSACTIONHEADERMESSAGE = 'SEND_SR_BILL_INFO_GCE';
    Private static Final String REGIONHEADER = 'Region';
    Private static Final String REGIONHEADERMESSAGE = 'EMEA';
    Private static Final String XMLSTARTTAG = '<?xml version="1.0" encoding="UTF-8"?>';
    Private static Final String XMLENDTAG = '';
    Private static Final Integer INTEGRATIONSTATUSCODE = 200;
    Private static Final string  INTEGRATIONERROR = 'Error';
    Private static Final string  INTEGRATIONERRORMESSAGE = 'Invoice cannot be generated for Bill-To account.';
    Private static Final string  BLANKVALUE = '';
    Private static Final string  INTEGRATIONSUCCESS = 'Success';
    Private static Final string  INVOICEOPENTAG = 'Invoice Open Tag';
    Private static Final string  INVOICECLOSETAG = 'Invoice Close Tag';
    Private static Final string  ID = 'Id';
    Private static Final string  SENTFORINVOICINGFIELD = 'Sent_for_Invoicing__c';
    Private static Final string SOURCETRUNK = 'Trunk';
    Private static Final string INTEGRATIONTYPE = 'Invoice';
    Private static Final string COLON = ':' ;
    Private static Final string OrderTypeCodeSO = 'SO' ;
    Private static Final string OrderTypeCodeSF = 'SF' ;
    Private static Final string SLASHN = ':\n';
    Private static Final string  ONE = '1';
    Private static Final string  ZERO = '0';
    Private static Final string  REVALUE = 'RE';
    Private static Final string  RNVALUE = 'RN';
    Private static Final string  HVALUE = 'H';   
    Private static Final string  SIEBEL_SRV_REQVALUE = 'SIEBEL_SRV_REQ';
    Private static Final string  FIELDCORRECTIVEACTIONVALUE = 'Field Corrective Action';
    Private static Final string  SERVICECONTRACTPPTVALUE = 'Service Contract - PPT';
    Private static Final string  DVALUE = 'D';
    Private static Final string  EACHVALUE = 'Each';
    Private static Final string  SINGLESPACEVALUE = ' ';
    Private static Final string NULLVALUE = 'null';
    Private static Final string XMLHTMLTAG = '<xml><HTTPResponse>Successfully received the Transaction : ';
    Private static Final string XMLRESPONSETAG = '</HTTPResponse></xml>';
    Private static Final string PARTPRICEOVERRIDECODE = ' ';
    Private static Final String BACKSLASHN = '\n';
    Private static Final String INVOICEFILENAME = 'Invoice.csv';
    Private static Final String FILECOLUMN='Id'+','+'WorkOrderNumber'; 
    Private static Final String BRACKET = ']]>';
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This class is used for Invoice functionality for billable and non billable both.
    @param: NA
    @return: void
    */
    @future(callout=true)
    global static void sendInvoiceRequest(set<Id> setWorkorderIds,set<Id> setWOLIIds,String OrganizationRegion,Boolean InvoiceAPICallfromBatch){
        Map<Boolean,String> ResponseUpdateMap = new Map<Boolean,String>();
        Boolean sendforinvoicing = FALSE;
        String responsemessage = BLANKVALUE;
        try{
            ResponseUpdateMap = sendrequestforbillable(setWorkorderIds,setWOLIIds,OrganizationRegion);
            sendrequestforNonbillable(setWorkorderIds,setWOLIIds,OrganizationRegion,InvoiceAPICallfromBatch);
        }catch(Exception ex){
            ExceptionHandler.exceptionTrace(SOBJECTNAME,CLASSNAME + ex.getLineNumber() + SLASHN + ex.getmessage(),ExceptionHandler.ExceptionSeverity.Low);
        }  
        if(!ResponseUpdateMap.isEmpty()){
            for(Boolean invoicingfalg : ResponseUpdateMap.keyset()){
                sendforinvoicing = invoicingfalg;
                responsemessage = ResponseUpdateMap.get(invoicingfalg);
            }
            if(sendforinvoicing){
                responseupdateforbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONSUCCESS,responsemessage,sendforinvoicing,InvoiceAPICallfromBatch);
            }else{
                responseupdateforbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONERROR,responsemessage,sendforinvoicing,InvoiceAPICallfromBatch);
            }
        }
    }
    /*
    sai890
    @purpose: (R9.0.00/BS-6309/BS-6101) - This class is used for Invoice functionality for billable.
    @param: NA12
    @return: void
    */
    global static Map<Boolean,String> sendrequestforbillable(set<Id> setWorkorderIds,set<Id> setWOLIIds,String OrganizationRegion){
        Map<Boolean,String> ResponseUpdateMap = new Map<Boolean,String>();
        InvoiceWrapper InvoiceWrapperdata = InvoiceWrapperFilling(setWorkorderIds,setWOLIIds);
		System.debug('##InvoiceWrapperdata##'+InvoiceWrapperdata);
        if(InvoiceWrapperdata.TTbillableflag || InvoiceWrapperdata.PCbillableflag || InvoiceWrapperdata.ETbillableflag || InvoiceWrapperdata.CHARGESbillableflag){
            HTTP auth = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint(ENDPOINT);
            req.setMethod(APIMETHOD);   
            req.setHeader(CONTENTTYPE,APPLICATIONXML);
            req.setHeader(TRANSACTIONHEADER,TRANSACTIONHEADERMESSAGE);
            req.setHeader(REGIONHEADER,OrganizationRegion);
            Blob headerValue = Blob.valueOf('{!$Credential.Username}' + COLON + '{!$Credential.Password}');
            String authorizationHeader = BASICKEYWORD + EncodingUtil.base64Encode(headerValue);
            req.setHeader(AUTHORIZATION, authorizationHeader); 
            
            String requestbody = BLANKVALUE;
            requestbody = convertintoXMLBillable(InvoiceWrapperdata);
            String reqbody = requestbody;
            req.setBody(reqbody);
            HTTPResponse authresp=new HttpResponse();
            authresp = auth.send(req);
            System.debug('<--authresp response-->'+authresp);
            if(authresp.getStatusCode() == INTEGRATIONSTATUSCODE){
                ResponseUpdateMap.put(True, authresp.getBody());
                //responseupdateforbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONSUCCESS,authresp.getBody(),True);
            }else{
                ResponseUpdateMap.put(False, authresp.getBody());
                //responseupdateforbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONERROR,authresp.getBody(),False);
            }   
        }
        return ResponseUpdateMap;
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This class is used for Invoice functionality for Non billable.
    @param: NA
    @return: void
    */
    global static void sendrequestforNonbillable(set<Id> setWorkorderIds,set<Id> setWOLIIds,String OrganizationRegion,Boolean InvoiceAPICallfromBatch){
        InvoiceWrapper InvoiceWrapperdata = InvoiceWrapperFilling(setWorkorderIds,setWOLIIds);
		System.debug('##InvoiceWrapperdata##'+InvoiceWrapperdata);
        if(!InvoiceWrapperdata.TTbillableflag || !InvoiceWrapperdata.PCbillableflag || !InvoiceWrapperdata.ETbillableflag){
            String requestbody = BLANKVALUE;
            
            HTTP auth = new HTTP();
            HTTPRequest req = new HTTPRequest();
            req.setEndpoint(ENDPOINT);
            req.setMethod(APIMETHOD);   
            req.setHeader(CONTENTTYPE,APPLICATIONXML);
            req.setHeader(TRANSACTIONHEADER,TRANSACTIONHEADERMESSAGE);
            req.setHeader(REGIONHEADER,OrganizationRegion);
            Blob headerValue = Blob.valueOf('{!$Credential.Username}' + COLON + '{!$Credential.Password}');
            String authorizationHeader = BASICKEYWORD + EncodingUtil.base64Encode(headerValue);
            req.setHeader(AUTHORIZATION, authorizationHeader); 
            
            requestbody = convertintoXMLNonBillable(InvoiceWrapperdata);
            String reqbody = requestbody;
            req.setBody(reqbody);
            HTTPResponse authresp=new HttpResponse();
            authresp = auth.send(req);
            System.debug('<--authresp response-->'+authresp);
            if(authresp.getStatusCode() == INTEGRATIONSTATUSCODE){
                responseupdateforNonbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONSUCCESS,authresp.getBody(),True,InvoiceAPICallfromBatch);
            }else{
                responseupdateforNonbillable(setWOLIIds,INTEGRATIONTYPE,INTEGRATIONERROR,authresp.getBody(),False,InvoiceAPICallfromBatch);
            }
       }
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This method is used to fill the invoice wrapper.
    @param: setWorkorderIds - work order record id set.
    setWOLIIds :- work order line item record id set.
    @return: InvoiceWrapper
    */
    private static InvoiceWrapper InvoiceWrapperFilling(set<Id> setWorkorderIds,set<Id> setWOLIIds){
        Map<Id,list<Time_Tracker__c>> TimeTrackerMap = new Map<Id,list<Time_Tracker__c>>();
        Map<Id,list<Expense_Tracker__c>> ExpenseTrackerMap = new Map<Id,list<Expense_Tracker__c>>();
        Map<Id,list<ProductConsumed>> ProductConsumedMap = new Map<Id,list<ProductConsumed>>();
        Map<Id,list<Charges__c>> ChargesMap = new Map<Id,list<Charges__c>>();
        Map<Id,WorkorderLineitem> WOLIMap = new Map<Id,WorkorderLineitem>();
        Map<Map<Id,WorkorderLineitem>,Map<Id,list<ProductConsumed>>> WOLIProductConsumedMap = new Map<Map<Id,WorkorderLineitem>,Map<Id,list<ProductConsumed>>>();
        WorkOrder ListWorkOrder = [SELECT Id,Customer_Inventory_Asset__c,Account.Cost_Center__c,Warranty__c,ServiceContract.Agreement__c,Billable__c,PO_Number__c,Project_Id__c,WorkOrderNumber,AccountId,Account.Bill_To__c,Account.JDE_Account_GLB__c,Account.Organization__r.Country__c, 
                                   Closed_Date__c,Product_Name__r.Name,Serial_Number__c,Contact.FirstName,Contact.LastName,contact.Preferred_Phone__c,
                                   contact.MobilePhone,contact.HomePhone,contact.OtherPhone,contact.Business_Phone__c,Override_Bill_To_Account__r.JDE_Account_GLB__c,Override_Bill_To_Account__r.Name,Product_Name__r.Product_Family_Name__c,
                                   Account.Organization__r.Product_Branch_Plant__c,Organization__r.Service_Region__c,status from WorkOrder where Id IN: setWorkorderIds LIMIT 1];
        List<WorkorderLineitem> ListWOLI = [SELECT Id,workorder.ServiceContract.Agreement__c,workorder.ServiceContract.Agreement_Type__c,Type__c,Product_Name__r.ProductCode,
                                            (SELECT Id,JDE_Billing_Code__c,Work_Order_Line_Item__c,Non_Billable_Reason_Code__c,Elapsed__c,Billable__c,Start__c,Stop__c from Time_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Sent_for_Invoicing__c = FALSE LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())),
                                            (SELECT Id,Work_Order_Line_Item__c,Non_Billable_Reason_Code__c,Billable__c,CurrencyIsoCode,Amount__c,Quantity__c,JDE_Billing_Code__c from Expense_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Sent_for_Invoicing__c = FALSE LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())),
                                            (SELECT Id,QuantityConsumed,Reversal_Quantity__c,ProductItem.Location.Branch_Plant__c,Product2.Lot_Tracking_Flag__c,
                                             ProductItem.SerialNumber,WorkOrderLineItemId,QuantityUnitOfMeasure,Product2.ProductCode,Product2.Serialized__c,
                                             Non_Billable_Reason_Code__c,Billable__c,Product2.JDE_Unit_of_Measure_GLB__c from ProductsConsumed where WorkOrderLineItemId IN : setWOLIIds AND Sent_for_Invoicing__c = FALSE AND Source__c =: SOURCETRUNK LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())),
                                            (SELECT Id,Work_Order_Line_Item__c,Amount__c,Product__r.ProductCode,Sent_for_Invoicing__c from Charges__r where Work_Order_Line_Item__c IN : setWOLIIds AND Sent_for_Invoicing__c = FALSE LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows()))
                                            from WorkorderLineitem where Id IN: setWOLIIds LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
        WOLIMap.putAll(ListWOLI);
        for(WorkorderLineitem newWOLI : ListWOLI){
            if(!newWOLI.Time_Trackers__r.isEmpty()){
                TimeTrackerMap.put(newWOLI.Id,newWOLI.Time_Trackers__r);   
            }
            if(!newWOLI.Expense_Trackers__r.isEmpty()){
                ExpenseTrackerMap.put(newWOLI.Id,newWOLI.Expense_Trackers__r);   
            }
            if(!newWOLI.ProductsConsumed.isEmpty()){
                ProductConsumedMap.put(newWOLI.Id,newWOLI.ProductsConsumed);
            }
            if(!newWOLI.Charges__r.isEmpty()){
                ChargesMap.put(newWOLI.Id,newWOLI.Charges__r);
            }
        }
        WOLIProductConsumedMap.put(WOLIMap,ProductConsumedMap);
        
        ///ALL TME TRACKER ARE BILLABLE
        Boolean TTDONOTSENTNONBILLABLEREQUEST = FALSE;
        Boolean NOTALLBILLABLETIMETRACKER = FALSE;
        Map<Id,Boolean> TimetrackrbillbaleMap = new Map<Id,Boolean>();
        for(WorkorderLineitem newWOLI : ListWOLI){
            if(TimeTrackerMap.get(newWOLI.Id) != null && !TimeTrackerMap.get(newWOLI.Id).isEmpty()){
                for(Time_Tracker__c TT : TimeTrackerMap.get(newWOLI.Id)){
                    if(TT.Billable__c  == TRUE){
                        TimetrackrbillbaleMap.put(newWOLI.Id,TRUE);
                    }else{
                        TimetrackrbillbaleMap.put(newWOLI.Id,FALSE);
                    }
                }   
            }else{
                TimetrackrbillbaleMap.put(newWOLI.Id,FALSE);
            }           
        }
        if(!TimetrackrbillbaleMap.isEmpty()){
            for(Id woliIds : TimetrackrbillbaleMap.keyset()){
                if(TimetrackrbillbaleMap.get(woliIds) == TRUE){
                    TTDONOTSENTNONBILLABLEREQUEST = TRUE;
                }else{
                    NOTALLBILLABLETIMETRACKER = TRUE;
                }
            }
        }else{
            TTDONOTSENTNONBILLABLEREQUEST = FALSE;
        }
        ////ALL PART TRACKER ARE BILLABLE
        Boolean PCDONOTSENTNONBILLABLEREQUEST = FALSE;
        Boolean NOTALLBILLABLEPC = FALSE;
        Map<Id,Boolean> ProductConsumedbillbaleMap = new Map<Id,Boolean>();
        for(WorkorderLineitem newWOLI : ListWOLI){
            if(ProductConsumedMap.get(newWOLI.Id) != null && !ProductConsumedMap.get(newWOLI.Id).isEmpty()){
                for(ProductConsumed pc : ProductConsumedMap.get(newWOLI.Id)){
                    if(pc.Billable__c  == TRUE){
                        ProductConsumedbillbaleMap.put(newWOLI.Id,TRUE);
                    }else{
                        ProductConsumedbillbaleMap.put(newWOLI.Id,FALSE);
                    }
                }
            }else{
                ProductConsumedbillbaleMap.put(newWOLI.Id,FALSE);
            }           
        }
        if(!ProductConsumedbillbaleMap.isEmpty()){
            for(Id woliIds : ProductConsumedbillbaleMap.keyset()){
                if(ProductConsumedbillbaleMap.get(woliIds) == TRUE){
                    PCDONOTSENTNONBILLABLEREQUEST = TRUE;
                }else{
                    NOTALLBILLABLEPC = TRUE;
                }
            }
        }else{
            PCDONOTSENTNONBILLABLEREQUEST = FALSE;
        }
        ////ALL EXPENSE TRACKER ARE BILLABLE sai898u9u
        Boolean ETDONOTSENTNONBILLABLEREQUEST = FALSE;
        Boolean NOTALLBILLABLEET = FALSE;
        Map<Id,Boolean> ExpenseTrackerbillbaleMap = new Map<Id,Boolean>();
        for(WorkorderLineitem newWOLI : ListWOLI){
            if(ExpenseTrackerMap.get(newWOLI.Id) != null && !ExpenseTrackerMap.get(newWOLI.Id).isEmpty()){
                for(Expense_Tracker__c ET : ExpenseTrackerMap.get(newWOLI.Id)){
                    if(ET.Billable__c  == TRUE){
                        ExpenseTrackerbillbaleMap.put(newWOLI.Id,TRUE);
                    }else{
                        ExpenseTrackerbillbaleMap.put(newWOLI.Id,FALSE);
                    }
                }   
            }else{
                ExpenseTrackerbillbaleMap.put(newWOLI.Id,FALSE);
            }           
        }
        if(!ExpenseTrackerbillbaleMap.isEmpty()){
            for(Id woliIds : ExpenseTrackerbillbaleMap.keyset()){
                if(ExpenseTrackerbillbaleMap.get(woliIds) == TRUE){
                    ETDONOTSENTNONBILLABLEREQUEST = TRUE;
                }else{
                    NOTALLBILLABLEET = TRUE;
                }
            }
        }else{
            ETDONOTSENTNONBILLABLEREQUEST = FALSE;
        }
        ////Invoice Wrapper Filling
        InvoiceWrapper Invoicewrap = new InvoiceWrapper();
        Invoicewrap.workorderList = ListWorkOrder;
        Invoicewrap.workorderlineitemList = ListWOLI;
        Invoicewrap.MapOfWorkOrderLineItem = WOLIMap;
        Invoicewrap.MapOfTimeTracker = TimeTrackerMap;
        Invoicewrap.MapOfExpenseTracker = ExpenseTrackerMap;
        Invoicewrap.MapOfProductConsumed = ProductConsumedMap;
        Invoicewrap.MapOfCharges = ChargesMap;
        if(TTDONOTSENTNONBILLABLEREQUEST  == TRUE && NOTALLBILLABLETIMETRACKER == FALSE){
            Invoicewrap.TTbillableflag =  TTDONOTSENTNONBILLABLEREQUEST;
        }else{
			if(TimetrackrbillbaleMap.isEmpty()){
				Invoicewrap.TTbillableflag = TRUE;
			}else{
				Invoicewrap.TTbillableflag = FALSE;
			} 
        }
        if(PCDONOTSENTNONBILLABLEREQUEST  == TRUE && NOTALLBILLABLEPC == FALSE){
            Invoicewrap.PCbillableflag =  PCDONOTSENTNONBILLABLEREQUEST;
        }else{
			if(ProductConsumedbillbaleMap.isEmpty()){
				Invoicewrap.PCbillableflag = TRUE;
			}else{
				Invoicewrap.PCbillableflag = FALSE;
			} 
        }
        if(ETDONOTSENTNONBILLABLEREQUEST  == TRUE && NOTALLBILLABLEET == FALSE){
            Invoicewrap.ETbillableflag =  PCDONOTSENTNONBILLABLEREQUEST;
        }else{
			if(ExpenseTrackerbillbaleMap.isEmpty()){
				Invoicewrap.ETbillableflag = TRUE;
			}else{
				Invoicewrap.ETbillableflag = FALSE;
			} 
        }
        if(!ChargesMap.isEmpty()){
            Invoicewrap.CHARGESbillableflag = TRUE; 
        }else{
            Invoicewrap.CHARGESbillableflag = FALSE;
        }
        return Invoicewrap;
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This method is used to convert the data into xml format for Billable.
    @param: PCwrapper : - Invoice wrapper.
                username : username.
                password : password.
    @return: string
    */
    private static string convertintoXMLBillable(InvoiceWrapper InvoiceWrap){
        String InvoiceOpenTagId = BLANKVALUE;
        String InvoiceClosingTagId = BLANKVALUE;
        String FinalXmlBody = BLANKVALUE;
        Map<Id,Global_Technical_Service_Invoice_Tag__mdt> MapofInvoiceMetaDataOpenTag = new Map<Id,Global_Technical_Service_Invoice_Tag__mdt>();
        Map<Id,Global_Technical_Service_Invoice_Tag__mdt> MapofInvoiceMetaDataClosedTag = new Map<Id,Global_Technical_Service_Invoice_Tag__mdt>();
        
        ////Custom meta data for xml generationcxzczxcxcxcxc
        for(Global_Technical_Service_Invoice_Tag__mdt InvoiceData : [SELECT Id, DeveloperName, MasterLabel, Language, 
                                                                     NamespacePrefix, Label, QualifiedApiName, ServiceRequest__c, 
                                                                     ServiceRequestInvoicingInterface__c, ServiceRequestNumber__c, 
                                                                     AccountNumber__c, AccountCountry__c, OrderDate__c, Product__c, 
                                                                     AssetNumber__c, ContactFirstName__c, ContactLastName__c, 
                                                                     ContactBusinessPhone__c, AccountPO__c, BusinessUnit__c, SourceRegionCode__c, 
                                                                     EDIDocTypeCode__c, OrderTypeCode__c, PartnerID__c, EDIRecTypeCode__c, 
                                                                     EDITransactionDate__c, EDIBatchID__c, Id__c, ProjectId__c, BillToOvrdAccountNum__c, 
                                                                     ProductFamily__c, CustomerInventory__c, Action__c, FsActivityPartsMovement__c, 
                                                                     ShippedQtyInUoM__c, UoM__c, LineItemNum__c, PriceOveridCode__c, ItemPriceForLUM__c, 
                                                                     ItemExtPrice__c, NonBillableReasonCode__c, SerialNumber__c, LotNumber__c, 
                                                                     InventoryBranchPlant__c, PPTNumber__c, BranchPlant__c, TimeSheetDailyHours__c, 
                                                                     FsExpenseItem__c, Currency__c, FsCharge__c, FlatRate__c 
                                                                     FROM Global_Technical_Service_Invoice_Tag__mdt LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())])
        {
            if(InvoiceData.MasterLabel == INVOICEOPENTAG){
                InvoiceOpenTagId = InvoiceData.Id;
                MapofInvoiceMetaDataOpenTag.put(InvoiceData.Id,InvoiceData);
            }else if(InvoiceData.MasterLabel == INVOICECLOSETAG){
                InvoiceClosingTagId = InvoiceData.Id;
                MapofInvoiceMetaDataClosedTag.put(InvoiceData.Id,InvoiceData);
            }
        }
        
        ///Invoice Wrapper Data
        Map<Id,list<Time_Tracker__c>> TimeTrackerMap = new Map<Id,list<Time_Tracker__c>>();
        Workorder workorderdata = InvoiceWrap.workorderList;
        list<WorkOrderLineItem> Listworkorderlineitem = InvoiceWrap.workorderlineitemList;
        Map<Id,WorkOrderLineItem> WorkOrderLineItemMap = InvoiceWrap.MapOfWorkOrderLineItem;
        if(!InvoiceWrap.MapOfTimeTracker.isEmpty()){
            TimeTrackerMap = InvoiceWrap.MapOfTimeTracker;
        }
        Map<Id,list<ProductConsumed>> ProductConsumedMap = InvoiceWrap.MapOfProductConsumed;
        Map<Id,list<Expense_Tracker__c>> ExpenseTrackerMap = InvoiceWrap.MapOfExpenseTracker;
        Map<Id,list<Charges__c>> ChargesMap = InvoiceWrap.MapOfCharges;
        String OrderTypeCode = BLANKVALUE;
        String PriceOveridCode = BLANKVALUE;
        String NonBillableReasonCode = BLANKVALUE;
        String EDIDocTypeCode = BLANKVALUE;
        OrderTypeCode = OrderTypeCodeSO;
        /*if(workorderdata.Billable__c){
            OrderTypeCode = OrderTypeCodeSO;
            PriceOveridCode = BLANKVALUE;
        }else{
            OrderTypeCode = OrderTypeCodeSF;
            PriceOveridCode = ONE;
        }*/
        if(workorderdata.Billable__c){
            if(!ProductConsumedMap.isEmpty()){
                EDIDocTypeCode = REVALUE;
            }else{
                EDIDocTypeCode = RNVALUE;
            }
        }else{
            EDIDocTypeCode = REVALUE;
        }
        //XML Body
        String xmlBody = BLANKVALUE;
        xmlBody += XMLSTARTTAG;
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequestInvoicingInterface__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequest__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequestNumber__c)+workorderdata.WorkOrderNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequestNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountNumber__c)+workorderdata.Account.JDE_Account_GLB__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountCountry__c)+workorderdata.Account.Organization__r.Country__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountCountry__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderDate__c)+String.valueof(workorderdata.Closed_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''))+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderDate__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Product__c)+workorderdata.Product_Name__r.Name+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Product__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AssetNumber__c)+workorderdata.Serial_Number__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AssetNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactFirstName__c)+workorderdata.Contact.firstName+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactFirstName__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactLastName__c)+workorderdata.Contact.LastName+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactLastName__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactBusinessPhone__c)+String.valueof(workorderdata.Contact.Business_Phone__c)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactBusinessPhone__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountPO__c)+workorderdata.PO_Number__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountPO__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BusinessUnit__c)+workorderdata.Account.Cost_Center__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BusinessUnit__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).SourceRegionCode__c)+workorderdata.Organization__r.Service_Region__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).SourceRegionCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIDocTypeCode__c)+EDIDocTypeCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIDocTypeCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PartnerID__c)+SIEBEL_SRV_REQVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PartnerID__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+HVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
        //xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDITransactionDate__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDITransactionDate__c);
        //xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIBatchID__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIBatchID__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+workorderdata.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ProjectId__c)+workorderdata.Project_Id__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ProjectId__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BillToOvrdAccountNum__c)+workorderdata.Override_Bill_To_Account__r.JDE_Account_GLB__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BillToOvrdAccountNum__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ProductFamily__c)+workorderdata.Product_Name__r.Product_Family_Name__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ProductFamily__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).CustomerInventory__c)+workorderdata.Customer_Inventory_Asset__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).CustomerInventory__c);
        for(WorkOrderLineItem newWOLI : Listworkorderlineitem){
            String PPTNumber = BLANKVALUE;
            if(workorderdata.Billable__c){
                PPTNumber= BLANKVALUE;
            }
            if(!workorderdata.Billable__c && newWOLI.Type__c == FIELDCORRECTIVEACTIONVALUE){
                PPTNumber= BLANKVALUE;
            }else{
                if(workorderdata.Warranty__c){
                    PPTNumber= BLANKVALUE;
                }else{
                    if(newWOLI.workorder.ServiceContract.Agreement_Type__c == SERVICECONTRACTPPTVALUE){
                        PPTNumber = newWOLI.workorder.ServiceContract.Agreement__c;
                    }else{
                        PPTNumber= BLANKVALUE;
                    }
                }
            }
            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Action__c);
            if(ProductConsumedMap.get(newWOLI.Id) == null){
                xmlBody += BLANKVALUE;
            }else{
                for(ProductConsumed pc : ProductConsumedMap.get(newWOLI.Id)){
                    if(pc.Billable__c){
                        String SerialNumber = BLANKVALUE;
                        String LotNumber = BLANKVALUE;
                        String PCQuantityUOM = BLANKVALUE;
                        if(pc.Product2.Serialized__c){
                            SerialNumber = pc.ProductItem.SerialNumber;
                        }else if(pc.Product2.Lot_Tracking_Flag__c){
                            LotNumber = pc.ProductItem.SerialNumber;
                        }
                        Decimal netquantityconsumed = 0;
                        if(pc.Reversal_Quantity__c != null){
                            netquantityconsumed = pc.QuantityConsumed - pc.Reversal_Quantity__c;
                        }else{
                            netquantityconsumed = pc.QuantityConsumed;
                        }   
                        if(pc.Product2.JDE_Unit_of_Measure_GLB__c != null || pc.Product2.JDE_Unit_of_Measure_GLB__c != BLANKVALUE){
                            PCQuantityUOM = pc.Product2.JDE_Unit_of_Measure_GLB__c;
                        }else{
                            PCQuantityUOM = 'EA';
                        }
                        Integer netquantityconsumedininteger = Integer.valueOf(netquantityconsumed);
                        if(netquantityconsumedininteger != 0){
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsActivityPartsMovement__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+netquantityconsumedininteger+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+PCQuantityUOM+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+pc.Product2.ProductCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+PARTPRICEOVERRIDECODE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+pc.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).SerialNumber__c)+SerialNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).SerialNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LotNumber__c)+LotNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LotNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).InventoryBranchPlant__c)+pc.ProductItem.Location.Branch_Plant__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).InventoryBranchPlant__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+pc.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PPTNumber__c)+PPTNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PPTNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsActivityPartsMovement__c);   
                        }else{
                            xmlBody += BLANKVALUE;
                        }
                    }
                }
            }
            if(TimeTrackerMap.get(newWOLI.Id) == null){
                xmlBody += BLANKVALUE;
            }else{
                for(Time_Tracker__c tc : TimeTrackerMap.get(newWOLI.Id)){
                    if(tc.Billable__c){
                        Decimal TCShippedQtyInUoM = ((tc.Stop__c.getTime())/1000/60) - ((tc.Start__c.getTime())/1000/60);
                        Long TCShippedQtyInUoMLong = Math.roundToLong(TCShippedQtyInUoM);
                        Integer TCShippedQtyInUoMRoundOff = Integer.valueOf(TCShippedQtyInUoMLong);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).TimeSheetDailyHours__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+TCShippedQtyInUoMRoundOff+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+tc.JDE_Billing_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+tc.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);  
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+tc.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PPTNumber__c)+PPTNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PPTNumber__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).TimeSheetDailyHours__c);   
                    }
                }
            } 
            if(ExpenseTrackerMap.get(newWOLI.Id) == null){
                xmlBody += BLANKVALUE;
            }else{
                for(Expense_Tracker__c ec : ExpenseTrackerMap.get(newWOLI.Id)){
                    if(ec.Billable__c){
                        Decimal  ItemPriceForLUM = ec.Amount__c>=0?ec.Amount__c * 10000:0;
                        Decimal  ItemExtPrice = ec.Amount__c * ec.Quantity__c * 100;
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsExpenseItem__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+ec.JDE_Billing_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+String.valueOf(ItemPriceForLUM)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+String.valueOf(ItemExtPrice)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+ec.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+ec.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Currency__c)+ec.CurrencyIsoCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Currency__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsExpenseItem__c);
                    }
                }
            }
            if(ChargesMap.get(newWOLI.Id) == null){
                xmlBody += BLANKVALUE;  
            }else{
                for(Charges__c charges : ChargesMap.get(newWOLI.Id)){
                    Decimal amount = charges.Amount__c>=0?charges.Amount__c * 10000:0;
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsCharge__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+charges.Product__r.ProductCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+PARTPRICEOVERRIDECODE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+SINGLESPACEVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);   
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+charges.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FlatRate__c)+String.valueof(amount)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FlatRate__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsCharge__c);
                }
            }                      
            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+newWOLI.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
            xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Action__c);
        }
        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequest__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequestInvoicingInterface__c);
        if(xmlBody.contains(NULLVALUE)){
            FinalXmlBody = xmlBody.replaceAll(NULLVALUE,BLANKVALUE);
        }else{
            FinalXmlBody = xmlBody;
        }
        System.debug('<--Billable XML BODY-->'+FinalXmlBody);
        return FinalXmlBody;
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This method is used to convert the data into xml format for Non Billable.
    @param: PCwrapper : - Invoice wrapper.
    username : username.
    password : password.
    @return: stringxzcxzc
    */
    private static string convertintoXMLNonBillable(InvoiceWrapper InvoiceWrap){
        String InvoiceOpenTagId = BLANKVALUE;
        String InvoiceClosingTagId = BLANKVALUE;
        String FinalXmlBody = BLANKVALUE;
        Map<Id,Global_Technical_Service_Invoice_Tag__mdt> MapofInvoiceMetaDataOpenTag = new Map<Id,Global_Technical_Service_Invoice_Tag__mdt>();
        Map<Id,Global_Technical_Service_Invoice_Tag__mdt> MapofInvoiceMetaDataClosedTag = new Map<Id,Global_Technical_Service_Invoice_Tag__mdt>();
        
        ////Custom meta data for xml generationcscxsd
        for(Global_Technical_Service_Invoice_Tag__mdt InvoiceData : [SELECT Id, DeveloperName, MasterLabel, Language, 
                                                                     NamespacePrefix, Label, QualifiedApiName, ServiceRequest__c, 
                                                                     ServiceRequestInvoicingInterface__c, ServiceRequestNumber__c, 
                                                                     AccountNumber__c, AccountCountry__c, OrderDate__c, Product__c, 
                                                                     AssetNumber__c, ContactFirstName__c, ContactLastName__c, 
                                                                     ContactBusinessPhone__c, AccountPO__c, BusinessUnit__c, SourceRegionCode__c, 
                                                                     EDIDocTypeCode__c, OrderTypeCode__c, PartnerID__c, EDIRecTypeCode__c, 
                                                                     EDITransactionDate__c, EDIBatchID__c, Id__c, ProjectId__c, BillToOvrdAccountNum__c, 
                                                                     ProductFamily__c, CustomerInventory__c, Action__c, FsActivityPartsMovement__c, 
                                                                     ShippedQtyInUoM__c, UoM__c, LineItemNum__c, PriceOveridCode__c, ItemPriceForLUM__c, 
                                                                     ItemExtPrice__c, NonBillableReasonCode__c, SerialNumber__c, LotNumber__c, 
                                                                     InventoryBranchPlant__c, PPTNumber__c, BranchPlant__c, TimeSheetDailyHours__c, 
                                                                     FsExpenseItem__c, Currency__c, FsCharge__c, FlatRate__c 
                                                                     FROM Global_Technical_Service_Invoice_Tag__mdt LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())])
        {
            if(InvoiceData.MasterLabel == INVOICEOPENTAG){
                InvoiceOpenTagId = InvoiceData.Id;
                MapofInvoiceMetaDataOpenTag.put(InvoiceData.Id,InvoiceData);
            }else if(InvoiceData.MasterLabel == INVOICECLOSETAG){
                InvoiceClosingTagId = InvoiceData.Id;
                MapofInvoiceMetaDataClosedTag.put(InvoiceData.Id,InvoiceData);
            }
        }
        
        ///Invoice Wrapper Data
        Workorder workorderdata = InvoiceWrap.workorderList;
        list<WorkOrderLineItem> Listworkorderlineitem = InvoiceWrap.workorderlineitemList;
        Map<Id,WorkOrderLineItem> WorkOrderLineItemMap = InvoiceWrap.MapOfWorkOrderLineItem;
        Map<Id,list<Time_Tracker__c>> TimeTrackerMap = InvoiceWrap.MapOfTimeTracker;
        Map<Id,list<ProductConsumed>> ProductConsumedMap = InvoiceWrap.MapOfProductConsumed;
        Map<Id,list<Expense_Tracker__c>> ExpenseTrackerMap = InvoiceWrap.MapOfExpenseTracker;
        Map<Id,list<Charges__c>> ChargesMap = InvoiceWrap.MapOfCharges;
        
        String OrderTypeCode = BLANKVALUE;
        String PriceOveridCode = BLANKVALUE;
        String NonBillableReasonCode = BLANKVALUE;
        String EDIDocTypeCode = BLANKVALUE;
        OrderTypeCode = OrderTypeCodeSF;
        /*
	if(workorderdata.Billable__c){
            OrderTypeCode = OrderTypeCodeSO;
            PriceOveridCode = BLANKVALUE;
        }else{
            OrderTypeCode = OrderTypeCodeSF;
            PriceOveridCode = ONE;
        } */
        if(workorderdata.Billable__c){
            if(!ProductConsumedMap.isEmpty()){
                EDIDocTypeCode = REVALUE;
            }else{
                EDIDocTypeCode = RNVALUE;
            }
        }else{
            EDIDocTypeCode = REVALUE;
        }
        
        //XML Body Twstskfsdhfbd
        String xmlBody = BLANKVALUE;
        xmlBody += XMLSTARTTAG;
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequestInvoicingInterface__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequest__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ServiceRequestNumber__c)+workorderdata.WorkOrderNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequestNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountNumber__c)+workorderdata.Account.JDE_Account_GLB__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountCountry__c)+workorderdata.Account.Organization__r.Country__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountCountry__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderDate__c)+String.valueof(workorderdata.Closed_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''))+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderDate__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Product__c)+workorderdata.Product_Name__r.Name+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Product__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AssetNumber__c)+workorderdata.Serial_Number__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AssetNumber__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactFirstName__c)+workorderdata.Contact.firstName+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactFirstName__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactLastName__c)+workorderdata.Contact.LastName+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactLastName__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ContactBusinessPhone__c)+String.valueof(workorderdata.Contact.Business_Phone__c)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ContactBusinessPhone__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).AccountPO__c)+workorderdata.PO_Number__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).AccountPO__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BusinessUnit__c)+workorderdata.Account.Cost_Center__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BusinessUnit__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).SourceRegionCode__c)+workorderdata.Organization__r.Service_Region__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).SourceRegionCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIDocTypeCode__c)+EDIDocTypeCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIDocTypeCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PartnerID__c)+SIEBEL_SRV_REQVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PartnerID__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+HVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
        //xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDITransactionDate__c)+''+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDITransactionDate__c);
        //xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIBatchID__c)+''+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIBatchID__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+workorderdata.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ProjectId__c)+workorderdata.Project_Id__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ProjectId__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BillToOvrdAccountNum__c)+workorderdata.Override_Bill_To_Account__r.JDE_Account_GLB__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BillToOvrdAccountNum__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ProductFamily__c)+workorderdata.Product_Name__r.Product_Family_Name__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ProductFamily__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).CustomerInventory__c)+workorderdata.Customer_Inventory_Asset__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).CustomerInventory__c);
        for(WorkOrderLineItem newWOLI : WorkOrderLineItemMap.values()){
            String PPTNumber = BLANKVALUE;
            if(workorderdata.Billable__c){
                PPTNumber= BLANKVALUE;
            }
            if(!workorderdata.Billable__c && newWOLI.Type__c == FIELDCORRECTIVEACTIONVALUE){
                PPTNumber= BLANKVALUE;
            }else{
                if(workorderdata.Warranty__c){
                    PPTNumber= BLANKVALUE;
                }else{
                    if(newWOLI.workorder.ServiceContract.Agreement_Type__c == SERVICECONTRACTPPTVALUE){
                        PPTNumber = newWOLI.workorder.ServiceContract.Agreement__c;
                    }else{
                        PPTNumber= BLANKVALUE;
                    }
                }
            }
            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Action__c);
            if(ProductConsumedMap.get(newWOLI.Id) == null){
                xmlBody +=  BLANKVALUE;
            }else{
                for(ProductConsumed pc : ProductConsumedMap.get(newWOLI.Id)){
                    if(!pc.Billable__c){
                        String SerialNumber = BLANKVALUE;
                        String LotNumber = BLANKVALUE;
                        String PCQuantityUOM = BLANKVALUE;
                        if(pc.Product2.Serialized__c){
                            SerialNumber = pc.ProductItem.SerialNumber;
                        }else if(pc.Product2.Lot_Tracking_Flag__c){
                            LotNumber = pc.ProductItem.SerialNumber;
                        }
                        Decimal netquantityconsumed = 0;
                        if(pc.Reversal_Quantity__c != null){
                            netquantityconsumed = pc.QuantityConsumed - pc.Reversal_Quantity__c;
                        }else{
                            netquantityconsumed = pc.QuantityConsumed;
                        }
                        if(pc.Product2.JDE_Unit_of_Measure_GLB__c != null || pc.Product2.JDE_Unit_of_Measure_GLB__c != BLANKVALUE){
                            PCQuantityUOM = pc.Product2.JDE_Unit_of_Measure_GLB__c;
                        }else{
                            PCQuantityUOM = 'Each';
                        }
                        Integer netquantityconsumedininteger = Integer.valueOf(netquantityconsumed);
                        if(netquantityconsumedininteger != 0){
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsActivityPartsMovement__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+netquantityconsumedininteger+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+PCQuantityUOM+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+pc.Product2.ProductCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+PARTPRICEOVERRIDECODE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSF+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+pc.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).SerialNumber__c)+SerialNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).SerialNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LotNumber__c)+LotNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LotNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).InventoryBranchPlant__c)+pc.ProductItem.Location.Branch_Plant__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).InventoryBranchPlant__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+pc.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PPTNumber__c)+PPTNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PPTNumber__c);
                            xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsActivityPartsMovement__c);
                        }else{
                            xmlBody +=  BLANKVALUE;
                        }
                    }
                }
            }
            if(TimeTrackerMap.get(newWOLI.Id) == NULL){
                xmlBody +=  BLANKVALUE;
            }else{
                for(Time_Tracker__c tc : TimeTrackerMap.get(newWOLI.Id)){
                    if(!tc.Billable__c){
                        Decimal TCShippedQtyInUoM = ((tc.Stop__c.getTime())/1000/60) - ((tc.Start__c.getTime())/1000/60);
                        Long TCShippedQtyInUoMLong = Math.roundToLong(TCShippedQtyInUoM);
                        Integer TCShippedQtyInUoMRoundOff = Integer.valueOf(TCShippedQtyInUoMLong);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).TimeSheetDailyHours__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+TCShippedQtyInUoMRoundOff+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+tc.JDE_Billing_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSF+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+tc.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);  
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+tc.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PPTNumber__c)+PPTNumber+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PPTNumber__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).TimeSheetDailyHours__c);
                    }
                }
            }
            if(ExpenseTrackerMap.get(newWOLI.Id) == NULL){
                xmlBody +=  BLANKVALUE;
            }else{
                for(Expense_Tracker__c ec : ExpenseTrackerMap.get(newWOLI.Id)){
                    if(!ec.Billable__c){
                        Decimal  ItemPriceForLUM = ec.Amount__c>=0?ec.Amount__c * 10000:0;
                        Decimal  ItemExtPrice = ec.Amount__c * ec.Quantity__c * 100;
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsExpenseItem__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+ec.JDE_Billing_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+String.valueOf(ItemPriceForLUM)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+String.valueOf(ItemExtPrice)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCodeSF+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+ec.Non_Billable_Reason_Code__c+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);   
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+ec.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Currency__c)+ec.CurrencyIsoCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Currency__c);
                        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsExpenseItem__c);
                    }
                }
            }
            if(ChargesMap.get(newWOLI.Id) == NULL){
                xmlBody +=  BLANKVALUE;
            }else{
                for(Charges__c charges : ChargesMap.get(newWOLI.Id)){
                    Decimal amount = charges.Amount__c>=0?charges.Amount__c * 10000:0;
                    /*xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FsCharge__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).EDIRecTypeCode__c)+DVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).EDIRecTypeCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ShippedQtyInUoM__c)+ONE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ShippedQtyInUoM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).UoM__c)+EACHVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).UoM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).LineItemNum__c)+charges.Product__r.ProductCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).LineItemNum__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).PriceOveridCode__c)+SINGLESPACEVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).PriceOveridCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemPriceForLUM__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemPriceForLUM__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).ItemExtPrice__c)+ZERO+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ItemExtPrice__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).OrderTypeCode__c)+OrderTypeCode+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).OrderTypeCode__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).NonBillableReasonCode__c)+SINGLESPACEVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).NonBillableReasonCode__c);   
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).BranchPlant__c)+BLANKVALUE+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).BranchPlant__c);   
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+charges.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).FlatRate__c)+String.valueof(amount)+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FlatRate__c);
                    xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).FsCharge__c);*/
                }
            }                     
            xmlBody += string.valueof(MapofInvoiceMetaDataOpenTag.get(InvoiceOpenTagId).Id__c)+newWOLI.Id+string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Id__c);
            xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).Action__c);
        }
        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequest__c);
        xmlBody += string.valueof(MapofInvoiceMetaDataClosedTag.get(InvoiceClosingTagId).ServiceRequestInvoicingInterface__c);
        if(xmlBody.contains(NULLVALUE)){
            FinalXmlBody = xmlBody.replaceAll(NULLVALUE,BLANKVALUE);
        }else{
            FinalXmlBody = xmlBody;
        }
        System.debug('<--Non Billable XML BODY-->'+FinalXmlBody);
        return FinalXmlBody;
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This is the response update for billable.
    @param: workorderId : -work order record id.
    WOLIId : - work order line item record id.
    IntegrationTyperesponse : -type of the integration.
    IntegrationStatusresponse:- status of the integration.
    IntegrationMessage:- response body of the integration.
    @return: NA
    */
    private static void responseupdateforbillable(set<Id> setWOLIIds,String IntegrationTyperesponse,String IntegrationStatusresponse,String IntegrationMessage,Boolean SentForInvoicing,Boolean InvoiceAPICallfromBatch){
        List<sObject> ListSObject = new List<sObject>();
        List<Time_Tracker__c> timetrackerlist = new List<Time_Tracker__c>();
        List<Expense_Tracker__c> ExpenseTrackerlist = new List<Expense_Tracker__c>();
        List<ProductConsumed> ProductConsumedlist = new List<ProductConsumed>();
        List<Charges__c> Chargeslist = new list<Charges__c>();
        set<Id> setWOIds = new set<Id>();
        List<WorkorderLineitem> ListWOLI = [SELECT Id,WorkOrderId,
                                            (SELECT Id,Sent_for_Invoicing__c from Time_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Billable__c =: TRUE AND Sent_for_Invoicing__c =: FALSE),
                                            (SELECT Id,Sent_for_Invoicing__c from Expense_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Billable__c =: TRUE AND Sent_for_Invoicing__c =: FALSE),
                                            (SELECT Id,Sent_for_Invoicing__c from ProductsConsumed where WorkOrderLineItemId IN : setWOLIIds AND Billable__c =: TRUE AND Sent_for_Invoicing__c =: FALSE AND Source__c =: SOURCETRUNK),
                                            (SELECT Id,Sent_for_Invoicing__c from Charges__r where Work_Order_Line_Item__c IN : setWOLIIds AND Sent_for_Invoicing__c =: FALSE)
                                            from WorkorderLineitem where Id IN: setWOLIIds LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
        for(WorkorderLineitem newWOLI : ListWOLI){
            setWOIds.add(newWOLI.WorkOrderId);
            if(!newWOLI.Time_Trackers__r.isEmpty()){
                timetrackerlist.addall(newWOLI.Time_Trackers__r);
            }
            if(!newWOLI.Expense_Trackers__r.isEmpty()){
                ExpenseTrackerlist.addall(newWOLI.Expense_Trackers__r);
            }
            if(!newWOLI.ProductsConsumed.isEmpty()){
                ProductConsumedlist.addall(newWOLI.ProductsConsumed);
            }
            if(!newWOLI.Charges__r.isEmpty()){
                Chargeslist.addall(newWOLI.Charges__r);
            }
        }
        ListSObject.addAll((List<sObject>)(timetrackerlist));
        ListSObject.addAll((List<sObject>)(ExpenseTrackerlist));
        ListSObject.addAll((List<sObject>)(ProductConsumedlist));
        ListSObject.addAll((List<sObject>)(Chargeslist));
        Map<Id,SObject> FinalSObjectMap = new Map<Id,SObject>();
        if(!ListSObject.isEmpty()){
            for(SObject sobj : ListSObject){
                SObject newsobj = sobj.getSObjectType().newSObject(String.valueOf(sobj.get(ID)));
                newsobj.put(ID,sobj.get(ID));
                newsobj.put(SENTFORINVOICINGFIELD,SentForInvoicing);
                FinalSObjectMap.put(newsobj.Id,newsobj);
            }
            if(!FinalSObjectMap.isEmpty()){
                Validation_Rule_Settings__c valsetting = Validation_Rule_Settings__c.getInstance(userinfo.getProfileId());
                valsetting.Charges_AllowSentForInvoicing__c = true;
                valsetting.ExpenseTracker_AllowSentForInvoicing__c = true;
                valsetting.TimeTracker_SentForInvoicing__c = true;
                valsetting.PartTracker_SentForInvoicing__c = true;
                valsetting.ProductConsumed_Skip_ReadOnly__c= true;
                if(!test.isRunningtest()){
                    UPDATE valsetting;
                }
                
                
                Database.Update(FinalSObjectMap.values());
                ////this is used to create a integrationstatus record in work order line item.
                createIntegrationStatusRecord(setWOIds,IntegrationTyperesponse,IntegrationStatusresponse,IntegrationMessage);
                
                Validation_Rule_Settings__c valsetting1 = Validation_Rule_Settings__c.getInstance(userinfo.getProfileId());
                valsetting1.Charges_AllowSentForInvoicing__c = false;
                valsetting1.ExpenseTracker_AllowSentForInvoicing__c = false;
                valsetting1.TimeTracker_SentForInvoicing__c = false;
                valsetting1.PartTracker_SentForInvoicing__c = false;
                valsetting1.ProductConsumed_Skip_ReadOnly__c= false;
                if(!test.isRunningtest()){
                    UPDATE valsetting1;
                }
            }
        }
        ////added as a part of BS-7934
        if(InvoiceAPICallfromBatch && INTEGRATIONERROR.equals(IntegrationStatusresponse)){
                sendEmailtoARO(setWOIds);
        }
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101) - This is the response update for billable.
    @param: workorderId : -work order record id.
    WOLIId : - work order line item record id.
    IntegrationTyperesponse : -type of the integration.
    IntegrationStatusresponse:- status of the integration.
    IntegrationMessage:- response body of the integration.
    @return: NA
    */
    private static void responseupdateforNonbillable(set<Id> setWOLIIds,String IntegrationTyperesponse,String IntegrationStatusresponse,String IntegrationMessage,Boolean SentForInvoicing,Boolean InvoiceAPICallfromBatch){
        List<sObject> ListSObject = new List<sObject>();
        List<Time_Tracker__c> timetrackerlist = new List<Time_Tracker__c>();
        List<Expense_Tracker__c> ExpenseTrackerlist = new List<Expense_Tracker__c>();
        List<ProductConsumed> ProductConsumedlist = new List<ProductConsumed>();
        List<Charges__c> Chargeslist = new list<Charges__c>();
        set<Id> setWOIds = new set<Id>();
        List<WorkorderLineitem> ListWOLI = [SELECT Id,WorkOrderId,
                                            (SELECT Id,Sent_for_Invoicing__c from Time_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Billable__c =:FALSE AND Sent_for_Invoicing__c =: FALSE),
                                            (SELECT Id,Sent_for_Invoicing__c from Expense_Trackers__r where Work_Order_Line_Item__c IN : setWOLIIds AND Billable__c =: FALSE AND Sent_for_Invoicing__c =: FALSE),
                                            (SELECT Id,Sent_for_Invoicing__c from ProductsConsumed where WorkOrderLineItemId IN : setWOLIIds AND Billable__c =: FALSE AND Sent_for_Invoicing__c =: FALSE AND Source__c =: SOURCETRUNK),
                                            (SELECT Id,Sent_for_Invoicing__c from Charges__r where Work_Order_Line_Item__c IN : setWOLIIds AND Sent_for_Invoicing__c =: FALSE)
                                            from WorkorderLineitem where Id IN: setWOLIIds LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
        for(WorkorderLineitem newWOLI : ListWOLI){
            setWOIds.add(newWOLI.WorkOrderId);
            if(!newWOLI.Time_Trackers__r.isEmpty()){
                timetrackerlist.addall(newWOLI.Time_Trackers__r);
            }
            if(!newWOLI.Expense_Trackers__r.isEmpty()){
                ExpenseTrackerlist.addall(newWOLI.Expense_Trackers__r);
            }
            if(!newWOLI.ProductsConsumed.isEmpty()){
                ProductConsumedlist.addall(newWOLI.ProductsConsumed);
            }
            if(!newWOLI.Charges__r.isEmpty()){
                Chargeslist.addall(newWOLI.Charges__r);
            }
        }
        ListSObject.addAll((List<sObject>)(timetrackerlist));
        ListSObject.addAll((List<sObject>)(ExpenseTrackerlist));
        ListSObject.addAll((List<sObject>)(ProductConsumedlist));
        ListSObject.addAll((List<sObject>)(Chargeslist));
        Map<Id,SObject> FinalSObjectMap = new Map<Id,SObject>();
        system.debug('ListSObject:  '+ListSObject);
        if(!ListSObject.isEmpty()){
            for(SObject sobj : ListSObject){
                SObject newsobj = sobj.getSObjectType().newSObject(String.valueOf(sobj.get(ID)));
                newsobj.put(ID,sobj.get(ID));
                newsobj.put(SENTFORINVOICINGFIELD,SentForInvoicing);
                FinalSObjectMap.put(newsobj.Id,newsobj);
            }
           
            if(!FinalSObjectMap.isEmpty()){
                
                Validation_Rule_Settings__c valsetting = Validation_Rule_Settings__c.getInstance(userinfo.getProfileId());
                valsetting.Charges_AllowSentForInvoicing__c = true;
                valsetting.ExpenseTracker_AllowSentForInvoicing__c = true;
                valsetting.TimeTracker_SentForInvoicing__c = true;
                valsetting.PartTracker_SentForInvoicing__c = true;
                valsetting.ProductConsumed_Skip_ReadOnly__c= true;
                UPDATE valsetting;
                
                system.debug('@@@FinalSObjectMap: '+FinalSObjectMap);
                Database.Update(FinalSObjectMap.values());
                system.debug('@@@afdter update ');
                ////this is used to create a integrationstatus record in work order line item.
                createIntegrationStatusRecord(setWOIds,IntegrationTyperesponse,IntegrationStatusresponse,IntegrationMessage);
                
                Validation_Rule_Settings__c valsetting1 = Validation_Rule_Settings__c.getInstance(userinfo.getProfileId());
                valsetting1.Charges_AllowSentForInvoicing__c = false;
                valsetting1.ExpenseTracker_AllowSentForInvoicing__c = false;
                valsetting1.TimeTracker_SentForInvoicing__c = false;
                valsetting1.PartTracker_SentForInvoicing__c = false;
                valsetting1.ProductConsumed_Skip_ReadOnly__c= false;
                UPDATE valsetting1;
            }
            ////added as a part of BS-7934
            if(InvoiceAPICallfromBatch && INTEGRATIONERROR.equals(IntegrationStatusresponse)){
                sendEmailtoARO(setWOIds);
            }
        }
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101)- This method is used for success/error handling part.
    @param: setWOIds :- work order id
    @return: NA
    */
    private static void createIntegrationStatusRecord(set<Id> setWOIds,String IntegrationTyperesponse,String IntegrationStatusresponse,String IntegrationMessage){       
       list<IntegrationStatus__c> IntegrationStatuslist = new list<IntegrationStatus__c>();
        String responsemessage = BLANKVALUE;
        if(IntegrationMessage.contains(XMLHTMLTAG)){
            responsemessage = IntegrationMessage.replace(XMLHTMLTAG,BLANKVALUE);
        }else{
            responsemessage = BLANKVALUE;
        }
        for(Id woid : setWOIds){
            IntegrationStatus__c IntegrationStatus = new IntegrationStatus__c();
            IntegrationStatus.Work_Order__c = woid;
            IntegrationStatus.Integration_Type__c = IntegrationTyperesponse;
            IntegrationStatus.Integration_Status__c = IntegrationStatusresponse;
            if(responsemessage != BLANKVALUE){
               IntegrationStatus.Integration_Response__c = responsemessage.replace(XMLRESPONSETAG, BLANKVALUE);  
            }else{
               IntegrationStatus.Integration_Response__c = responsemessage;                 
            }
            IntegrationStatuslist.add(IntegrationStatus);
        }
        if(!IntegrationStatuslist.isEmpty()){
            Database.Insert(IntegrationStatuslist,false);
        } 
    }
    /*
    @purpose: (R10.0/BS-7934) - This method is used to send an email to ARP team if the invoice fails more than one time in a day.
    @param: MapofIntegrationMessage : - MapofIntegrationMessage
            setofWOIds :- setofWOIds
    @return: NA
    */
    private static void sendEmailtoARO(set<Id> setofWOIds){
       /////Variable Initialization.
        String s;
        Integer j; 
        DateTime TodaysDate = system.now();
        Set<Id> setGroupId = new set<Id>();
        Set<Id> UserId = new Set<Id>();
        List<Workorder> WorkOrderList = [SELECT Id,WorkOrderNumber from workorder where Id IN : setofWOIds LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            list<Group> listGroup = [SELECT Id,Name from Group Where Name =: System.Label.Global_ARO_Team_Support LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            for(Group grp : listGroup){
                setGroupId.add(grp.Id);
            }
            list<GroupMember> listGroupMember = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId IN : setGroupId LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            for(GroupMember gm : listGroupMember){
                UserId.add(gm.UserOrGroupId);
            }
            List<User> ListUser = [SELECT Id,Name,Email from User where Id IN : UserId LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            
            string[]toAdd= new list<string>();
            for(User us : ListUser){
                toAdd.add(us.Email); 
            } 
            messaging.SingleEmailMessage email1=new messaging.SingleEmailMessage();
            
            EmailTemplate et =  [SELECT Id, Name, DeveloperName, IsActive, Description, Subject, 
                                 HtmlValue, Body FROM EmailTemplate where name =: System.Label.Global_ARO_Team_Notification LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
            
            for( j=0;j<WorkOrderList.size();j++){    
                if(j==0){                     
                    s +=FILECOLUMN+BACKSLASHN+ WorkOrderList[j].Id+','+WorkOrderList[j].WorkOrderNumber;
                } else{                    
                    s +=+BACKSLASHN+ WorkOrderList[j].Id+','+WorkOrderList[j].WorkOrderNumber;
                }
            }            
            Blob b=Blob.valueOf(s);
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(TodaysDate+INVOICEFILENAME);
            efa.setBody(b);
            
            
            String plainBody = et.Body;
            plainBody = plainBody.replace(BRACKET, BLANKVALUE);
            String htmlBody = et.HtmlValue;
            htmlBody = htmlBody.replace(BRACKET, BLANKVALUE);
            email1.setToAddresses(toAdd);
            String subject = et.Subject;
            email1.setSubject(subject);
            email1.setHtmlBody(htmlBody);
            email1.setPlainTextBody(plainBody);
            email1.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            messaging.Email[] emails = new messaging.Email[]{email1};
                messaging.sendEmail(emails);
    }
    /*
    @purpose: (R9.0.00/BS-6309/BS-6101)- This is the Invoice wrapper class
    @param: NAdsad
    @return: NAsadas
    */
    global with sharing class InvoiceWrapper{
        public Workorder workorderList{get;set;}
        public list<WorkOrderLineItem> workorderlineitemList{get;set;}
        public Map<Id,WorkOrderLineItem> MapOfWorkOrderLineItem{get;set;}
        public Map<Id,list<Time_Tracker__c>> MapOfTimeTracker{get;set;}
        public Map<Id,list<ProductConsumed>> MapOfProductConsumed{get;set;}
        public Map<Id,list<Expense_Tracker__c>> MapOfExpenseTracker{get;set;}
        public Map<Id,list<Charges__c>> MapOfCharges{get;set;}
        public boolean TTbillableflag{get;set;}
        public boolean PCbillableflag{get;set;}
        public boolean ETbillableflag{get;set;}
        public boolean CHARGESbillableflag{get;set;}
    }
}
