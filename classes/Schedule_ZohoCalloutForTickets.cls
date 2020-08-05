Global class Schedule_ZohoCalloutForTickets implements Schedulable{
    
    public static final String RefreshToken = '1000.c6b04e488ed936fd532472ce4b5782ab.1a075813840a39d9a13dd1e1d835f71e';
    public static final String OrgId = '659889223';
    public static final String departmentId='241415000000006907';
    public static final String RedirectUrl = 'https://www.zylker.com/oauthgrant';
    public static final String Clientid = '1000.7C6NJ7V7UT8CZU6GN62J7P0CE0Y92H';
    public static final String ClientSecret = '92dbadc452dc088e56638731d050a07bb8c76c0edd';
    public static final String Scope = 'Desk.search.READ,Desk.tickets.READ';
    
    public static final Date dToday = date.Today();
	public static final Datetime dt = dToday;
    
    public static final String StartDate =label.Zoho_Tickets_Start_Date; //dtoday.year()+'-01-01T00:00:00.000Z';
    public static final String EndDate = dt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
    
    
    Global Void Execute(SchedulableContext sc){
        getAccesstokenFromZoho();
    }
    
    
    @future(callout = true)
    public static void getAccesstokenFromZoho(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint('https://accounts.zoho.com/oauth/v2/token?refresh_token='+RefreshToken+'&client_id='+Clientid+'&client_secret='+ClientSecret+'&scope='+Scope+'&redirect_uri='+RedirectUrl+'&grant_type=refresh_token');
        req.setMethod('POST');
        res = h.send(req);
        system.debug(res.getBody());
        if(res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) 
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) 
                {
                    
                    parser.nextToken();
                    system.debug(parser.getText());
                    getZohoDataAndInsert(parser.getText());
                }
            }
        }
    }
    
    
    public static void getZohoDataAndInsert(String accessToken){
        
        List<Zoho_Ticket__c> ZohoTicketsToBeUpserted = new List<Zoho_Ticket__c>();
        String status ;
        
        
        for(integer i = 1 ; i<=10000 ; i=i+100){
            Http h = new Http();
        	HttpRequest req = new HttpRequest();
        	HttpResponse res = new HttpResponse();
            req.setMethod('GET');
            req.setEndpoint('https://desk.zoho.com/api/v1/tickets/search?from='+i+'&limit=100&departmentId='+departmentId+'&createdTimeRange='+StartDate+','+EndDate);
            
            req.setHeader('orgId',OrgId);
            req.setHeader('Authorization','Zoho-oauthtoken '+accessToken);
            
            system.debug(req.getEndpoint());
            res = h.send(req);
            
            System.debug(res.getStatusCode());
            if(res.getStatusCode() == 200){
                String responseString = res.getBody();
                if(responseString.length() > 0){
                    zoho_Json2Apex DeserializedZohoData = new zoho_Json2Apex();
                    DeserializedZohoData = zoho_Json2Apex.parse(responseString);
                    
                    if(DeserializedZohoData.Data != null){
                        for(zoho_Json2Apex.Data zohoTicket:DeserializedZohoData.Data){
                            Zoho_Ticket__c zohoInfo = new zoho_Ticket__c();
                            
                            zohoInfo.Name = zohoTicket.ticketNumber;
                            zohoInfo.Ticket_ID__c = zohoTicket.id;
                            
                            	
                        	
                            if(zohoTicket.email != null){
                                zohoInfo.Email__c = zohoTicket.email;
                            }
                            if(zohoTicket.subject != null){
                                zohoInfo.Subject__c = zohoTicket.subject;
                            }
                            
                            if(zohoTicket.closedTime != null){
                                
                                Date dtFormat = convertStringToDate(zohoTicket.closedTime);
                                zohoInfo.Closed_Time_D_Fomat__c = dtFormat;
                                
                            }
                            
                            if(zohoTicket.status != null){
                                zohoInfo.Status__c = zohoTicket.status;
                            }
                            
                            if(zohoTicket.classification != null){
                                zohoInfo.classification__c = zohoTicket.classification;
                            }
                            
                            if(zohoTicket.resolution != null){
                                zohoInfo.Resolution__c = zohoTicket.resolution;
                            }
                           
                            
                            if(zohoTicket.createdTime != null){
                                
                                Date dtFormat = convertStringToDate(zohoTicket.createdTime);
                           	 	
                                zohoInfo.Created_Time_D_Format__c = dtFormat;
                            }
                            
                            if(zohoTicket.cf.cf_escalation_type != null){
                                zohoInfo.EscalationType__c = zohoTicket.cf.cf_escalation_type;
                            }
                            
                            if(zohoTicket.cf.cf_ar_version != null){
                                zohoInfo.version__c = zohoTicket.cf.cf_ar_version;
                            }
                            
                            if(zohoTicket.category != null){
                            zohoInfo.Category__c = zohoTicket.category;
                            }
                            
                            if(zohoTicket.modifiedTime != null){
                                
                                Date dtFormat = convertStringToDate(zohoTicket.modifiedTime);
                                zohoInfo.lmt__c = dtFormat;
                                
                            }
                            
                            if(zohoTicket.priority != null){
                                zohoInfo.Priority__c = zohoTicket.priority;
                            }
                            
                            if(zohoTicket.channel != null){
                                zohoInfo.Channel__c = zohoTicket.channel;
                            }
                            
                            if(zohoTicket.responseDueDate != null){
                                
                                Date dtFormat = convertStringToDate(zohoTicket.responseDueDate);
                                zohoInfo.Response_Due_Date_D_Format__c	 = dtFormat;
                                
                            }
                            
                            if(zohoTicket.dueDate != null){
                               
                                Date dtFormat = convertStringToDate(zohoTicket.dueDate);
                                zohoInfo.Due_Date_D_Format__c = dtFormat;
                                
                            }
                            
                            if(zohoTicket.customerResponseTime != null){
                                
                                Date dtFormat = convertStringToDate(zohoTicket.customerResponseTime);
                                zohoInfo.Customer_Response_D_Format__c	 = dtFormat;
                               
                            }
                            
                            if(zohoTicket.department != null){
                                if(zohoTicket.department.id != null){
                                    zohoInfo.Department_ID__c = zohoTicket.department.id;
                                }
                                if(zohoTicket.department.name != null){
                                    zohoInfo.Department_Name__c = zohoTicket.department.name;
                                }
                            }
                            
                            if(zohoTicket.contact != null){
                                if(zohoTicket.contact.firstName != null){
                                    zohoInfo.Contact_Name__c = zohoTicket.contact.firstName;
                                }
                                if(zohoTicket.contact.lastName != null){
                                    zohoInfo.Contact_Name__c += zohoTicket.contact.lastName;
                                }
                                if(zohoTicket.contact.email != null){
                                    zohoInfo.Contact_Email__c = zohoTicket.contact.email;
                                }
                                
                                if(zohoTicket.contact.phone != null){
                                    zohoInfo.Customer_Phone__c = zohoTicket.contact.phone;
                                }
                                
                                if(zohoTicket.contact.account != null){
                                    if(zohoTicket.contact.account.accountName != null){
                                        zohoInfo.Account_Name__c = zohoTicket.contact.account.accountName;
                                    }
                                }
                                
                            }
                            
                            if(zohoTicket.assignee != null){
                                if(zohoTicket.assignee.firstName != null){
                                    zohoInfo.Assignee_Name__c = zohoTicket.assignee.firstName;
                                }
                                if(zohoTicket.assignee.lastName != null){
                                    zohoInfo.Assignee_Name__c += zohoTicket.assignee.lastName;
                                }
                                if(zohoTicket.assignee.email != null){
                                    zohoInfo.Assignee_Email__c = zohoTicket.assignee.email;
                                }
                                
                                if(zohoTicket.assignee.id != null){
                                    zohoInfo.assignee_Id__c = zohoTicket.assignee.id;
                                }
                            }
                            
                            if(zohoInfo != null){
                                ZohoTicketsToBeUpserted.add(zohoInfo);
                            }
                            
                        }
                    }
                    else{
                        System.debug('firstBreak');
                        break;
                    }
                }
                else{
                    System.debug('secondBreak');
                    break;
                }
            }
            else{
                break;
            }
        }
        
         try{
            if(ZohoTicketsToBeUpserted.size() > 0){
                upsert ZohoTicketsToBeUpserted Ticket_ID__c;
                status = 'Success';
            }
    	}
        catch(Exception ex){
            system.debug(ex.getMessage());
            status = 'Failed The error is'+ ex.getMessage();
        }
        
        sendEmailafterCompletionofZohoExecution(status);
    }
    
    
    global Static void sendEmailafterCompletionofZohoExecution(string ResultOfExecution){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new list<string> {label.EmailID_For_GA_and_Jira};
        email.setToAddresses(toAddresses);
        email.setSenderDisplayName('Zoho Schedule Class Exectuion Status');
        email.setSubject('Status'+' '+':'+ResultOfExecution);
        email.setPlainTextBody('zoho data  has been  successfully inserted and The following is the status of Execution of the class'+'Status'+' '+':'+ResultOfExecution +'  '+ 'DATE'+' '+':'+date.today());
        Messaging.sendEmail(new Messaging.singleEmailMessage[]{email});
    }
    
    
    
    public Static String convertDateToMonthFormat(String dateFromZoho){
        String  monthYear;
        String onlyDate = dateFromZoho.subStringBefore('.');
        DateTime SFFormattedDate = (DateTime)Json.deserialize('"'+onlyDate+'"', DateTime.class);
        monthYear = SFFormattedDate.format('MMMM') +' '+ SFFormattedDate.year();
        return monthYear;
    }
    
    public Static Date convertStringToDate(String dateFromZoho){
        String OnlyDate = dateFromZoho.subStringBefore('T');
        Date SFFormattedDate = Date.valueOf(OnlyDate);
        return SFFormattedDate;
    }
}