public with sharing class BulkRecordUpdaterController {

    
    //* GET OBJECTS
    @AuraEnabled (cacheable = true)
    public static List<EntityDefinition> getAllSalesforceObjects() {

        return [SELECT Label, QualifiedApiName FROM EntityDefinition WHERE isCustomizable = true AND isQueryable = true Order By Label];

    }

    //* GET FIELDS

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getFieldsEditable(String objName) {
        system.debug(objName);
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        system.debug(fieldMap);

        for (FieldDefinition field : [SELECT Label, QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = :objName ORDER BY Label]) {
            system.debug(field);

            Map<String, Object> f = new Map<String, Object>();
            f.put('label', field.Label);
            f.put('value', field.QualifiedApiName);
            f.put('editable', fieldMap.get(field.QualifiedApiName)?.getDescribe()?.isUpdateable() ?? false );
            system.debug(f);

            result.add(f);
        }
        return result;
    }

    //* GET RECORDS
    @AuraEnabled (cacheable = true)
    public static List<SObject> getAllRecords(String objName,List<string> fields){
             String fieldsStr = String.join(fields,',');
            String query = 'SELECT ' + fieldsStr + ' FROM ' + objName;

            return database.query(query);
     }
}
