<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sales_Order_Form_Approved</fullName>
        <ccEmails>accounts@autorabit.com, sulochana@autorabit.com</ccEmails>
        <description>Sales Order Form Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Order_Form/Sales_Order_Form_ApprovedHTML</template>
    </alerts>
    <alerts>
        <fullName>Sales_Order_Form_Rejected</fullName>
        <ccEmails>sulochana@autorabit.com, accounts@autorabit.com</ccEmails>
        <description>Sales Order Form Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Order_Form/Sales_Order_Form_RejectedHTML</template>
    </alerts>
    <alerts>
        <fullName>Sales_Order_Form_Submission</fullName>
        <ccEmails>prashanth.s@autorabit.com</ccEmails>
        <description>Sales Order Form Submission</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Sales_Order_Form/Sales_Order_Form_submission_for_ApprovalHTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Sales_order_form_Field_update</fullName>
        <description>Sales order form Field gets automatically updated to &apos;Approved&apos; once the record has been approved.</description>
        <field>Sales_Order_Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Sales order form Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>InProgress_Sales_order_form_Field_update</fullName>
        <description>Sales order form Field gets automatically updated to &apos;In Progress&apos; once the form has been submitted for approval.</description>
        <field>Sales_Order_Form_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>InProgress Sales order form Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Sales_order_form_Field_update</fullName>
        <description>Sales order form Field gets updated to &apos;Rejected&apos; when the record has been rejected.</description>
        <field>Sales_Order_Form_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rejected Sales order form Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
