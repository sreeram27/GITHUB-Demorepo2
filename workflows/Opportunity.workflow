<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Activate_License_for_Lead</fullName>
        <description>Activate License for Lead</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AutoRABIT_Trial_Initated</template>
    </alerts>
    <alerts>
        <fullName>Closed_Lost_opportunity</fullName>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <ccEmails>pmt@autorabit.com</ccEmails>
        <description>Closed Lost opportunity</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Closed_Lost</template>
    </alerts>
    <alerts>
        <fullName>Closed_Won_Opportunity_Notification</fullName>
        <description>Closed Won Opportunity Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>adrian.s@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jeff.shemano@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.n@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mike.s@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nicole.faulkner@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>roy.s@autorabit.com.sfdc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shoni.h@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vivekkumar@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Closed_Won_Opportunity_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_when_Closed_Won_Opportunity_is_NOT_updated_with_Contract_Date</fullName>
        <description>Email Notification when Closed Won Opportunity is NOT updated with Contract Dates</description>
        <protected>false</protected>
        <recipients>
            <recipient>madeline.h@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Past_Due_Update_Contract_Dates</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_when_Closed_Won_Opportunity_is_updated_with_Contract_Dates</fullName>
        <description>Email Notification when Closed Won Opportunity is updated with Contract Dates</description>
        <protected>false</protected>
        <recipients>
            <recipient>madeline.h@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sulochana@autorabit.com.sfdc</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Closed_Won_opportunity_updated_with_Contract_Dates</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_reminder_for_Sales_Executive_to_fill_out_the_Sales_Order_Form</fullName>
        <description>Email alert reminder for Sales Executive to fill out the Sales Order Form</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Order_Form/Sales_Order_Form_reminder</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Notify_PreSales_when_Trial_is_Expired</fullName>
        <description>Email to Notify PreSales when Trial is Expired</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Final_Activation</template>
    </alerts>
    <alerts>
        <fullName>Final_Week_of_Trial</fullName>
        <description>Final Week of Trial</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Final_Activation</template>
    </alerts>
    <alerts>
        <fullName>First_Week_of_Trial</fullName>
        <description>First Week of Trial</description>
        <protected>false</protected>
        <recipients>
            <field>Contact_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Second_Activation_Email</template>
    </alerts>
    <alerts>
        <fullName>IT_Implementation_Stage_field_Blank</fullName>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <description>IT/Implementation Stage field Blank</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AutoRABIT_Implementation_Questionnaire</template>
    </alerts>
    <alerts>
        <fullName>New_Subs_Activation_Email</fullName>
        <ccEmails>subscriptions@autorabit.com</ccEmails>
        <ccEmails>srinivas.y@autorabit.com</ccEmails>
        <description>New Subs Activation Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>albert.n@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>roja.b@autorabit.com.sfdc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tommy.p@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Subs_Activation/New_Subs_activation</template>
    </alerts>
    <alerts>
        <fullName>QBR</fullName>
        <ccEmails>csg@autorabit.com</ccEmails>
        <description>QBR</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Initiate_QBR</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Oppty_Notification_to_Oppty_Owner</fullName>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <description>Renewal Oppty Notification to Oppty Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Auto_Notification_on_Renewal_Automation</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Subs_Activation_Email</fullName>
        <ccEmails>subscriptions@autorabit.com</ccEmails>
        <ccEmails>srinivas.y@autorabit.com</ccEmails>
        <description>Renewal Subs Activation Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>sree.u@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Subs_Activation/Renewal_Subs_activation1</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_alert_if_Overall_Delay_is_more_than_1_day</fullName>
        <description>Send Email alert if Overall Delay is more than 1 day</description>
        <protected>false</protected>
        <recipients>
            <recipient>sree.u@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Subs_Activation/Subscription_Activation_Request</template>
    </alerts>
    <alerts>
        <fullName>Subs_Activation_Email_Alert</fullName>
        <description>Subs Activation Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>divya.t@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Subs_Activation/Subscription_Activation_Request</template>
    </alerts>
    <alerts>
        <fullName>Upsell_Subs_Activation_Email</fullName>
        <ccEmails>subscriptions@autorabit.com</ccEmails>
        <ccEmails>srinivas.y@autorabit.com</ccEmails>
        <description>Upsell Subs Activation Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>albert.n@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>roja.b@autorabit.com.sfdc</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sree.u@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tommy.p@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Subs_Activation/New_Upsell_Subs_activation1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Amount_Update</fullName>
        <field>Amount</field>
        <formula>Opportunity_Amount__c</formula>
        <name>Amount Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HelperCheckBox_Update</fullName>
        <field>HelperCheckbox__c</field>
        <literalValue>1</literalValue>
        <name>HelperCheckBox_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HelperCheckBox_Update_Renewal</fullName>
        <field>HelperCheckbox__c</field>
        <literalValue>1</literalValue>
        <name>HelperCheckBox_Update_Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HelperCheckBox_Update_Upsell</fullName>
        <field>HelperCheckbox__c</field>
        <literalValue>1</literalValue>
        <name>HelperCheckBox_Update_Upsell</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>No_of_Subs</fullName>
        <field>New_No_of_subs__c</field>
        <formula>Number_of_Product_Subscriptions__c</formula>
        <name>No_of_Subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_Amount_New_Logs_upsell</fullName>
        <field>Oppt_Amout_New_Logs_upsell__c</field>
        <formula>IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;Upsell&apos;),  Opportunity_Amount__c , Null)</formula>
        <name>Oppt Amount New Logs+upsell</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_Amount_New_Update</fullName>
        <description>If Oppurtunity is New Then update Oppt Amount New Field</description>
        <field>Oppt_Amout_New_Logs_upsell__c</field>
        <formula>IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;New Logo&apos;),  Opportunity_Amount__c  ,IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c,&apos;Upsell&apos;),  Opportunity_Amount__c,Null))</formula>
        <name>Oppt Amount New Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_Amount_Renewal_Update</fullName>
        <field>Oppt_Amout_Renewal__c</field>
        <formula>IF( INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;Renewal&apos;), Opportunity_Amount__c , Null)</formula>
        <name>Oppt Amount Renewal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_Amount_Upsell_Update</fullName>
        <field>Oppt_Amout_Upsell__c</field>
        <formula>IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;Upsell&apos;), Opportunity_Amount__c , Null)</formula>
        <name>Oppt Amount Upsell Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppt_Amout_Upsell</fullName>
        <field>Oppt_Amout_Upsell__c</field>
        <formula>IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;Upsell&apos;), Opportunity_Amount__c , Null)</formula>
        <name>Oppt_Amout_Upsell</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal</fullName>
        <field>Oppt_Amout_Renewal__c</field>
        <formula>IF(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c ,&apos;Renewal&apos;),  Opportunity_Amount__c ,Null)</formula>
        <name>Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount_Field</fullName>
        <field>Amount</field>
        <formula>Opportunity_Amount__c</formula>
        <name>Update Amount Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Amount_based_on_Subs_PS</fullName>
        <description>Update Amount based on Subs &amp; PS</description>
        <field>Amount</field>
        <formula>If( isblank( Discount__c), (No_of_Subscriptions__c * 299 *  of_Months__c  +  PS_Hrs__c *250) , (No_of_Subscriptions__c * 299 * of_Months__c  +  PS_Hrs__c *250)- (Discount__c*(No_of_Subscriptions__c * 299 * of_Months__c +  PS_Hrs__c *250)))</formula>
        <name>Update Amount based on Subs &amp; PS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_End_Date</fullName>
        <description>When Opportunity is cloned, add 1 year to Contract End Date.</description>
        <field>Contract_End_Date__c</field>
        <formula>DATE(
YEAR(Contract_End_Date__c)+1,
MONTH(Contract_End_Date__c),
DAY(Contract_End_Date__c)
)</formula>
        <name>Update Contract End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Start_Date</fullName>
        <description>When Opportunity is cloned, add 1 year to Contract Start Date.</description>
        <field>Contract_Start_Date__c</field>
        <formula>DATE(
YEAR(Contract_Start_Date__c)+1,
MONTH(Contract_Start_Date__c),
DAY(Contract_Start_Date__c)
)</formula>
        <name>Update Contract Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Curret_Subs</fullName>
        <field>Current_Subs__c</field>
        <formula>Total_Subs_Except_Vault_T_E__c</formula>
        <name>Update Curret Subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsNew_to_True</fullName>
        <field>isNew__c</field>
        <literalValue>1</literalValue>
        <name>Update IsNew to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsRenewal_to_True</fullName>
        <field>isRenewal__c</field>
        <literalValue>1</literalValue>
        <name>Update IsRenewal to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsUpsell_to_True</fullName>
        <field>isUpsell__c</field>
        <literalValue>1</literalValue>
        <name>Update IsUpsell to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opp_owner</fullName>
        <field>OwnerId</field>
        <lookupValue>sree.u@autorabit.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Opp owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Renewal_No_of_subs</fullName>
        <field>Renewal_No_of_subs__c</field>
        <formula>Number_of_Product_Subscriptions__c</formula>
        <name>Update Renewal No of subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Negotiation_Set_Date</fullName>
        <description>Update Stage &quot;Negotiation&quot; Set Date</description>
        <field>Stage_Negotiation_Set_Date__c</field>
        <formula>now()</formula>
        <name>Update Stage &quot;Negotiation&quot; Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_PriorValue_on_Oppty</fullName>
        <description>Update Stage PriorValue on Oppty</description>
        <field>PriorStage__c</field>
        <formula>text(priorvalue(StageName))</formula>
        <name>Update Stage PriorValue on Oppty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Proposal_Set_Date</fullName>
        <description>Update Stage &quot;Proposal&quot; Set Date</description>
        <field>Stage_Proposal_Set_Date__c</field>
        <formula>now()</formula>
        <name>Update Stage &quot;Proposal&quot; Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Trial_completed_Set_Date</fullName>
        <description>Update Stage &quot;Trial completed&quot; Set Date</description>
        <field>Stage_Trial_completed_Set_Date__c</field>
        <formula>now()</formula>
        <name>Update Stage &quot;Trial completed&quot; Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Field</fullName>
        <field>StageName</field>
        <literalValue>Trial Expired</literalValue>
        <name>Update Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Total_Subs</fullName>
        <field>Total_Subs__c</field>
        <formula>Number_of_Product_Subscriptions__c</formula>
        <name>Update Total Subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_days_in_Negotiation</fullName>
        <description>Update &apos;# of days in Negotiation&apos;</description>
        <field>of_days_in_Negotiation__c</field>
        <formula>today() - datevalue( Stage_Negotiation_Set_Date__c )</formula>
        <name>Update &apos;# of days in Negotiation&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_days_in_PG</fullName>
        <description>Update &apos;# of days in Playground&apos;</description>
        <field>days_in_Playground__c</field>
        <formula>today() - datevalue( Stage_Playground_Set_Date__c )</formula>
        <name>Update &apos;# of days in Playground&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_days_in_Playground</fullName>
        <field>Stage_Playground_Set_Date__c</field>
        <formula>now()</formula>
        <name>Update Playground Set Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_days_in_Proposal</fullName>
        <description>Update &apos;# of days in Proposal&apos;</description>
        <field>of_days_in_Proposal__c</field>
        <formula>today() - datevalue( Stage_Proposal_Set_Date__c )</formula>
        <name>Update &apos;# of days in Proposal&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_of_days_in_Trial_Completed</fullName>
        <description>Update &apos;# of days in Trial Completed&apos;</description>
        <field>of_days_in_Trail_Completed__c</field>
        <formula>today() - datevalue( Stage_Trial_completed_Set_Date__c )</formula>
        <name>Update &apos;# of days in Trial Completed&apos;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upsell_Renewal</fullName>
        <description>If Opportunity Amount field is Upsell + Renewal then update this field</description>
        <field>Oppt_Amout_Renewal__c</field>
        <formula>IF(Renewal__c==true,  Opportunity_Amount__c  ,IF( Upsell__c ==true,  Opportunity_Amount__c  ,Null) )</formula>
        <name>Upsell + Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upsell_Renewal_r</fullName>
        <field>Oppt_Amout_Renewal__c</field>
        <formula>IF( Upsell__c ==true,  Opportunity_Amount__c , Null)</formula>
        <name>Upsell + Renewal_r</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upsell_subs</fullName>
        <field>Upsell_subs__c</field>
        <formula>IF( Renewal_No_of_subs__c ==0, New_No_of_subs__c ,  Number_of_Product_Subscriptions__c )</formula>
        <name>Upsell subs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>When_Trial_End_Date_is_Reached</fullName>
        <field>StageName</field>
        <literalValue>Trial Expired</literalValue>
        <name>When Trial End Date is Reached</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert When Contract Dates are Updated for Closed Won Opportunity</fullName>
        <actions>
            <name>Email_Notification_when_Closed_Won_Opportunity_is_updated_with_Contract_Dates</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email notifications when contract Dates are updated for a closed won opportunities</description>
        <formula>OR( AND(  OR( TEXT(StageName) = &quot;Closed Won&quot; , TEXT(StageName) = &quot;Closed Won-Implementation Incomplete&quot;),  OR (  ISNEW() &amp;&amp; NOT(ISBLANK( Contract_Start_Date__c )) &amp;&amp; NOT( ISBLANK(Contract_End_Date__c )) ) ), AND(  OR( TEXT(StageName) = &quot;Closed Won&quot; , TEXT(StageName) = &quot;Closed Won-Implementation Incomplete&quot;),  OR ( ISCHANGED( Contract_Start_Date__c ), ISCHANGED( Contract_End_Date__c ))  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AutoRABIT - Trial Expiry</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Evaluation_End_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_to_Notify_PreSales_when_Trial_is_Expired</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Evaluation_End_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AutoRABIT -Trial Initiated</fullName>
        <actions>
            <name>Activate_License_for_Lead</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Trial Initiated</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AutoRABIT- First Week of Trial</fullName>
        <actions>
            <name>First_Week_of_Trial</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>Evaluation_Start_Date__c  + 7=TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Closed Lost</fullName>
        <actions>
            <name>Closed_Lost_opportunity</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.HelperCheckbox__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IT%2FImplementation Stage Same from last 2 weeks</fullName>
        <actions>
            <name>IT_Implementation_Stage_field_Blank</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.IT_Implementation_Stage__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify When Opportunity is Closed Won</fullName>
        <actions>
            <name>Closed_Won_Opportunity_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email alert when a new or upsell opportunity becomes closed won.</description>
        <formula>AND( OR(INCLUDES( Opportunity_Type_New_Renewal_Upsell__c , &apos;New Logo&apos;), INCLUDES( Opportunity_Type_New_Renewal_Upsell__c , &apos;Upsell&apos;)), OR( AND (ISCHANGED(StageName), IsWon, NOT(PRIORVALUE(IsWon)) ), AND ( ISNEW(), IsWon) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Oppty Amt to Amt</fullName>
        <actions>
            <name>Amount_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Opportunity_Amount__c  &gt; 0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Overall Delay Workflow</fullName>
        <actions>
            <name>Send_Email_alert_if_Overall_Delay_is_more_than_1_day</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Overall_Delay__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Past Due%3A Closed Won Opportunity WITH OUT Contract Dates</fullName>
        <active>true</active>
        <description>Closed won Opportunity without Contract dates for over 24 hrs.</description>
        <formula>AND( OR( TEXT( StageName )  = &apos;Closed Won&apos;,  TEXT( StageName ) = &apos;Closed Won Implementation-incomplete&apos;), OR(  ISBLANK( Contract_Start_Date__c ) ,  ISBLANK( Contract_End_Date__c )  ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Notification_when_Closed_Won_Opportunity_is_NOT_updated_with_Contract_Date</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>IF(  CloseDate &gt; PRIORVALUE( CloseDate ),  IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) ,  TRUE,  FALSE),  FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>QBR</fullName>
        <actions>
            <name>QBR</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won-Implementation Incomplete</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewal subs Activation</fullName>
        <actions>
            <name>Renewal_Subs_Activation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_IsRenewal_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Won-Implementation Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Type_New_Renewal_Upsell__c</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Number_of_Product_Subscriptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.isRenewal__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rule for Sub Activation Email Alert</fullName>
        <actions>
            <name>Renewal_Subs_Activation_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>OR(  AND (ISCHANGED(StageName), IsWon,   NOT(PRIORVALUE(IsWon)) ),  AND ( ISNEW(), IsWon) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sales Order Form reminder</fullName>
        <actions>
            <name>Email_alert_reminder_for_Sales_Executive_to_fill_out_the_Sales_Order_Form</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Please_fill_out_Sales_Order_Form</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>This workflow rule is used to remind the sales person to fill out the Sales Order Form through email and task alerts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update %23 of days in Negotiation</fullName>
        <actions>
            <name>Update_of_days_in_Negotiation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Stage_Negotiation_Set_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PriorStage__c</field>
            <operation>equals</operation>
            <value>Negotiation</value>
        </criteriaItems>
        <description>Update # of days in Negotiation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update %23 of days in Playground</fullName>
        <actions>
            <name>Update_of_days_in_PG</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Stage_Playground_Set_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PriorStage__c</field>
            <operation>equals</operation>
            <value>Playground</value>
        </criteriaItems>
        <description>Update # of days in Playground</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update %23 of days in Proposal</fullName>
        <actions>
            <name>Update_of_days_in_Proposal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Stage_Proposal_Set_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PriorStage__c</field>
            <operation>equals</operation>
            <value>Proposal</value>
        </criteriaItems>
        <description>Update # of days in Proposal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update %23 of days in Trail Completed</fullName>
        <actions>
            <name>Update_of_days_in_Trial_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Stage_Trial_completed_Set_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PriorStage__c</field>
            <operation>equals</operation>
            <value>Trial Completed</value>
        </criteriaItems>
        <description>Update # of days in Trail Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Amount on Opportunity based on Subs %26 PS</fullName>
        <actions>
            <name>Update_Amount_based_on_Subs_PS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.No_of_Subscriptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Amount on Opportunity based on Subs &amp; PS</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contract Dates for a Cloned Opportunity Record</fullName>
        <actions>
            <name>Update_Contract_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Contract_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Rule to update Contract Start and End Dates for opportunity that is cloned.</description>
        <formula>ISCLONE()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Curret Subs</fullName>
        <actions>
            <name>Update_Curret_Subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCLONE()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Negotiation Set Date</fullName>
        <actions>
            <name>Update_Stage_Negotiation_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Negotiation Set Date</description>
        <formula>ISCHANGED( StageName ) &amp;&amp; Ispickval(StageName, &apos;Negotiation&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opp owner based on opp source field</fullName>
        <actions>
            <name>Update_Opp_owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Source_OLD__c</field>
            <operation>equals</operation>
            <value>Partner Referral</value>
        </criteriaItems>
        <description>Updates the opportunity owner if partner referral is selected as the opportunity source.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Oppt Amount New</fullName>
        <actions>
            <name>Oppt_Amount_New_Logs_upsell</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppt_Amount_New_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Oppt_Amout_Upsell</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Playground Set Date</fullName>
        <actions>
            <name>Update_of_days_in_Playground</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Playground Set Date</description>
        <formula>ISCHANGED( StageName ) &amp;&amp; Ispickval(StageName, &apos;Playground&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update PriorStage value</fullName>
        <actions>
            <name>Update_Stage_PriorValue_on_Oppty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update prior  Stage of an Oppty</description>
        <formula>ischanged(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Proposal set Date</fullName>
        <actions>
            <name>Update_Stage_Proposal_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Proposal set Date</description>
        <formula>ISCHANGED( StageName ) &amp;&amp; Ispickval(StageName, &apos;Proposal&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Renewal_No_of_subs</fullName>
        <actions>
            <name>Update_Renewal_No_of_subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISCLONE() , INCLUDES( Opportunity_Type_New_Renewal_Upsell__c , &apos;Renewal&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Total Subs</fullName>
        <actions>
            <name>Update_Total_Subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Number_of_Product_Subscriptions__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Trail Completed Set Date</fullName>
        <actions>
            <name>Update_Stage_Trial_completed_Set_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update Trail Completed Set Date</description>
        <formula>ISCHANGED( StageName ) &amp;&amp; Ispickval(StageName, &apos;Trial Completed&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Upsell_subs</fullName>
        <actions>
            <name>Upsell_subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISCLONE() , INCLUDES( Opportunity_Type_New_Renewal_Upsell__c , &apos;Upsell&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update no of subs when it is new</fullName>
        <actions>
            <name>No_of_Subs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Type_New_Renewal_Upsell__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Upsell subs Activation</fullName>
        <actions>
            <name>Upsell_Subs_Activation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_IsUpsell_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Won-Implementation Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Type_New_Renewal_Upsell__c</field>
            <operation>equals</operation>
            <value>Upsell</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.isUpsell__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Number_of_Product_Subscriptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>subs Activation</fullName>
        <actions>
            <name>New_Subs_Activation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_IsNew_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Closed Won-Implementation Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Number_of_Product_Subscriptions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Type_New_Renewal_Upsell__c</field>
            <operation>equals</operation>
            <value>New Logo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.isNew__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Please_fill_out_Sales_Order_Form</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please go to the opportunity the task is assigned to and fill out the Sales Order Form.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please fill out Sales Order Form</subject>
    </tasks>
</Workflow>
