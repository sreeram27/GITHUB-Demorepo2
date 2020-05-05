<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>WorkFlowRule1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Obj5__c.Name</field>
            <operation>notEqual</operation>
            <value>Obj4</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WorkFlowRule2</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Obj5__c.Name</field>
            <operation>notEqual</operation>
            <value>OBJ4</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
