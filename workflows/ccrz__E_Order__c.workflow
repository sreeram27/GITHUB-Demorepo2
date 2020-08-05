<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ccrz__Order_Complete</fullName>
        <description>Order Complete</description>
        <protected>false</protected>
        <recipients>
            <field>ccrz__BuyerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ccrz__Ecommerce/ccrz__CC_Order_Complete</template>
    </alerts>
    <alerts>
        <fullName>ccrz__Order_Confirmation_Email_Template</fullName>
        <description>Order Confirmation Email Template</description>
        <protected>false</protected>
        <recipients>
            <field>ccrz__BuyerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ccrz__Ecommerce/ccrz__CC_Order_Confirm</template>
    </alerts>
    <rules>
        <fullName>ccrz__Order Complete</fullName>
        <actions>
            <name>ccrz__Order_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ccrz__E_Order__c.ccrz__OrderStatus__c</field>
            <operation>equals</operation>
            <value>In Process</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ccrz__Order Confirmation</fullName>
        <actions>
            <name>ccrz__Order_Confirmation_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ccrz__E_Order__c.ccrz__OrderStatus__c</field>
            <operation>equals</operation>
            <value>Order Submitted</value>
        </criteriaItems>
        <description>Order Confirmation when order status is et to &quot;In Process&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
