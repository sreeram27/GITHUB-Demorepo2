<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Renewal_Notification</fullName>
        <description>Renewal Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Renewal_70_Days</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Notification_30_days</fullName>
        <ccEmails>gauravjain9109@gmail.com</ccEmails>
        <description>Renewal Notification 30 days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Renewal_30_Days</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Notification_7_Days</fullName>
        <ccEmails>gauravjain9109@gmail.com</ccEmails>
        <description>Renewal Notification 7 Days</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Renewal_7_Days</template>
    </alerts>
    <fieldUpdates>
        <fullName>Updates_when_RN_sent</fullName>
        <description>To give an exact  idea on exactly how many days ago Renewal Notice Sent to USERS</description>
        <field>Renewal_Notice_Sent__c</field>
        <formula>&quot;70 Days Ago&quot;</formula>
        <name>Updates when RN sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updates_when_RN_sent2</fullName>
        <description>To give an exact  idea on exactly how many days ago Renewal Notice Sent to USERS</description>
        <field>Renewal_Notice_Sent__c</field>
        <formula>&quot;30 Days Ago&quot;</formula>
        <name>Updates when RN sent2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updates_when_RN_sent3</fullName>
        <description>To give an exact  idea on exactly how many days ago Renewal Notice Sent to USERS</description>
        <field>Renewal_Notice_Sent__c</field>
        <formula>&quot;7 Days Ago&quot;</formula>
        <name>Updates when RN sent3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Oppty Name to Account</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewal Notification</fullName>
        <active>false</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>Account.End_Date__c</field>
            <operation>equals</operation>
            <value>NEXT 70 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.End_Date__c</field>
            <operation>equals</operation>
            <value>NEXT 30 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.End_Date__c</field>
            <operation>equals</operation>
            <value>NEXT 7 DAYS</value>
        </criteriaItems>
        <description>Sends notification on Renewal of Subscriptions</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Updates_when_RN_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>X70_Days_to_Renewal</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.End_Date__c</offsetFromField>
            <timeLength>-70</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Notification_30_days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Updates_when_RN_sent2</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>X30_Days_to_Renewal</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Renewal_Notification_7_Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Updates_when_RN_sent3</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>X7_Days_to_Renewal</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>X30_Days_to_Renewal</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.End_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>30 Days to Renewal!</subject>
    </tasks>
    <tasks>
        <fullName>X70_Days_to_Renewal</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-70</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.End_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>70 Days to Renewal</subject>
    </tasks>
    <tasks>
        <fullName>X7_Days_to_Renewal</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.End_Date__c</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>7 Days to Renewal!</subject>
    </tasks>
</Workflow>
