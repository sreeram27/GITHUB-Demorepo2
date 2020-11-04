/**
  * @author        Indra Lugina
  * @date          10/22/2018
  * @description   Vlocity Common Interface .
  */

global class IMP_CommonController {

    public String osType {get;set;}
    public String osSubType {get;set;}
    public IMP_CommonController() {
        osSubType = ApexPages.currentPage().getParameters().get('osSubType');
        osType = ApexPages.currentPage().getParameters().get('osType');
        if(String.isEmpty(osType)) {
            osType = 'IMPCase Library';
        }
    }
}