public with sharing class BulkRecordUpdaterController {
    @AuraEnabled (cacheable = true)
    public static List<EntityDefinition> getAllSalesforceObjects() {

        return [SELECT Label, QualifiedApiName FROM EntityDefinition WHERE isCustomizable = true AND isQueryable = true Order By Label];

    }

    @AuraEnabled (cacheable = true)
    public static List<FieldDefinition> getAllFields(String objName){
           return [SELECT Label, QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = :objName Order By Label];
    }
}
