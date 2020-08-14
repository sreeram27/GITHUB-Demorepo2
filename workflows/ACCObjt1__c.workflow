<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>QuoteLineItem</fullName>
        <active>true</active>
        <criteriaItems>
            <field>User.AboutMe</field>
            <operation>startsWith</operation>
            <value>s</value>
        </criteriaItems>
        <description>test 1234</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
