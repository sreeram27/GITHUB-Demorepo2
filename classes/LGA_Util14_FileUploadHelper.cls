/**********************************************************************************
Class Name :   LGA_Util14_FileUploadHelper
Date Created : 16-June-2019
Created By   : IDC Offshore
Description  : 1. This is the Util class for FileUplaod classes. SGA_AP06_FileUploadController
and SGA_AP13_UploadProposalDocument
Change History : 
*************************************************************************************/
public class LGA_Util14_FileUploadHelper {
    public Static Final String B_CONSTANT = 'B';
    /****************************************************************************************************
Method Name : fileSizeConvertion
Parameters  : String
Return type : String
Description : This method is used to convert file size into bytes, KB's and MB's.
******************************************************************************************************/
    public static String fileSizeConvertion(String fileSize){
        Long longFileSize = 0;
        if(String.isNotBlank(fileSize) && !fileSize.contains(B_CONSTANT)){
            longFileSize = Long.valueOf(fileSize);
            if (longFileSize < 1024){
                fileSize =  string.valueOf(longFileSize) + Label.LG16_Bytes; 
            }
            else if (longFileSize >= 1024 && longFileSize < (1024*1024))
            {
                Decimal kb = Decimal.valueOf(longFileSize);
                kb = kb.divide(1024,2);
                fileSize = string.valueOf(kb) + Label.SG17_KB;
            }
            else{
                if (longFileSize >= (1024*1024) && longFileSize < (1024*1024*1024))
                {
                    //MB
                    Decimal mb = Decimal.valueOf(longFileSize);
                    mb = mb.divide((1024*1024),2);
                    fileSize = string.valueOf(mb) + Label.LG18_MB;
                }   
            }
        }
        return fileSize;
    }
    
}