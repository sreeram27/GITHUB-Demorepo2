/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BrainsharkConfigController extends BRNSHRK.ConfiguratorPreviewComponentController {
    global String apiHost {
        get;
    }
    global String sessionJson {
        get;
    }
    global BrainsharkConfigController() {

    }
    @RemoteAction
    global static void deleteConfiguration(Id configurationId) {

    }
    @RemoteAction
    global static List<BRNSHRK.BrainsharkConfigController.Configuration> getConfigurations() {
        return null;
    }
    @RemoteAction
    global static List<BRNSHRK.BrainsharkConfigController.SalesforceObjectField> getSalesforceObjectFields(String objectName) {
        return null;
    }
    @RemoteAction
    global static List<BRNSHRK.BrainsharkConfigController.SalesforceObjectField> getSalesforceObjectPicklistFields(String objectName) {
        return null;
    }
    @RemoteAction
    global static List<BRNSHRK.BrainsharkConfigController.SalesforceObject> getSalesforceObjects(Boolean picklistFieldsOnly) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.BrainsharkConfigController.Configuration saveConfiguration(BRNSHRK.BrainsharkConfigController.Configuration configuration) {
        return null;
    }
global class Configuration {
    global Configuration() {

    }
}
global class SalesforceObject implements System.Comparable {
}
global class SalesforceObjectField implements System.Comparable {
}
}
