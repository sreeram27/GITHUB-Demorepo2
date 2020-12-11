window.ModalManager = function (component, AppConfig, ecId, Localization) {
    let NamespaceService = AppConfig.NamespaceService;
    let DatabaseService = typeof (AppConfig.GlobalActions.getDatabaseService) === 'undefined' ? {} : AppConfig.GlobalActions.getDatabaseService(NamespaceService);

 function ModalAction (ecId) {
        this.Type = {};
        this.Salesforce = {};
        this.Salesforce.sourceId = ecId;
        this.Fields = {};
        this.Collection = {};
        this.SaveOptions = {};
        this.SaveOptions.enabled = true;
        this.ChildActions = [];
        this.CallBackAction = {};
        this.recordWrapper = {};
        this.next = null;
        this.previous = null;
    }
    
    ModalAction.prototype.disableSave = function(component, SaveOptionValue) {
            if (!this.SaveOptions || this.SaveOptions == null) return;
            component.set("v.SaveOptionsEnabled",SaveOptionValue);
    };     
    
    const buildDefaultModalAction = function (ecId) {
        return new ModalAction(ecId);
    };
 
    const generateSuccessMessage = function(title) {
        return Localization.labels['EnvelopeConfigurationSaveSuccess'].replace('{0}', title);
    };

    const buildModalAction = function (actionSource, event) {
        switch (actionSource) {
            //Recipient Modal Actions
        case 'crl_recipient':
            return getCRLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_crl_recipient':
            return getCRLModalAction(AppConfig, 'EDIT', ecId, event, component);
            //Salesforce Refrences (Objects & CRCL)
        case 'crcl_recipient':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'add_user':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'add_contact':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'add_lead':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_user':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_contact':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_lead':
            return getCRCLModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_crcl_recipient':
            return getCRCLModalAction(AppConfig, 'EDIT', ecId, event, component);
        case 'add_sg':
            return getSGModalAction(AppConfig, ecId, event, component);
            //Document Modal Actions
        case 'file_doc':
            return getFileUploadModalAction(AppConfig, ecId, event, component);
        case 'dst_doc':
            return getDSTModalAction(AppConfig, ecId, event, component);
            //Role Mapping Modal Actions
        case 'ccrm_map':
            return getCCRMModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_ccrm_map':
            return getCCRMModalAction(AppConfig, 'EDIT', ecId, event, component);
        case 'cctm_map':
            return getCCTMModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_cctm_map':
            return getCCTMModalAction(AppConfig, 'EDIT', ecId, event, component);
        case 'ccnm_map':
            return getCCNMModalAction(AppConfig, 'NEW', ecId, event, component);
        case 'edit_ccnm_map':
            return getCCNMModalAction(AppConfig, 'EDIT', ecId, event, component);
            //Layout Modal Actions
        case 'add_layout':
            return getLayoutAssignModalAction(AppConfig, ecId, event, component);
        case 'manage_layouts':
            return getLayoutManageModalAction(AppConfig, ecId, event, component);
            //View resources (DocuSign Templates & Salesforce Files)
        case 'view_dst':
            return getDocuSignResourceModalAction(AppConfig, ecId, event, component);
        case 'view_file':
            return getSalesforceResourceModalAction(AppConfig, ecId, event, component);
        }
    };

    const getCRLModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'CRL';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = recipientInContext;
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"]; 
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getAddUserModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'User';
        ModalAction.Header = 'Select User';
        return ModalAction;
    };

    const getAddLeadModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Lead';
        ModalAction.Header = 'Select Lead';
        return ModalAction;
    };

    const getAddContactModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Contact';
        ModalAction.Header = 'Select Contact';
        return ModalAction;
    };

    const getAddReferenceRecipientModalAction = function (AppConfig, type, objectType, ecId, data, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        switch (objectType) {
        case 'User':
            ModalAction.getAddUserModalAction(ModalAction);
        case 'Lead':
            ModalAction.getAddLeadModalAction(ModalAction);
        case 'Contact':
            ModalAction.getAddContactModalAction(ModalAction);
        }

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.Id = recipientInContext;
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    let getSigningGroupModalAction = function (AppConfig, type, ecId, data, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Signing Group';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Signing Group';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.Id = recipientInContext;
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['AddSigningGroup'];
        ModalAction.SaveOptions.enabled = false;
        return ModalAction;
    };

    const getCRCLModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'CRCL';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Salesforce.sourceId = ecId;
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = recipientInContext;
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.BaseObject = AppConfig.BaseObject;

        } else if (type === 'NEW') {
            ModalAction.Header = 'Add Salesforce Refrence';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
            ModalAction.Salesforce.BaseObject = AppConfig.BaseObject;
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCRMModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCRM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Role Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Salesforce Role';
        ModalAction.Fields.MapValue = 'DocuSign Role';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.Mappings.CCRM);
        } else if (type === 'NEW') {
            ModalAction.Header = Localization.labels['NewRoleMapping'];
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newMapping(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCTMModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCTM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Type Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Role';
        ModalAction.Fields.MapValue = 'Type';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.Mappings.CCTM);
        } else if (type === 'NEW') {
            ModalAction.Header = Localization.labels['NewTypeMapping'];
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newMapping(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCNMModalAction = function (AppConfig, type, ecId, event, component) {
        ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCTM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Note Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Role';
        ModalAction.Fields.MapValue = 'Note';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.CCNM);
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Role Mapping';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getDSTModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Document';
        ModalAction.Type.Variation = 'DSTemplate';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'DocuSign Template';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'DST';
        ModalAction.Header = 'Select DocuSign Template';
        ModalAction.Salesforce.Order = AppConfig.Documents === undefined ? 1 : AppConfig.Documents.length + 1;
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=DST';
        ModalAction.SaveOptions.label = Localization.labels['AddTemplate'];
        ModalAction.SaveOptions.enabled = false;
        ModalAction.recordWrapper = DatabaseService.newDocument(AppConfig.Documents.length + 1, ModalAction.Type.Variation, ecId);

        return ModalAction;
    };

    const getSGModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'SG';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Signing Group';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.Action = 'SG';
        ModalAction.Header = 'Select DocuSign Signing Group';
        ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=SG';
        ModalAction.SaveOptions.label = 'Add Signing Group';
        ModalAction.SaveOptions.enabled = false;

        return ModalAction;
    };

    const getFileUploadModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Document';
        ModalAction.Type.Variation = 'File Upload';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'File Upload';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'New';
        ModalAction.Header = 'File Upload';
        ModalAction.SaveOptions.enabled = false;
        ModalAction.Salesforce.Order = AppConfig.Documents === undefined ? 1 : AppConfig.Documents.length + 1;
        ModalAction.recordWrapper = DatabaseService.newDocument(AppConfig.Documents.length + 1, ModalAction.Type.Variation, ecId);

        return ModalAction;
    };

    const getLayoutAssignModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Object Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = true;

        return ModalAction;
    };

    const getClassicLayoutAssignModalAction = function (ecId, previous) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Classic Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT&Type=Classic';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = false;
        ModalAction.previous = previous;

        return ModalAction;
    };

    const getDeleteLayoutAction = function (layoutKey, layoutId, ecId) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Delete Layout';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Delete Layout';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.Action = 'DeleteLayout';
        ModalAction.Header = 'Delete Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=ButtonDelete&LayoutKey=' + layoutKey + '&LayoutId=' + layoutId;
        ModalAction.SaveOptions.label = Localization.labels['Confirm'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getLightningLayoutAssignModalAction = function (ecId, previous) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Lightning Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT&Type=Lightning';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = false;
        ModalAction.previous = previous;
        return ModalAction;
    };

    const getLayoutManageModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Manage';
        ModalAction.Salesforce.sObject = 'EnvelopeConfiguration__c';
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Object Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT';
        ModalAction.Collection.Layouts = AppConfig.Layouts;
        ModalAction.next = getDeleteLayoutAction;
        ModalAction.ChildActions.push({
            key: 'Add Classic Button',
            value: getClassicLayoutAssignModalAction(ecId, ModalAction)
        }, {
            key: 'Add Lightning Button',
            value: getLightningLayoutAssignModalAction(ecId, ModalAction)
        });        
        return ModalAction;
    };

    const getDocuSignResourceModalAction = function (AppConfig, ecId, event, component) { //TODO
        return null;
    };

    const getSalesforceResourceModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Salesforce File';
        ModalAction.Type.Variation = 'Salesforce Resource';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Salesforce File';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'Resource';
        ModalAction.Header = 'View Salesforce File';
        ModalAction.Salesforce.Id = event.target.getAttribute('data-sfid');

        return ModalAction;
    };

    const resetModal = function (ecId, component, data) {
        component.set("ModalAction", buildDefaultModalAction(ecId, data));
        toggleClassInverse(component, 'viewAllContentBackdrop', 'slds-backdrop--');
        toggleClassInverse(component, 'viewAllContent', 'slds-fade-in-');
    };

    return {
        getModal: buildModalAction
    };
};