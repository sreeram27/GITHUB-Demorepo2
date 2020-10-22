public without sharing class CustomCloneController {
    public String objectTypeName {get;set;}
    public String objectID{get;set;}
    public String clonedRecordID{get;set;}
    public List<String> messages{get;set;}
    public List<ChildObjectWrapper> choicesChildsObjects{get;set;}
    public Custom_Clone_Setting__c configSetting{get;set;}
    public CustomCloneController(){
        this.messages=new List<String>();
        objectID = ApexPages.currentPage().getParameters().get('Id');
        if(String.isBlank(objectID) || (String.isNotBlank(objectID) && objectID.length()!=15 && objectID.length()!=18)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to retrieve the record Id.'));
            return;
        }
        Map<String,String> keyPrefixMap = new Map<String,String>{};
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();     
        for(String sObj : gd.keySet()){
          Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
          keyPrefixMap.put(r.getKeyPrefix(), r.getName());
        }
        objectTypeName = keyPrefixMap.get(objectId.subString(0,3));
        getChildsObjects();
    }
    public PageReference processConfigOptions(){
        String config=ApexPages.currentPage().getParameters().get('config');
        if(String.isNotBlank(config)){
            if(Custom_Clone_Setting__c.getAll().containsKey(config)){
                configSetting = Custom_Clone_Setting__c.getAll().get(config);
                for(String childElement : configSetting.Default_Child_Elements__c.split(',')){
                    if(Schema.getGlobalDescribe().containsKey(childElement.trim().toLowerCase())){
                        for(ChildObjectWrapper wrapper : choicesChildsObjects){
                            if(wrapper.childObjectName.equalsIgnoreCase(childElement.trim().toLowerCase())){
                                wrapper.isSelected=true;
                            }
                        }
                    }
                }
                if(!configSetting.Show_UI_Child_Element_Selector__c)
                	return processClone();
            } 
        }
        return NULL;
    }
    public void getChildsObjects(){
        choicesChildsObjects=new List<ChildObjectWrapper>();
		for(Schema.ChildRelationship childRel : Schema.getGlobalDescribe().get(objectTypeName).getDescribe().SObjectType.getDescribe().getChildRelationships()){
            Schema.DescribeSObjectResult r=childRel.getChildSObject().getDescribe();
            if(r.isAccessible() && r.isCreateable() && r.isDeletable() && r.isUpdateable() && r.isQueryable() && !r.getName().endsWithIgnoreCase('share') && !r.getName().endsWithIgnoreCase('__share')){
             	choicesChildsObjects.add(new ChildObjectWrapper(false,r.getLabel(),r.getName(),childRel.getField().getDescribe().getName()));
            }
        }
    }
    
    public PageReference processClone(){
        try{
            this.messages=new List<String>();
            Map<Id,sObject> mapOriginalIdToClonedChildsObject=new Map<Id,sObject>();
            sObject parentObject=Database.query('SELECT '+ String.join(ApexUtil.getAllWritableFieldsofsObject(objectTypeName),',') + ' FROM '+objectTypeName+ ' WHERE Id=\''+ objectID + '\'');
            parentObject.put('Id',NULL);
            if(String.isNotBlank(configSetting.Pre_Clone_Parent_Object_Processor__c )){
            	Type t = Type.forName(configSetting.Pre_Clone_Parent_Object_Processor__c ); 
            	PreCloneParentInterface preCloneParentProcessorInstance = (PreCloneParentInterface)t.newInstance();
            	parentObject=(sObject)preCloneParentProcessorInstance.preCloneParentProcessor(parentObject);
            }
            insert parentObject;
            for(ChildObjectWrapper wrapper : choicesChildsObjects){
                if(wrapper.isSelected){
                    for(sObject sObj : Database.query('SELECT '+ String.join(ApexUtil.getAllWritableFieldsofsObject(wrapper.childObjectName),',') + ' FROM '+wrapper.childObjectName+ ' WHERE '+wrapper.foreignKeyFieldName+'=\''+ objectID + '\'')){
                        sObject newsObj=sObj.clone(false,false,false,false);
                        if(mapOriginalIdToClonedChildsObject.containsKey((Id)sObj.get('Id'))){
                        	newsObj=mapOriginalIdToClonedChildsObject.get((Id)sObj.get('Id'));
                        }  
                        newsObj.put(wrapper.foreignKeyFieldName,parentObject.get('Id'));
                    	mapOriginalIdToClonedChildsObject.put((Id)sObj.get('Id'),newsObj);
                    }
                }
            }
            List<sObject> lstClonedChildsObjects=new List<sObject>(mapOriginalIdToClonedChildsObject.values());
            for(sObject sObj : lstClonedChildsObjects)
                sObj.put('Id',NULL);
            if(String.isNotBlank(configSetting.Pre_Clone_Children_Processor__c  )){ 
            	Type t = Type.forName(configSetting.Pre_Clone_Children_Processor__c); 
            	PreCloneChildInterface preCloneChildrenProcessorInstance = (PreCloneChildInterface)t.newInstance();
            	lstClonedChildsObjects=(List<sObject>)preCloneChildrenProcessorInstance.preCloneChildProcessor(mapOriginalIdToClonedChildsObject.values());
            }
            insert lstClonedChildsObjects;
            if(String.isNotBlank(configSetting.Post_Clone_Processor_Apex_Class_Name__c )){
            	Type t = Type.forName(configSetting.Post_Clone_Processor_Apex_Class_Name__c ); 
            	PostCloneInterface postCloneProcessorInstance = (PostCloneInterface)t.newInstance();
            	postCloneProcessorInstance.postCloneProcessor(parentObject,lstClonedChildsObjects);
            }
            EventBus.publish(new List<sObject_Event__e>{new sObject_Event__e(Record_Id__c=String.valueOf(parentObject.get('Id')),Process_Flag__c=Constants.CaseCustomCloneProcessString)});
            messages.add('Clone Success');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM ,String.join(messages,'<br/>')));
            clonedRecordID=String.valueOf(parentObject.get('Id'));
        }
        catch(Exception e){
            messages.add(e.getMessage()+'@'+e.getStackTraceString());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,String.join(messages,'<br/>')));
        }
        return NULL;
    }
    public PageReference GoToClonedRecord(){
        return new PageReference('/'+clonedRecordID);
    }
    public PageReference Cancel(){
        return new PageReference('/'+objectID);
    }
    
    public class ChildObjectWrapper{
        public Boolean isSelected{get;set;}
        public String childObjectLabel{get;set;}
        public String childObjectName{get;set;}
        public String foreignKeyFieldName{get;set;}
        public ChildObjectWrapper(Boolean isSelected,String childObjectLabel,String childObjectName,String foreignKeyFieldName){
            this.isSelected=isSelected;
            this.childObjectLabel=childObjectLabel;
            this.childObjectName=childObjectName;
            this.foreignKeyFieldName=foreignKeyFieldName;
        }
    }
}