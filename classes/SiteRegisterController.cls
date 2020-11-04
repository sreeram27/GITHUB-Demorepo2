/*******************************************************************************************
@class Name  : SiteRegisterController
@createdDate : 1/24/2017
@description : An apex class that creates a portal user
********************************************************************************************/
public with sharing class SiteRegisterController {
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    /**Changes made my Accenture team to fix Code Scan Issue PRDCRM-48595 Date(MM:DD:YYYY): 12/02/2019**/
    /*Start*/
    private static Id portalAccountId = System.label.Portal_Account_Id;
    /*End*/
    
    public SiteRegisterController () {
    }
    
    public String username {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
/*******************************************************************************************
@method Name  : isValidPassword 
@return : boolean
@description : Checks for the password matching
********************************************************************************************/
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
/*******************************************************************************************
@method Name  : registerUser 
@return : PageReference
********************************************************************************************/
    public PageReference registerUser() {
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        User usr = new User();
        usr.Username = username;
        usr.Email = email;
        usr.CommunityNickname = communityNickname;
        
        String accountId = portalAccountId;
        
        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        String userId = Site.createPortalUser(usr, accountId, password);
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(username, password, null);
            }
            else {
                PageReference page = System.Page.SiteRegisterConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
}