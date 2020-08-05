<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Trigger Task for Next discussion date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>TimeLog__c.Next_Discussion_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TimeLog__c.CreatedById</field>
            <operation>equals</operation>
            <value>Prashanth Samudrala</value>
        </criteriaItems>
        <description>Trigger Task for Next discussion date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
