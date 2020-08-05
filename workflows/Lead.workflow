<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_Contact_form_WebSite</fullName>
        <ccEmails>sales@autorabit.com</ccEmails>
        <description>Email Notification - Contact form (WebSite)</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WebToLead_AutoResponse_Rule</template>
    </alerts>
    <alerts>
        <fullName>Email_Partner_Account_Manages_about_New_Partner_Lead</fullName>
        <ccEmails>partner@autorabit.com</ccEmails>
        <description>Email Partner Account Manages about New Partner Lead</description>
        <protected>false</protected>
        <recipients>
            <recipient>adrian.s@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vivekkumar@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_Template_about_Partner_Lead</template>
    </alerts>
    <alerts>
        <fullName>Lead_is_Converted</fullName>
        <description>Lead is Converted</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Test_Convert</template>
    </alerts>
    <alerts>
        <fullName>New_Lead_Notification</fullName>
        <ccEmails>prashanth.s@autorabit.com</ccEmails>
        <description>New Lead Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Lead_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update</fullName>
        <field>DC_Scheduled_For__c</field>
        <formula>DC_Scheduled_For__c</formula>
        <name>Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SDR</fullName>
        <field>SDR__c</field>
        <formula>$User.FirstName +&apos; &apos;+$User.LastName</formula>
        <name>Update SDR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Activity Creation</fullName>
        <actions>
            <name>Visited_Booth_at_DF_2018</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Lead_Source_Type__c</field>
            <operation>equals</operation>
            <value>DF18</value>
        </criteriaItems>
        <description>Activity Creation on DF18 Leads upload</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AutoRABIT - Lead Conversion Notification</fullName>
        <actions>
            <name>Lead_is_Converted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AutoRABIT RecordType</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.DoNotCall</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AutoRABIT - New Lead Notification</fullName>
        <actions>
            <name>New_Lead_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This Sends an email when New lead is created</description>
        <formula>AND(ISNEW(), RecordType.DeveloperName = &apos;AutoRABIT_RecordType&apos;, ISBLANK(Secondary_Lead_Source__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Partner Account Managers</fullName>
        <actions>
            <name>Email_Partner_Account_Manages_about_New_Partner_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Partner Account Managers when a lead is added as &apos;Partner/Partner Prospect&apos; account types,</description>
        <formula>AND(   
ISCHANGED( Partner_Enterprise__c ),
NOT( PRIORVALUE( Partner_Enterprise__c) = &apos;Partner&apos;), NOT( PRIORVALUE( Partner_Enterprise__c) = &apos;Partner Prospect&apos;), OR (  ISPICKVAL(Partner_Enterprise__c , &quot;Partner&quot;) ,  ISPICKVAL(Partner_Enterprise__c , &quot;Partner Prospect&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email notification to Lead - Contact Form</fullName>
        <actions>
            <name>Email_Notification_Contact_form_WebSite</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web Site</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>AutoRABIT RecordType</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.DoNotCall</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Followup - Contacted OR Demo Performed</fullName>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Contacted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Demo Performed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.DoNotCall</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When a lead status is set to &apos;Contacted&apos; or &apos;Demo Performed&apos; and when we do not get any response from lead for 7 days from the date of contacted or Demo Performed, the lead owner should get a task alert to follow up further with the lead.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lead_Follow_Up_30_days</name>
                <type>Task</type>
            </actions>
            <timeLength>29</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Lead_Follow_Up_7_Days</name>
                <type>Task</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Primary Lead with Dates</fullName>
        <actions>
            <name>Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Dates will be applicable when Primary Lead is selected</description>
        <formula>Primary_Lead__c  &lt;&gt; Null &amp;&amp; ( ISPICKVAL(Status,&apos; DC_Scheduled_On__c &apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update SDR on Discovery Call</fullName>
        <actions>
            <name>Update_SDR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.SDR__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update SDR on Discovery Call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Lead_Follow_Up_30_days</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow up with the Lead and update in the chatter or notes.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead Follow Up_30_days</subject>
    </tasks>
    <tasks>
        <fullName>Lead_Follow_Up_7_Days</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow up with the Lead and update in the chatter or notes.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Lead Follow Up_7_Days</subject>
    </tasks>
    <tasks>
        <fullName>TestTask</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>TestTask</subject>
    </tasks>
    <tasks>
        <fullName>Visited_Booth_at_DF_2018</fullName>
        <assignedToType>owner</assignedToType>
        <description>DF 2018 Leads : SDR/ Sales team to follow up</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Lead.CreatedDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Visited Booth at DF 2018</subject>
    </tasks>
</Workflow>
