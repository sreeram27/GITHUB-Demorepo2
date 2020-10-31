/*****************************************************************************************
Class Name   : LGA_UTIL13_FilesDataAccessHelper
Date Created : 6/14/2019
Created By   : Accenture Offshore
Description  : 1. This is the util data access class for ContentDocumentLink objects.
***********************************************************************************************************************/
public class LGA_UTIL13_FilesDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPSERT_OPERATION = 'Upsert';
  
  /****************************************************************************************************
    Method Name : dmlContentDCLinklist
    Parameters  : List<ContentDocumentLink> cvList,String operation
    Return type : List<ContentDocumentLink>
    Description : This method is used to perform the DML operations on ContentDocumentLink.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from LG01_Constants class.
    ******************************************************************************************************/
    public static List<ContentDocumentLink> dmlContentDCLinklist(List<ContentDocumentLink> contentList, String operation){
        system.debug('@@contentList'+contentList);
        if(!contentList.isEmpty())
        {
            if(String.isNotBlank(operation) && UPSERT_OPERATION.equalsIgnoreCase(operation)){
                Database.Upsert(contentList);
            }
        }
        return contentList;
    }
}