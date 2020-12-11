trigger FacilitatorFeedback_AfterIns on Facilitator_Feedback__c (after insert) {
    /**********************************************************************
    * Purpose:  Sends email to the OE Facilitator and the Amb upon
    *           completion of the record
    * Mod:      6/15/2014
    * Author:   Tony Angle
    ***********************************************************************
    * Mod:      7/16/2014 - Added code to change feedback flags on event 
    *           record TA
    *           7/17/2014 - Changed volunteer to be the right name TA
    *           2/11/2015 - Changed to provide more information in the email
    *                       to OE Coordinator about the meeting receiving the 
    *                       feedback.  LG
    *
    ***********************************************************************/
    
    Facilitator_Feedback__c[] feedRec=trigger.new;
    
    // get email for the person completing
    String ambEmail=feedRec[0].person_completing__c;
    
   
    
    // Lookup the OE Coord for the given meeting
    SFDC_Volunteer_Event__c evntRec=[select id,name,OE_Coordinator_Contact__c,date__c,Facilitator_Feedback_Received__c,Waiting_on_Feedback__c from SFDC_Volunteer_Event__c where id=:feedRec[0].Open_Enrollment__c];
    String formattedDate=String.valueOf(evntRec.Date__c);
    formattedDate=formattedDate.substring(0,10);

     // Send email to the person completing
    emailHandler em=new emailHandler();
    String strBody='Thank You for giving us your feedback!<br/><br/>';
    strBody=strBody+'<table width=900px>';
    strBody=strBody+'<tr><td width=15% bgcolor=silver><b>Meeting</b></td><td width=85%>'+evntRec.Name+'</td></tr>';
    strBody=strBody+'<tr><td width=15% bgcolor=silver><b>Date</b></td><td width=85%>'+formattedDate+'</td></tr>';
    strBody=strBody+'</tr></table><br/>';
    strBody=strBody+'The Open Enrollment Team';
        
    em.sendMail(ambEmail, 'donotreply@wellpoint.com', 'Volunteer Feedback', strBody);
    
    Contact[] cntRec=[select id,name,email from Contact where id=:evntRec.OE_Coordinator_Contact__c];
    
    // Send email to the OE Coord
    strBody='A volunteer has submitted feedback for the meeting below... <br/><br/>';
    strBody=strBody+'<table width=900px>';
    strBody=strBody+'<tr><td width=15% bgcolor=silver><b>Meeting</b></td><td width=85%>'+evntRec.Name+'</td></tr>';
    strBody=strBody+'<tr><td width=15% bgcolor=silver><b>Date</b></td><td width=85%>'+formattedDate+'</td></tr>';
    strBody=strBody+'<tr><td width=15% bgcolor=silver><b>Volunteer</b></td><td width=85%>'+feedRec[0].Person_Completing__c+'</td></tr>';
    strBody=strBody+'</tr></table><br/>';
    strBody=strBody+'Thank You<br/><br/>';
    strBody=strBody+'The Open Enrollment Team';
      
    if (cntRec.size() > 0)  {  
    em.sendMail(cntRec[0].email, 'donotreply@wellpoint.com', 'Volunteer Feedback Submitted', strBody);
    }
    else {
     
     feedRec[0].AddError('Please ensure the associated meeting record for this Facilitator Feedback Survey has the \'OE Coordinator\' assigned. ');
    }
    // modify meeting record concerning feedback
    evntRec.Facilitator_Feedback_Received__c=true;
    evntRec.Waiting_on_Feedback__c=false;
    update evntRec;
}