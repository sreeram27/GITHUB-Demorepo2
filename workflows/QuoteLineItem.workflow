<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Discount_Given_on_Quote_Line_Item</fullName>
        <field>Discount_Given__c</field>
        <formula>1 - (UnitPrice/PricebookEntry.UnitPrice)</formula>
        <name>Update Discount Given on Quote Line Item</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Discount Given on Quote Line Item</fullName>
        <actions>
            <name>Update_Discount_Given_on_Quote_Line_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>QuoteLineItem.UnitPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
