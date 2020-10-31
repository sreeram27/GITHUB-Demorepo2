public class ApexUtil {
	 public static List<String> getAllWritableFieldsofsObject(String sObjectAPIName) {
        List<String> lstFields=new List<String>();
        if(Schema.getGlobalDescribe().containsKey(sObjectAPIName)){
            Map<String,Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().fields.getMap();
            for(String fld : fields.keySet()){
                Schema.DescribeFieldResult dfr = fields.get(fld).getDescribe();
                if((dfr.isUpdateable() || dfr.isCreateable() || dfr.isIdLookup()) && !dfr.isUnique())
                    lstFields.add(fld.toLowerCase());
            }
        }
        return lstFields;
    }
    public static String getThreadId(String cId){
     	ID orgId = UserInfo.getOrganizationId();
        String sOrgId = (string)orgId;
        ID caseId = cId;
        String sCaseId = (string)caseId;
        String threadIdPart1 = 'ref:_' + sOrgId.left(5) + sOrgId.right(10).replace('0','');
        threadIdPart1 = threadIdPart1.substring(0,threadIdPart1.length()-3);
        String threadIdPart2 = '._' + sCaseId.Left(5) + sCaseId.right(10).left(5).replace('0','') + sCaseId.right(5);
        threadIdPart2 = threadIdPart2.substring(0,threadIdPart2.length()-3)+':ref';
        return (threadIdPart1 + threadIdPart2);
     }
}