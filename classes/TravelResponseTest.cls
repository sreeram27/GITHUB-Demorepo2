@isTest
public class TravelResponseTest {

    @isTest
    static void testTravelResponse(){
        TravelResponse tr = new TravelResponse();
        List <String> strDestination = new List <string> ();
        List <String> strOrigin = new List <string> ();
        List <TravelResponse.ElementObject> tstElemList = New List <TravelResponse.ElementObject>();
        strDestination.add('Atlanta');
        strDestination.add('New York');
        strOrigin.add('Chicago');
        strOrigin.add('New Jersey');
        
               
        tr.destination_addresses = strDestination;
        tr.origin_addresses = strOrigin;
        String strText = 'Test';
        Integer intValue = 10;
        Integer intValue1 = 11;
        TravelResponse.ResultObject tstResultObj= New TravelResponse.ResultObject(strText, intValue);
        TravelResponse.ResultObject tstResultObj1= New TravelResponse.ResultObject(strText, intValue1);
        TravelResponse.ElementObject tstElementObj = new TravelResponse.ElementObject();
        tstElementObj.distance = tstResultObj;
        tstElementObj.duration=tstResultObj1;
        tstElemList.add(tstElementObj);
        TravelResponse.RowObject tstRowObj = New TravelResponse.RowObject();
        tstRowObj.elements = tstElemList;
        
        
    }
}