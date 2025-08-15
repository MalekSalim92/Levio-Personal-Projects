public with sharing class BulkRecordUpdaterController {
    @AuraEnabled (cacheable = true)
    public static List<EntityDefinition> getAllSalesforceObjects() {

        return [SELECT Label, QualifiedApiName FROM EntityDefinition Order By Label ASC];

    }

    @AuraEnabled (cacheable = true)
    public static List<FieldDefinition> getAllFields(String objName){
           return [SELECT Label, QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = :objName Order By Label ASC];
    }
}
