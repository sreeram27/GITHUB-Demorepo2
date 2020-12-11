{
    "type": "VlocityStepCreator",
    "fileName": "VlocityStepCreator_INSUpgrade",
    "plan": {
        "Name": "INS Upgrade",
        "UniqueId": "INS Upgrade"
    },
    "steps": [
        {
            "ExternalId": "INSAddPickListValues",
            "UniqueId": "INSAddPickListValues",
            "Name": "Add Picklist Values",
            "Priority": "None",
            "Tags": "",
            "IsActive": true,
            "Type": "Group",
            "StepFrequency": "Upgrade",
            "Instruction": "<p><span style=\"font-family: sans-serif;\">These upgrade steps are adding new picklist values to existing objects/fields</span></p>",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "",
            "PreCheckMethod": "",
            "PostCheckMethod": "",
            "ExecutionMethod": ""
        },
        {
            "ExternalId": "INSAddPickListValueForBillingFrequency",
            "UniqueId": "INSAddPickListValueForBillingFrequency",
            "Name": "Add Picklist Value to the Billing Frequency Field in the Billing Account Object",
            "Priority": "None",
            "Tags": "BillingAccount",
            "IsActive": true,
            "Type": "Auto",
            "StepFrequency": "Upgrade",
            "Instruction": "",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "ExecutionMethod": "VlocityDiagnosticWizard_ToolingAPI.addPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Semi-Monthly"
                    ],
                    "FieldName": "BillingFrequency__c",
                    "ObjectName": "BillingAccount__c"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "ExecutionMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField"
        },
        {
            "ExternalId": "INSAddPickListValueForAssetTransactionType",
            "UniqueId": "INSAddPickListValueForAssetTransactionType",
            "Name": "Add Picklist Value to the Type Field in the Asset Transaction Object",
            "Priority": "None",
            "Tags": "AssetTransaction",
            "IsActive": true,
            "Type": "Auto",
            "StepFrequency": "Upgrade",
            "Instruction": "",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "ExecutionMethod": "VlocityDiagnosticWizard_ToolingAPI.addPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Initiate Grace Period"
                    ],
                    "FieldName": "Type__c",
                    "ObjectName": "AssetTransaction__c"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "ExecutionMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField"
        },
        {
            "ExternalId": "INSAddPickListValueForAssetBillingFrequency",
            "UniqueId": "INSAddPickListValueForAssetBillingFrequency",
            "Name": "Add Picklist Value to the Billing Frequency Field in the Asset Object",
            "Priority": "None",
            "Tags": "Asset",
            "IsActive": true,
            "Type": "Auto",
            "StepFrequency": "Upgrade",
            "Instruction": "",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {
                    "PreCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "PostCheckMethod": "VlocityDiagnosticWizard_ToolingAPI.checkPicklistFieldValues",
                    "ExecutionMethod": "VlocityDiagnosticWizard_ToolingAPI.addPicklistFieldValues"
                },
                "ToolingAPI": {
                    "fieldValues": [
                        "Semi-Monthly"
                    ],
                    "FieldName": "BillingFrequency__c",
                    "ObjectName": "Asset"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "PostCheckMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField",
            "ExecutionMethod": "VlocityDiagnosticWizardBaseMethods.toolingQueryCustomField"
        },
        {
            "ExternalId": "INSAddPickListValueForAssetStatus",
            "UniqueId": "INSAddPickListValueForAssetStatus",
            "Name": "Add Picklist Value to the Status Field in the Asset Object",
            "Priority": "None",
            "Tags": "Asset",
            "IsActive": true,
            "Type": "Manual",
            "StepFrequency": "Upgrade",
            "Instruction": "<p><span style=\"font-size: 12px; font-family: sans-serif;\">You need to add the following picklist values to the Status Picklist on the Asset object:</span></p><ul><li><span style=\"font-size: 12px; font-family: sans-serif;\">Active</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">Pending Lapse</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">Lapsed</span></li></ul><p><span style=\"font-size: 12px; font-family: sans-serif;\">Here's how:</span></p><ol><li><span style=\"font-size: 12px; font-family: sans-serif;\">Click Check result to open the Object Manager in a new tab.</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">In the Values section, click New.</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">Enter&nbsp;</span><b style=\"font-size: 12px; font-family: sans-serif;\">Active</b><span style=\"font-size: 12px; font-family: sans-serif;\">, </span><b style=\"font-size: 12px; font-family: sans-serif;\">Pending Lapse</b><span style=\"font-size: 12px; font-family: sans-serif;\">&nbsp;and&nbsp;</span><b style=\"font-size: 12px; font-family: sans-serif;\">Lapsed</b><span style=\"font-size: 12px; font-family: sans-serif;\"> into the big text field.</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">Don't select any of the record types below the text field.</span></li><li><span style=\"font-size: 12px; font-family: sans-serif;\">Click Save.</span></li></ol>",
            "AllowCustomInput": false,
            "CustomInputLabel": "",
            "CustomInputValue": "",
            "Options": {
                "jsAction": {},
                "ToolingAPI": {
                    "fieldValues": [
                        "Active",
                        "Pending Lapse",
                        "Lapsed"
                    ],
                    "FieldName": "Status",
                    "ObjectName": "Asset"
                }
            },
            "ArgumentList": "",
            "StepCommand": "",
            "CheckResultUrl": "/lightning/setup/ObjectManager/Asset/FieldsAndRelationships/Status/view",
            "PrecursorStepUniqueId": "",
            "ParentStepUniqueId": "INSAddPickListValues",
            "PreCheckMethod": "",
            "PostCheckMethod": "",
            "ExecutionMethod": ""
        }
    ]
}