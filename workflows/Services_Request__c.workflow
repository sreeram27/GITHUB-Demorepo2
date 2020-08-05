<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_ES_Team_when_a_new_Service_Request_Raised</fullName>
        <ccEmails>servicesrequests@autorabit.com</ccEmails>
        <description>Notify ES Team when a new Service Request Raised</description>
        <protected>false</protected>
        <recipients>
            <recipient>albert.n@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jessica.n@autorabit.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Service_Request_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Sales_Team_when_ES_Teams_updates_AR_Status</fullName>
        <ccEmails>servicesrequests@autorabit.com</ccEmails>
        <description>Notify Sales Team when ES Teams updates AR Status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ES_Team_Notification_to_Sales_Team</template>
    </alerts>
    <rules>
        <fullName>ES Team Notification to Sales Team</fullName>
        <actions>
            <name>Notify_Sales_Team_when_ES_Teams_updates_AR_Status</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Sales Team when  ES Team updates the service request status.</description>
        <formula>AND(
ISCHANGED(SR_Status__c ),  ISPICKVAL( SR_Status__c,  &apos;3 - Provided to Sales&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify ES Team when a new service request is raised</fullName>
        <actions>
            <name>Notify_ES_Team_when_a_new_Service_Request_Raised</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify ES Team when a new service request is submitted.</description>
        <formula>CreatedDate =  LastModifiedDate</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
