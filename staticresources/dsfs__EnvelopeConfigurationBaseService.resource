window.EnvelopeConfigurationBaseService = function (component, helper) {
    let NamespaceLocale = {};

    function ApplicationConfiguration(data) {
        this.isInitReady = true;
        const LocalizationSettings = new LocalizationService(data.labels, data.images);
        LocalizationSettings.cache();            
        NamespaceLocale = new NamespaceService(data.objects, data.fieldMap, data.paths);
        this.GlobalActions = {
            getDatabaseService: getDatabaseService
        };
        this.recordWrapper = new EnvelopeConfiguration(data.record);
        this.Recipients = resolveRecipients(data.recipients);
        this.Documents = resolveDocuments(data.documents);
        this.Mappings = {};
        this.Mappings.CCRM = resolveMapping(data.ccrm);
        this.Mappings.CCTM = resolveMapping(data.cctm);
        this.Layouts = data.layouts;
        this.SaveLabel = LocalizationSettings.labels["Save"];
        this.NamespaceService = NamespaceLocale;             

        this.refresh = function(){
            getAppConfig(component.get("v.recordId"), true);
            closeModal(component);           
        };
        
        this.globalSave = function() {
            databaseSave(component);
        };
        
        this.baseComponent = component;
    }

    function LocalizationService(labels, images) {
        this.labels = labels;
        this.images = images;
        this.cache = function () {
            component.set("v.Localization", this);
        };
    }

    function NamespaceService(sObjectsList, fields, paths) {
        this.sObjects = sObjectsList;
        this.fields = fields;
        this.paths = paths;

        this.convertToSalesforce = function (record, type) {
            if (!NamespaceLocale) {
                const AppConfig = component.get("v.AppConfig");
                NamespaceLocale = AppConfig.NamespaceService;
            }
            let response = {};
            const objectPrefix = type + '.';
            for (let propt in record) {
                if (propt !== 'databaseUpdate' || propt !== 'databaseInsert' || propt !== 'databaseActions') {
                    response[NamespaceLocale.fields[objectPrefix + propt]] = record[propt];
                }
            }
            return response;
        };
    }

    function databaseService(ns) {
        NamespaceLocale = ns;
        this.newRecipient = function (startingOrder, type, ecId) {
            let recipient = new Recipient(null);
            recipient.Order__c = startingOrder;
            recipient.Type__c = type;
            recipient.EnvelopeConfiguration__c = ecId;
            return recipient;
        };

        this.newDocument = function (startingOrder, type, ecId) {
            let doc = new Document(null);
            doc.Order__c = startingOrder;
            doc.Type__c = type;
            doc.EnvelopeConfiguration__c = ecId;
            return doc;
        };

        this.newMapping = function (type, ecId) {
            let map = new Mapping(null);
            map.Type__c = type;
            map.EnvelopeConfiguration__c = ecId;
            return map;
        };

        this.getRecord = function (id, records) {
            let response = records.filter(function (rec) {
                return rec.Id === id;
            });
            return response[0];
        };

    }

    function EnvelopeConfiguration(sObject) {
        this.Id = sObject["Id"];
        this.Name = sObject["Name"];
        this.CEM__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.CEM__c"]];
        this.CES__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.CES__c"]];
        this.SCS__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.SCS__c"]];
        this.LA__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.LA__c"]];
        this.LF__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.LF__c"]];
        this.OCO__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.OCO__c"]];
        this.SEM__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.SEM__c"]];
        this.SES__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.SES__c"]];
        this.SRS__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.SRS__c"]];
        this.SSB__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.SSB__c"]];
        this.STB__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.STB__c"]];
        this.LoadDefaultContacts__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.LoadDefaultContacts__c"]];
        this.Object_Type__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.Object_Type__c"]];
        this.ReminderEnabled__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ReminderEnabled__c"]];
        this.ReminderFrequency__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ReminderFrequency__c"]];
        this.ReminderDelay__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ReminderDelay__c"]];
        this.ExpireEnabled__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ExpireEnabled__c"]];
        this.ExpireAfter__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ExpireAfter__c"]];
        this.ExpireWarn__c = sObject[NamespaceLocale.fields["EnvelopeConfiguration__c.ExpireWarn__c"]];
        this.databaseUpdate = function () {
            this.databaseActions.update.setParams({
                record: this.convert()
            });
            this.databaseActions.update.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    getAppConfig(this.Id, true);
                    toastNotification("Saved", "DocuSign Envelope Configuration Successfully Saved.");
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.update);
        };

        this.convert = function () {
            if (!NamespaceLocale) {
                const AppConfig = component.get("v.AppConfig");
                NamespaceLocale = AppConfig.NamespaceService;
            }
            let response = {};
            const objectPrefix = 'EnvelopeConfiguration__c' + '.';
            for (let propt in this) {
                if (propt !== 'convert' || propt !== 'databaseUpdate' || propt !== 'databaseInsert' || propt !== 'databaseActions') {
                    response[NamespaceLocale.fields[objectPrefix + propt]] = this[propt];
                }
            }
            return JSON.stringify(response);
        };

        this.databaseActions = {
            update: component.get("c.updateEnvelopeConfiguration")
        };
    }

    function Recipient(recipient) {
        if (recipient) {
            this.Id = recipient.Id;
            this.Action__c = recipient[NamespaceLocale.fields["Recipient__c.Action__c"]];
            this.Authentication__c = recipient[NamespaceLocale.fields["Recipient__c.Authentication__c"]];
            this.FirstName__c = recipient[NamespaceLocale.fields["Recipient__c.FirstName__c"]];
            this.LastName__c = recipient[NamespaceLocale.fields["Recipient__c.LastName__c"]];
            this.Email__c = recipient[NamespaceLocale.fields["Recipient__c.Email__c"]];
            this.Role__c = recipient[NamespaceLocale.fields["Recipient__c.Role__c"]];
            this.Order__c = recipient[NamespaceLocale.fields["Recipient__c.Order__c"]];
            this.Type__c = recipient[NamespaceLocale.fields["Recipient__c.Type__c"]];
            this.EnvelopeConfiguration__c = recipient[NamespaceLocale.fields["Recipient__c.EnvelopeConfiguration__c"]];
            this.Message__c = recipient[NamespaceLocale.fields["Recipient__c.Message__c"]];
            this.Phone__c = recipient[NamespaceLocale.fields["Recipient__c.Phone__c"]];
            this.PrivateMessage__c = recipient[NamespaceLocale.fields["Recipient__c.PrivateMessage__c"]];
            this.SigningGroupId__c = recipient[NamespaceLocale.fields["Recipient__c.SigningGroupId__c"]];
            this.SigningGroupName__c = recipient[NamespaceLocale.fields["Recipient__c.SigningGroupName__c"]];
        } else { //New Recipient
            this.Action__c = '';
            this.Authentication__c = 'false';
            this.FirstName__c = '';
            this.LastName__c = '';
            this.Email__c = '';
            this.Role__c = '';
            this.Type__c = '';
            this.EnvelopeConfiguration__c = '';
            this.Message__c = '';
            this.PrivateMessage__c = 'false';
            this.SigningGroupName__c = '';
            this.Message__c = '';
            this.Order__c = '';
        }


        this.databaseUpdate = function (parentComponent) {
            this.databaseActions.update.setParams({
                record: this.convert()
            });
            this.databaseActions.update.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.update);
        };

        this.databaseInsert = function (parentComponent) {
            this.databaseActions.insert.setParams({
                record: this.convert()
            });
            this.databaseActions.insert.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.insert);
        };

        this.convert = function () {
            if (!NamespaceLocale) {
                const AppConfig = component.get("v.AppConfig");
                NamespaceLocale = AppConfig.NamespaceService;
            }
            let response = {};
            const objectPrefix = 'Recipient__c' + '.';
            for (let propt in this) {
                if (propt !== 'convert' || propt !== 'databaseUpdate' || propt !== 'databaseInsert' || propt !== 'databaseActions') {
                    response[NamespaceLocale.fields[objectPrefix + propt]] = this[propt];
                }
            }
            return JSON.stringify(response);
        };

        this.databaseActions = {
            update: component.get("c.updateRecipient"),
            insert: component.get("c.insertRecipient")
        };
    }

    function Document(doc) {
        if (doc) {
            this.Id = doc.Id;
            this.Type__c = doc[NamespaceLocale.fields["CustomParameterMap__c.Type__c"]];
            this.Name__c = doc[NamespaceLocale.fields["CustomParameterMap__c.Name__c"]];
            this.SubValue__c = doc[NamespaceLocale.fields["CustomParameterMap__c.SubValue__c"]];
            this.Value__c = doc[NamespaceLocale.fields["CustomParameterMap__c.Value__c"]];
            this.Order__c = doc[NamespaceLocale.fields["CustomParameterMap__c.Order__c"]];
        } else { //New Document
            this.Type__c = '';
            this.Name__c = '';
            this.SubValue__c = '';
            this.Value__c = '';
            this.Order__c = '';
            this.EnvelopeConfiguration__c = '';
        }

        this.databaseUpdate = function (parentComponent) {
            this.databaseActions.update.setParams({
                record: this.convert()
            });
            this.databaseActions.update.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.update);
        };

        this.databaseInsert = function (parentComponent) {
            this.databaseActions.insert.setParams({
                record: this.convert()
            });
            this.databaseActions.insert.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An error occured while inserting document");
                }
            });
            $A.enqueueAction(this.databaseActions.insert);
        };

        this.convert = function () {
            if (!NamespaceLocale) {
                const AppConfig = component.get("v.AppConfig");
                NamespaceLocale = AppConfig.NamespaceService;
            }
            let response = {};
            const objectPrefix = 'CustomParameterMap__c.';
            for (let propt in this) {
                if (propt !== 'convert' || propt !== 'databaseUpdate' || propt !== 'databaseInsert' || propt !== 'databaseActions' || propt !== 'handleDocumentUpload' || propt !== 'update' || propt !== 'insert') {
                    response[NamespaceLocale.fields[objectPrefix + propt]] = this[propt];
                }
            }
            return JSON.stringify(response);
        };

        this.handleDocumentUpload = function (fileUpload) {
            //TODO Support Multiple File Uploads
            this.Name__c = fileUpload.name;
            this.Value__c = fileUpload.documentId;
        }

        this.databaseActions = {
            update: component.get("c.updateCustomParameterMap"),
            insert: component.get("c.insertCustomParameterMap")
        };
    }

    function Mapping(map) {
        if (map) {
            this.Id = map.Id;
            this.Type__c = map[NamespaceLocale.fields["CustomParameterMap__c.Type__c"]];
            this.Name__c = map[NamespaceLocale.fields["CustomParameterMap__c.Name__c"]];
            this.SubValue__c = map[NamespaceLocale.fields["CustomParameterMap__c.SubValue__c"]];
            this.Value__c = map[NamespaceLocale.fields["CustomParameterMap__c.Value__c"]];
            this.EnvelopeConfiguration__c = map[NamespaceLocale.fields["CustomParameterMap__c.EnvelopeConfiguration__c"]];
        } else { //New Mapping
            this.Type__c = '';
            this.Name__c = '';
            this.SubValue__c = '';
            this.Value__c = '';
            this.Order__c = '';
            this.EnvelopeConfiguration__c = '';
        }

        this.databaseUpdate = function (parentComponent) {
            this.databaseActions.update.setParams({
                record: this.convert()
            });
            this.databaseActions.update.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.update);
        };

        this.convert = function () {
            if (!NamespaceLocale) {
                const AppConfig = component.get("v.AppConfig");
                NamespaceLocale = AppConfig.NamespaceService;
            }
            let response = {};
            const objectPrefix = 'CustomParameterMap__c' + '.';
            for (let propt in this) {
                if (propt !== 'convert' || propt !== 'databaseUpdate' || propt !== 'databaseInsert' || propt !== 'databaseActions') {
                    response[NamespaceLocale.fields[objectPrefix + propt]] = this[propt];
                }
            }
            return JSON.stringify(response);
        };

        this.databaseInsert = function (parentComponent) {
            this.databaseActions.insert.setParams({
                record: this.convert()
            });
            this.databaseActions.insert.setCallback(this, function (response) {
                if (response.getState() === "SUCCESS") {
                    closeModal(parentComponent);
                } else if (response.getState() === "ERROR") {
                    toastNotification("ERROR", "An Error Occurred");
                }
            });
            $A.enqueueAction(this.databaseActions.insert);
        };

        this.databaseActions = {
            update: component.get("c.updateCustomParameterMap"),
            insert: component.get("c.insertCustomParameterMap")
        };
    }

    function Layout(layout) {
        this.Id = layout.Id;
        this.Type__c = layout[NamespaceLocale.fields["CustomParameterMap__c.Type__c"]];
        this.Name__c = layout[NamespaceLocale.fields["CustomParameterMap__c.Name__c"]];
        this.SubValue__c = layout[NamespaceLocale.fields["CustomParameterMap__c.SubValue__c"]];
        this.Value__c = layout[NamespaceLocale.fields["CustomParameterMap__c.Value__c"]];
    }

    const getDatabaseService = function (ns) {
        return new databaseService(ns);
    };

    const resolveRecipients = function (recipients) {
        let response = [];
        recipients.forEach(function (rec) {
            response.push(new Recipient(rec));
        });
        return response;
    };

    const resolveDocuments = function (documents) {
        let response = [];
        documents.forEach(function (doc) {
            response.push(new Document(doc));
        });
        return response;
    };

    const resolveMapping = function (mappings) {
        let response = [];
        mappings.forEach(function (map) {
            response.push(new Mapping(map));
        });
        return response;
    };

    const resolveLayouts = function (layouts) {
        let response = [];
        layouts.forEach(function (l) {
            response.push(new Layout(l));
        });
        return response;
    };

    const getAppConfig = function (buttonId, fullReload) {
        if (!buttonId) return;
        let action = component.get("c.init");
        action.setParams({
            ecId: buttonId
        });
        action.setCallback(this, function (response) {

            if (response.getState() === "SUCCESS") {
                let appConfig = buildAppConfig(response);
                if (fullReload) layoutManageInit(appConfig, component.get("v.Localization"));
                component.set("v.AppConfig", appConfig);
                setTimeout(function() {
                    setEvent(component);
                }, 2000);
                
            } else if (response.getState() === "ERROR") {
                toastNotification("ERROR", response.getError());
            }
        });
        $A.enqueueAction(action);
    };

    const layoutManageInit = function (config, locale) {
        let options = {};
        options.Action = 'ManageLayoutResponse';
        options.AppConfig = config;
        options.Localization = locale;
        parent.postMessage(JSON.stringify(options), window.location.origin);
    };

    const buildAppConfig = function (response) {
        let LocalizationSettings = {};
        let AppConfig = {};
        let result = response.getReturnValue();
        AppConfig = new ApplicationConfiguration(result);
        
        return AppConfig;
    };

    const toastNotification = function (title, message) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message
        });
        resultsToast.fire();
    };

    const getObjectFieldSelectOption = function (ModalAction, objectName, fieldSet) {
        let action = component.get("c.getAllObjectFields");
        action.setParams({
            objectName: objectName
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let sObjectOptions = [];
                for (let i = 0; i < response.getReturnValue().length; i++) {
                    let option = response.getReturnValue()[i];
                    if (option !== null || option !== undefined) {
                        sObjectOptions.push({ class: "optionClass", label: objectName + '.' + option, value: option });
                    }
                }
                sObjectOptions.sort(function (a, b) {
                    if (a.label < b.label) return -1;
                    if (a.label > b.label) return 1;
                    return 0;
                });
                fieldSet.forEach(function (field) {
                    component.find(field.auraId).set("v.options", sObjectOptions);
                });
            } else if (response.getState() === "ERROR") {
                toastNotification("ERROR", "An error occurred while trying to retrieve sObject's in your Org");
            }
        });
        $A.enqueueAction(action);
    };

    const getObjectSelectOption = function () {
        let action = component.get("c.getOrgObjects");
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                let sObjectOptions = [];
                response.getReturnValue().forEach(function (option) {
                    sObjectOptions.push({ class: "optionClass", label: option.name, value: option.value });
                });
                component.find("sObjectSelect").set("v.options", sObjectOptions);
                sObjectOptions.sort(function (a, b) {
                    if (a.label < b.label) return -1;
                    if (a.label > b.label) return 1;
                    return 0;
                });
                component.find("sObjectSelect").set("v.options", sObjectOptions);
            } else if (response.getState() === "ERROR") {
                toastNotification("ERROR", "An error occurred while trying to retrieve sObject's in your Org");
            }
        });
        $A.enqueueAction(action);
    };

    const databaseSave = function (component, event) {
        let AppConfig = component.get("v.AppConfig");
        NamespaceLocale = AppConfig.NamespaceService;
        AppConfig.recordWrapper.databaseUpdate();
    };

    const refreshPage = function (recordId) {
        let navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "related"
        });
        navEvt.fire();
    };

    const closeModal = function (parentComponent) {
        toggleClassInverse(parentComponent, 'viewAllContentBackdrop', 'slds-backdrop--');
        toggleClassInverse(parentComponent, 'viewAllContent', 'slds-fade-in-');
        getAppConfig(parentComponent.get("v.recordId"), false);
    };

    const openModal = function (parentComponent) {
        toggleClass(parentComponent, 'viewAllContentBackdrop', 'slds-backdrop--');
        toggleClass(parentComponent, 'viewAllContent', 'slds-fade-in-');
    };

    const toggleClassInverse = function (parentComponent, auraId, className) {
        const modal = parentComponent.find(auraId);
        $A.util.addClass(modal, className + 'hide');
        $A.util.removeClass(modal, className + 'open');
    };

    const toggleClass = function (parentComponent, auraId, className) {
        const modal = parentComponent.find(auraId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    };

    const deleteChildObject = function (event, recordId, buttonId) {
        const deleteAction = component.get("c.deleteCustomParameter");
        deleteAction.setParams({ recordId: recordId, ecId: buttonId });
        deleteAction.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                getAppConfig(buttonId, true);
            } else if (response.getState() === "ERROR") {
                toastNotification("ERROR", "An Error Occurred");
            }
        });
        $A.enqueueAction(deleteAction);
    };

    const setEvent = function() {
        window.AppConfig = component.get('v.AppConfig'); //Attaching AppConfig to window object;        
        window.addEventListener("message",onmessageEvent, false);
    };
    
    const onmessageEvent = function(event) {
        if (event.data && typeof event.data !== 'function') {
            const EventResponse = JSON.parse(event.data);
            if (EventResponse.Action === 'Refresh') {
                window.AppConfig.refresh();
            } else if (EventResponse.Action === 'GlobalSave') {
                window.AppConfig.globalSave();
            }
        }
    };

    return {
        getAppConfig: getAppConfig,
        sendNotification: toastNotification,
        getObjectFieldSelectOption: getObjectFieldSelectOption,
        getObjectSelectOption: getObjectSelectOption,
        deleteChildObject: deleteChildObject,
        databaseSave: databaseSave

    };
};