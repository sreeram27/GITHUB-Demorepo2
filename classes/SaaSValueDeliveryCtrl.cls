/** 
 *  @Author : Accenture 
 *  @Description : Controller class for SaaSValueDeliveryCtrl
 *  @Created Date : 05\12\2015
 * 
 *  Version History :
 *  Date              Changes 
 *  05\12\2015        created 
 *	12\11\2019		  modified
 *
 */
public class SaaSValueDeliveryCtrl
{       
    public String releaseID{get;set;}
    public String sessionID{get;set;}         
   /**
    * @description : Get all Project From the sandbox 
    * @return : List<SelectOption>
    *
    */   
    public List<SelectOption> getReleases()
    { 
        List<SelectOption> releaseList = new List<SelectOption>();
        releaseList.add(new SelectOption(SaaSTextConstant.EMPTY_STRING,SaaSTextConstant.NONE_PICKLIST_VALUE )); 
        //PRDCRM - 48684 : Tech Debt story to have either limit or a filter criteria in SOQL(Added a filter criteria to filter records with IsDeleted is equal to false) | 10th Dec, 2019 | Accenture - Panthers
        List<release__c> relList = [Select id, name, Release__c from release__c where IsDeleted = false];
        for(release__c release :relList)
        {
            releaseList.add(new SelectOption(release.Id,release.Name));     
        }
        return releaseList;   
    }
    /**
    * @description : Get all Session Associated with  the project 
    * @return : List<SelectOption>
    *
    */
    public List<SelectOption> getSession()
    { 
        List<SelectOption> sessionOptions = new List<SelectOption>();
        sessionOptions.add(new SelectOption(SaaSTextConstant.EMPTY_STRING,SaaSTextConstant.NONE_PICKLIST_VALUE )); 
        List<Value_Delivery_Session__c> sessionList = [Select id, name, Releases__c from Value_Delivery_Session__c where Releases__c = :releaseID];
        
        for(Value_Delivery_Session__c  sessionObj :sessionList)
        {
            sessionOptions.add(new SelectOption(sessionObj.Id,sessionObj.Name));     
        }
       return sessionOptions;   
    }
    /**
    * @description : Update custom Setting when user changes the sesion. This will help if the user is navigating to the othere screen
    * @return : PageReference
    */
    public PageReference updateValueDelSession()
    {              
        String errMsg = null;
        //try
        //{
            errMsg =  validateChangeSession();
            if(errMsg !=null)
            {  
                SaaSUtility.displayErrMsg(errMsg);
                return null; 
         
            }
            SaaSUtility.getLoggedInValueSession(sessionID); 
            return new PageReference(SaaSTextConstant.VALUE_DELIVERY_APPROACH_VF_PAGE_NAME_URL ); 
        //PRDCRM - 48684 : Try catch block has been commented as no exception can happen in the try block that was defined in the old code | 10th Dec, 2019 | Accenture - Panthers
       //Try catch block has been commented by as part of PRDCRM - 48684 as no exception can happen in the try block that was defined in the old code 
       //}
       /*catch(DmlException e)
        {
            SaaSUtility.displayErrMsg(e.getDmlMessage(0) );
        }*/ 
        /*catch(Exception e)
        {
            SaaSUtility.displayErrMsg(SaaSTextConstant.EXCEPTION_ERR_MSG );         
            //e.getMessage(); 
            return null;
        }*/
        //return null;
   }
   /**
    * @description : Validate user has selected any session before he navigates to the any value value delivery session
    * 
    * @return : String
    */
   private String validateChangeSession()
   {
        String errMsg = null; 
        if(releaseID== null|| releaseID ==SaaSTextConstant.EMPTY_STRING)
        {
             errMsg = SaaSTextConstant.CHANGE_PROJECT_NAME_ERR_MSG;      
        } 
        else if (sessionID== null|| sessionID==SaaSTextConstant.EMPTY_STRING)
        {
            errMsg = SaaSTextConstant.CHANGE_SESSION_ERR_MSG;
        } 
        return errMsg; 
   }
}