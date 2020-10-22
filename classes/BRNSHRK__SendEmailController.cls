/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SendEmailController {
    global String apiHost {
        get;
    }
    global String appHost {
        get;
    }
    global String staticHost {
        get;
    }
    global SendEmailController() {

    }
    @RemoteAction
    global static Map<String,String> createRelatedObjects(BRNSHRK.BrainsharkAPI.Session session, Id toEmailId, String subject, String messageBody, String pidString, String objId, List<BRNSHRK.SendEmailController.BrainsharkIntKeyPair> intKeys) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmail.LookupResponse getContactsLeads(BRNSHRK.SendEmail.LookupRequest request) {
        return null;
    }
    @RemoteAction
    global static Map<Id,String> getDocumentFolders() {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmail.DocumentResponse getDocuments(BRNSHRK.SendEmail.DocumentRequest request) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmailController.BrainsharkMessage getEmailTemplate(Id emailTemplateId) {
        return null;
    }
    global static BRNSHRK.SendEmailController.BrainsharkMessage getEmailTemplate(Id emailTemplateId, Id toId) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmailController.EmailFolderViewModel getFolderList(Integer pageNumber, Integer recordsPerPage) {
        return null;
    }
    @RemoteAction
    global static List<BRNSHRK.SendEmailController.BrainsharkIntKeyPair> getIntegrationKeys(BRNSHRK.BrainsharkAPI.Session session, String toId, String objId, String pidString, Boolean sendViewReceipt) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmailController.BrainsharkUserEmail getObjectEmail(Id objectId) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.SendEmailController.BrainsharkMessage getPreviewEmail(BRNSHRK.SendEmail.PreviewRequest request) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.BrainsharkModels.ToEmailViewModel getToEmailList(Id recordId, Integer pageNumber, Integer recordsPerPage) {
        return null;
    }
    @RemoteAction
    global static BRNSHRK.BrainsharkAPI.Session refreshSession() {
        return null;
    }
    global static Map<String,String> sendEmail(BRNSHRK.BrainsharkAPI.Session session, Id toEmailId, String cc, String subject, String messageBody, Boolean isBccMeSet, Boolean isViewReceiptSet) {
        return null;
    }
    @RemoteAction
    global static Map<String,String> sendEmail(BRNSHRK.BrainsharkAPI.Session session, Id toEmailId, String cc, String subject, String messageBody, Boolean isBccMeSet, Boolean isViewReceiptSet, List<Id> additionalToIds, String pidString, Id relatedObjId, List<Id> attachDocuments) {
        return null;
    }
global class Brainshark {
    global Brainshark() {

    }
}
global class BrainsharkIntKeyPair {
    global BrainsharkIntKeyPair() {

    }
}
global class BrainsharkMessage {
    global BrainsharkMessage() {

    }
}
global class BrainsharkUserEmail {
    global BrainsharkUserEmail() {

    }
}
global class EmailFolderViewModel {
    global EmailFolderViewModel() {

    }
}
global class EmailTemplateModel {
    global EmailTemplateModel() {

    }
}
global class OpportunityContactRoleWrapper implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
}
