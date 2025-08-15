public with sharing class BulkRecordUpdaterController {
    @AuraEnabled (cacheable = true)
    public static List<EntityDefinition> getAllSalesforceObjects() {

        return [SELECT Label, QualifiedApiName FROM EntityDefinition];

    }
}