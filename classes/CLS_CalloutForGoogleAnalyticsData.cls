Global class CLS_CalloutForGoogleAnalyticsData implements Schedulable,database.AllowsCallouts {
    //public static String Token;
    public static final Date OnlyDateOfToday  = date.today();
    public static final string sDate = string.valueOf(OnlyDateOfToday.toStartOfMonth());
    public static final string eDate = 'today';
    public static final dateTime todayDate = Date.today();
    public static final Integer month = system.today().month();
    
    
       
    public class jsonData{
        public TotalsForAllResults TotalsForAllResults;
        public List<List<String>> rows;
    }
    
    public Class TotalsForAllResults{
        public String gausers;
        public String ganewUsers;
        public String gasessions;
        public String gabounceRate;
        public String gaavgsessionDuration;
    }
    
    
    Global  void Execute(SchedulableContext SC){
        //String InsertionMessage;
         get_access_token();
        //String dataFromGoogle = getDailyReportGA(sDate,eDate);
        //System.debug(dataFromGoogle);
        //String replaceddate = dataFromGoogle.replaceAll('ga:', 'ga');
        //jsonData analyticsRowData = (jsonData)Json.deserialize(replaceddate, jsonData.Class);
        //system.debug(analyticsRowData);
        //InsertionMessage = InsertGAData(analyticsRowData.TotalsForAllResults,analyticsRowData.rows);
        
        //sendEmailafterCompletionofExecution(InsertionMessage);
        
        
    }
    
    public static void InsertGAData(TotalsForAllResults overAllInfo,List<List<String>> rowsData){
        Map<String,String> MapOfRowData = new Map<String,String>();
        String statusMessage;
        
        system.debug(overAllInfo);
        
        
       List<Google_Analytics__c> ExistingGADataofYesterday =  [select id,Name,Total_Users__c,Unique_Users__c,No_of_Sessions__c,Bounce_Rate__c,Avg_Time__c,Month__c,Direct__c,Referal__c,Paid_Search__c,Organic_Search__c from Google_Analytics__c where Calendar_month(Createddate)=: month and name=:todayDate.format('MMM')+todayDate.year() limit 1];
        
        Google_Analytics__c GADataToBeInserted = new Google_Analytics__c();
        GADataToBeInserted.Name = todayDate.format('MMM')+todayDate.year();
        GADataToBeInserted.Total_Users__c = Decimal.valueOf(OverAllInfo.gausers);
        GADataToBeInserted.Unique_Users__c= Decimal.valueOf(OverAllInfo.ganewUsers);
        GADataToBeInserted.No_of_Sessions__c = Decimal.valueOf(OverAllInfo.gasessions);
        GADataToBeInserted.Bounce_Rate__c= Decimal.valueOf(OverAllInfo.gabounceRate);
        GADataToBeInserted.Avg_Time__c = Decimal.valueOf(OverAllInfo.gaavgsessionDuration);
        GADataToBeInserted.Month__c = date.today();
        
        for(List<String> rows:rowsData){
            MapOfRowData.put(rows[0],rows[1]);
        }
        
        try{
            for(String MapKey : MapOfRowData.keySet()){
                if(MapKey.equalsIgnoreCase('(none)')){
                    GADataToBeInserted.Direct__c = Decimal.valueOf(MapOfRowData.get(MapKey));
                }
                else if(MapKey.equalsIgnoreCase('referral')){
                    GADataToBeInserted.Referal__c = Decimal.valueOf(MapOfRowData.get(MapKey));
                }
                else if(MapKey.equalsIgnoreCase('organic')){
                    GADataToBeInserted.Organic_Search__c = Decimal.valueOf(MapOfRowData.get(MapKey));
                }
                else if(MapKey.equalsIgnoreCase('cpc')){
                    GADataToBeInserted.Paid_Search__c = Decimal.valueOf(MapOfRowData.get(MapKey));
                }
            }
            
            if(ExistingGADataofYesterday.size()>0){
                if(ExistingGADataofYesterday[0].Name == GADataToBeInserted.Name){
                    ExistingGADataofYesterday[0].Total_Users__c = GADataToBeInserted.Total_Users__c;
                    ExistingGADataofYesterday[0].Unique_Users__c = GADataToBeInserted.Unique_Users__c;
                    ExistingGADataofYesterday[0].No_of_Sessions__c = GADataToBeInserted.No_of_Sessions__c;
                    ExistingGADataofYesterday[0].Bounce_Rate__c = GADataToBeInserted.Bounce_Rate__c;
                    ExistingGADataofYesterday[0].Avg_time__c = GADataToBeInserted.Avg_Time__c;
                    ExistingGADataofYesterday[0].Month__c=GADataToBeInserted.Month__c;
                    ExistingGADataofYesterday[0].Direct__c = GADataToBeInserted.Direct__c;
                    ExistingGADataofYesterday[0].Referal__c = GADataToBeInserted.Referal__c;
                    ExistingGADataofYesterday[0].Organic_Search__c =GADataToBeInserted.Organic_Search__c;
                    ExistingGADataofYesterday[0].Paid_Search__c  = GADataToBeInserted.Paid_Search__c;
                    update ExistingGADataofYesterday;
                    statusMessage = 'success';
                }
                
            }
            else{
                insert GADataToBeInserted;
                statusMessage = 'success';
            }
                
                
        }
        Catch(Exception ex){
            statusMessage = ex.getMessage();
        }
        
        sendEmailafterCompletionofExecution(StatusMessage);
        }
        
 
    
    
    
    Global static void getDailyReportGA(String startdate, String EndDate,String Token) {
	
		String dataFromGoogle;
		String replaceddate;
        jsonData analyticsRowData = new jsonData();

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(label.URL_to_get_the_GAData+'&start-date='+startdate+'&end-date='+EndDate+'&metrics=ga:users,ga:newUsers,ga:sessions,ga:bounceRate,ga:avgsessionDuration&dimensions=ga:medium&access_token='+Token);
        req.setMethod('GET');
        req.setHeader('ContentSize','0');
        //System.debug(req);
        if(!Test.isRunningTest())res = h.send(req);
        String response_debug = res.getBody() +' '+ res.getStatusCode();
        //System.debug('Response =' + response_debug );
        if(res.getStatusCode() == 200) {
            integer index = res.getBody().indexOf('"totalsForAllResults"');
            //System.debug('{'+res.getBody().substring(index));
            if(index > 0) {
				dataFromGoogle =  ('{'+res.getBody().substring(index));
			    replaceddate = dataFromGoogle.replaceAll('ga:', 'ga');
			    analyticsRowData = (jsonData)Json.deserialize(replaceddate, jsonData.Class);
				
				
			}
        }
        if(!Test.isRunningTest()){
            InsertGAData(analyticsRowData.TotalsForAllResults,analyticsRowData.rows);
        }
        else{
            String testData =  '{"totalsForAllResults": {"ga:users": "1043","ga:newUsers": "816","ga:sessions": "1207","ga:bounceRate": "19.96685998342999","ga:avgsessionDuration": "93.18558409279204"},"rows":[["(none)","442","367","489","8.793456032719837","111.77096114519428"],["cpc","442","367","489","8.793456032719837","111.77096114519428"],["organic","442","367","489","8.793456032719837","111.77096114519428"],["referral","442","367","489","8.793456032719837","111.77096114519428"]]}';
        	replaceddate = testData.replaceAll('ga:', 'ga');
            analyticsRowData = (jsonData)Json.deserialize(replaceddate,jsonData.class);
            InsertGAData(analyticsRowData.TotalsForAllResults,analyticsRowData.rows);
        }
    }
    
    @future(callOut=true)
    Global static void get_access_token(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setEndpoint(label.Token_Endpoint_for_GoogleAnalytics);
        req.setMethod('POST');
        
        req.setHeader('ContentType','application/x-www-form-urlencoded');
        
        String header = '{"alg":"RS256","typ":"JWT"}';
        String header_encoded = EncodingUtil.base64Encode(blob.valueof(header));
        
        String claim_set = '{"iss":"autorabbit1@salesforce-automation-2020.iam.gserviceaccount.com"';
        claim_set += ',"scope":"https://www.googleapis.com/auth/analytics.readonly"';
        claim_set += ',"aud":"https://accounts.google.com/o/oauth2/token"';
        claim_set += ',"exp":"' + datetime.now().addHours(1).getTime()/1000;
        claim_set += '","iat":"' + datetime.now().getTime()/1000 + '"}';
        
        String claim_set_encoded = EncodingUtil.base64Encode(blob.valueof(claim_set));
        
        String signature_encoded = header_encoded + '.' + claim_set_encoded;
        
        String key = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCjPwqTynAuAM/JoCOJys3kC71KgtqFj4sEEcg2vQeGi9LIGI5psO4fQEIfy93ff6EihO+wyDqdZh7KJlR3XhwkM+C70ZzyX5fR868UOLJ+l7Sci7O27uoHStWLtYdwZeKpYl5Iz6qc2IttGbxqTVqc45DHDQrzeBhim9xLh4dwozZUFlDylDYTy47AhLnTmY40vwnp/8mIxrXtjua6EvKCeWci3zuYWJ+dTk6Z62WVOgKzoFYmwd4fok3WO7zUwfHz7yQB+GBe51xuAjNf1YG843b84wktCOlofILhd6fgXzNYAYdNISeDpbTwjJ4rI3DQ8GDZw3OTgbFYuIFnhHQLAgMBAAECggEAIHGqB39nVi1BHsBd78fHrbgLkeB5z6ucpF1oXkCpWzs01CHVQ/ovCTT7L1iUKxQxkSu8e3T/+UJPgjul8+dXTnalBo79U0peYRK+TBWMnA5IjghR2lyXVIWx9UdJuLP3HVT4ih4DuZJr+23u/W2MQbwUjQrxjzviFM8HNFemOmNUT5yPbTfnQXUjeA527dg04xJTZzdgQzAVEm3rHFDyP5TZUZ8gYfL0+YQYZIehjiepVaBMJov/P/b7LHTIstUyumIqkh59JmvWwU5DCAnWeyq3y7jap8vQmDlleQCNuk3xMXyHLBVaOMxn64il1s0jlwizPf+9oMW+QbzYO3rGYQKBgQDW6fNJOSjASMjNsPx72oJN6/b2kEbvqpxN9vE1sOfsPwWwi2Fa/iMl52rVB0pgj4H+cVoVWk8GsEnp9nnoWyw8WB+kkDOumVD6t1araKAXD+MOOanaE1zVvTVsoQaUikrKUuFuGUtfWaWj3gy6wCeR1/QkbMD/BWbLRLro0dd68QKBgQDCdHA2cooDeawydp8Utk1YeTnJiYGr4oWtMjVp69KghXg3Uc7GddxsHrRndWwCfbmZWjOB0Z1lxg5yeAB3QtlZZdxpZ/WmBSuEQ2pouo6yaicXDNYeKjtPrGr2XUEz0/Qlu/UFwI0S6D5bfETbyHsWQeDQBHezp9heHk6m3fwGuwKBgB8ZxAc4qlkJL2X00tTpjinQl/CeeGV+fxgZQFbQvv9FL4GY6gHM/TEjCCbD41ON8PXtWWf1pbIGGOwuqv2hFAm3hvy9kX0W2s0tcvFjNqefuO/6EEZqvuh/dRe/RcCBMsmMrOrN5kZqJrpMC/OKky9b3QzYYCWHlpSb4aCHnXNBAoGAKUT3D8ctXWF0V11vk8DBF5ba2dgSKj2wKzrttSY0lJbfFbaKEPqwpk258f8sxjaSrmZDajjnk9L9+/NV/fm1EVEZ/1DuBKcyPibkrYdyg5Ed7LlvtAU4g0dPiCvwi6RfO6bxcKAWEL4zhc0Q/ChHX0jqApwAH6PuusLp5GZWd8MCgYEAp/upKW0ksKiW9v27i0oKUxoOJparvDp0CuceYYPnVQvd92RzUuwoKItHTrU9rrA4kNHT816qFGcWII7IKwhEXGMMlWhXEyjMSg2dHg7FhIHQF1tz2WqT0+zrXJV6m4O6I+/Sy5IORqaYG+4tkELJlYvchD3nP1gAZirdM1Fb03I=';
        
        blob private_key = EncodingUtil.base64Decode(key);
        signature_encoded = signature_encoded.replaceAll('=','');
        String signature_encoded_url = EncodingUtil.urlEncode(signature_encoded,'UTF-8');
        blob signature_blob =   blob.valueof(signature_encoded_url);
        
        String signature_blob_string = EncodingUtil.base64Encode(Crypto.sign('RSA-SHA256', signature_blob, private_key));
        
        String JWT = signature_encoded + '.' + signature_blob_string;
        
        JWT = JWT.replaceAll('=','');
        
        String grant_string= 'urn:ietf:params:oauth:grant-type:jwt-bearer';
        req.setBody('grant_type=' + EncodingUtil.urlEncode(grant_string, 'UTF-8') + '&assertion=' + EncodingUtil.urlEncode(JWT, 'UTF-8'));
        res = h.send(req);
        String response_debug = res.getBody() +' '+ res.getStatusCode();
        System.debug('Response =' + response_debug );
        if(res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) 
            {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) 
                {
                    
                    parser.nextToken();
                    getDailyReportGA (sDate,eDate,parser.getText());
                }
            }
        }
        else{
			System.debug('There is problem with the connection:'+res.getStatusCode());
		}
        }
    
    global Static void sendEmailafterCompletionofExecution(string ResultOfExecution){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new list<string> {label.EmailID_For_GA_and_Jira};
        email.setToAddresses(toAddresses);
        email.setSenderDisplayName('Google Analytics Scheduled Class');
        email.setSubject('Status'+' '+':'+ResultOfExecution);
        email.setPlainTextBody('CLS_CalloutForGoogleAnalyticsData has ran successfully and The following is the status of Execution of the class'+'Status'+' '+':'+ResultOfExecution +'  '+ 'DATE'+' '+':'+date.today());
        Messaging.sendEmail(new Messaging.singleEmailMessage[]{email});
    }
    
}