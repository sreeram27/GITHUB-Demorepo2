<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IS_this_PS</fullName>
        <field>Is_this_PS__c</field>
        <literalValue>1</literalValue>
        <name>IS this PS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsProfessional</fullName>
        <field>isProfessional__c</field>
        <literalValue>1</literalValue>
        <name>IsProfessional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Discount_Given</fullName>
        <field>Discount__c</field>
        <formula>1- ( UnitPrice/ ListPrice )</formula>
        <name>Update Discount Given</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_as_Renewal</fullName>
        <field>Is_Renewal_Opportunity__c</field>
        <literalValue>1</literalValue>
        <name>Update as Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>of_Months</fullName>
        <field>of_Months__c</field>
        <name># of Months</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mark as true for isProfessional</fullName>
        <actions>
            <name>IsProfessional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>contains( Product_Name__c,&apos;Services&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Amount Field</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Discount</fullName>
        <actions>
            <name>Update_Discount_Given</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>WFR to update discount percentage of a Product based on Sale price</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Renewal Opportunities</fullName>
        <actions>
            <name>Update_as_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>INCLUDES( Opportunity.Opportunity_Type_New_Renewal_Upsell__c, &apos;Renewal&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update is PS field</fullName>
        <actions>
            <name>IS_this_PS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>of_Months</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>contains</operation>
            <value>Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Is_this_PS__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
