public with sharing class BulkRecordUpdaterController {

    
     @AuraEnabled (cacheable = true)
    public static List<EntityDefinition> getAllSalesforceObjects() {
        return BulkRecordUpdaterService.getObjects();
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getFieldsEditable(String objName) {
      return BulkRecordUpdaterService.getFieldsEditable(objName);
    }

    @AuraEnabled (cacheable = true)
    public static List<SObject> getAllRecords(String objName,List<string> fields){
        return BulkRecordUpdaterService.getRecords(objName,fields);

     }
}
