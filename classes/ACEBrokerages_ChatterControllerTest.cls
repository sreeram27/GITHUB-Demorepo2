// All test methods in this class can access all data.
@isTest
public class ACEBrokerages_ChatterControllerTest {
 
    static testMethod void test() {
        //Create new expense and insert it into the database        
        CollaborationGroup chatter = new CollaborationGroup();
        chatter.name = 'National Broker';
        chatter.CollaborationType = 'Public';
        insert chatter;

        //Assert the name field and saved expense
        System.assertEquals('National Broker',
                           ACEBrokerages_ChatterController.getFeeds()[0].Name,
                          'Name does not match');
        
    }
  
}