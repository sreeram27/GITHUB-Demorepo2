/** Author       ::: Ranjith Kumar
**  Created      ::: 5th March 2020
**  Purpose      ::: test class for ContactRelationshipsActions,ContactRelationshipHandler,ConstantVariables and ContactRelationshipTrigger.
**  Version      ::: v1
**/
@isTest
public class ContactRelationshipsTest{

    public static testmethod void testData(){
        
        ConstantVariables.groupAdmin='Group Administrator';
        ConstantVariables.billingCon='Billing Contact';
        
        SIC__c SIC = new SIC__c(Name = staticVariableClass.SIC);
        Insert SIC;
        
        Account acc =new Account(
            RecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('LG Prospect').getRecordTypeId(),
            Name = staticVariableClass.AccountName,Account_s_Suppress_Auto_Renewal__c = false,Anthem_Entity__c = staticVariableClass.Entity,
            Region__c= staticVariableClass.Region, Branding__c =staticVariableClass.UniCare,SIC__c = SIC.Id,Group_Size__c =staticVariableClass.size,
            Total_Employees__c =staticVariableClass.emp, HQ_State__c =staticVariableClass.AK, Situs_State__c = staticVariableClass.California,
            Mailing_Address_Same_as_Physical_Address__c = true, BillingStreet = 'Land Mark', BillingPostalCode = '636111',
            BillingCity = 'Banglore', BillingCountry = 'India', BillingState = 'Karnataka', Physical_County__c = '121');
        insert acc;
        
        Contact con=new Contact();
        con.FirstName='testfrname';
        con.LastName='testlrname';
        con.Phone='3456789790';
        con.Email='test@gmail.com';
        con.MailingCity='testmailingcity';
        con.MailingCountry='testMailingCountry';
        con.MailingState='testMailingState';
        con.MailingStreet='test street';
        con.MailingPostalCode='456788';
        con.Fax='4356789';
        insert con;
        
        ContactRelationship__c cr=new ContactRelationship__c();
        cr.Account__c=acc.id;
        cr.Billing_Contact__c=true;
        cr.Contact_Type__c='Billing Contact';
        cr.Contact__c=con.Id;
        insert cr;
        
        ContactRelationship__c cr1=new ContactRelationship__c();
        cr1.Account__c=acc.id;
        cr1.Group_Admin__c=true;
        cr1.Contact_Type__c='Group Administrator';
        cr1.Contact__c=con.Id;
        insert cr1;
        
        ContactRelationship__c cr2=new ContactRelationship__c();
        cr2.Account__c=acc.id;
        cr2.Group_Admin__c=true;
        cr2.Billing_Contact__c=true;
        cr2.Contact_Type__c='Group Administrator';
        cr2.Contact__c=con.Id;
        cr2.Biiling_Contact_and_Group_Admin__c=true;
        insert cr2;
        
        test.startTest();
        cr2.Contact_Type__c='Billing Contact';
        cr2.Group_Admin__c=false;
        cr2.Biiling_Contact_and_Group_Admin__c=false;
        update cr2;
        
        ContactRelationshipHandler crh=new ContactRelationshipHandler();
        
        System.assertEquals(false, cr2.Group_Admin__c);
        
        System.assertEquals(true,cr1.Group_Admin__c);
        System.assertEquals(true,cr.Billing_Contact__c);
        System.assertEquals('Group Administrator',cr1.Contact_Type__c);
        System.assertEquals('Billing Contact',cr.Contact_Type__c);
        System.assertEquals(false,cr2.Biiling_Contact_and_Group_Admin__c);
        
        
        test.stopTest();
        
        
    }
}