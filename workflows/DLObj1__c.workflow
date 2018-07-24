<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>WorkflowDlObj1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>DLObj1__c.Field1__c</field>
            <operation>equals</operation>
            <value>DL1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
