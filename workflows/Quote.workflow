<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send</fullName>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <ccEmails>accounts@autorabit.com</ccEmails>
        <description>Send Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>Channels</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quotes/Quote_submission_for_Approval_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_after_Approval</fullName>
        <ccEmails>prashanth.s@autorabit.com,</ccEmails>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <description>Send Email after Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quotes/Quote_Order_Form_Approved_VF</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_after_Rejection</fullName>
        <ccEmails>prashanth.s@autorabit.com,</ccEmails>
        <ccEmails>sreekanth.u@autorabit.com</ccEmails>
        <description>Send Email after Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quotes/Quote_Order_Form_Rejected_VF</template>
    </alerts>
    <alerts>
        <fullName>Test</fullName>
        <ccEmails>chandrashekhar.k@autorabit.com</ccEmails>
        <description>Test</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Quotes/Quote_Order_Form_Approved_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Recall_Action</fullName>
        <field>Status</field>
        <literalValue>Needs Review</literalValue>
        <name>Set Recall Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status</fullName>
        <field>Status</field>
        <literalValue>In Review</literalValue>
        <name>Update Quote Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Status_after_Approval</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Update Quote Status after Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Qupte_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Update Qupte Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
