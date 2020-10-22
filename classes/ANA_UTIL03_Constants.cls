/**
@Author : Accenture Offshore Dev team
@name : ANA_UTIL03_Constants
@CreateDate :25-05-2017
@Description : This class contains the Constant variables which will be used in the actual classes.
*/
public with sharing class ANA_UTIL03_Constants {
    public static final String EMPTY='';
    public static final String COMMA=',';
    public static final String HIPHEN='-';
    public static final String NEXTLINE='\n';
    
    public static final string ORGID=UserInfo.getOrganizationId();
    public static final String APPNAME='National Sales';
    public static final String CANCEL='Cancel';
    
    /*################################################################
################    OPPORTUNITY STAGE NAME   ###################
################################################################*/
    
    public static final String CHANGE_CANCELLED='Change Cancelled';
    public static final String CLOSED_LOST='Closed Lost';
    public static final String CLOSED_DEAD='Closed Dead';
    public static final String DTQ='DTQ';
    public static final String CUSTOMER_TERMED='Customer Termed';
    
    /*################################################################
################    QUOTE LINE ITEM PRODUCT STAGE NAME   ###################
################################################################*/
    
    public static final String DEAD='Dead';
    public static final String IGAP_LOST='IGAP Lost';
    public static final String IGAP_DEAD='IGAP Dead';
    public static final String LOST='Lost';
    public static final String TERMED='Termed';  
    public static final String IN_PROGRESS='In Progress';
    public static final String JEOPARDY='Jeopardy';
    public static final String RENEWED='Renewed';
    public static final String IGAP_IN_PROGRESS='IGAP In Progress';
    public static final String IGAP_SOLD='IGAP Sold';
}