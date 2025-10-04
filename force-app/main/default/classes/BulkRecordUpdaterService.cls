public with sharing class BulkRecordUpdaterService {

    public static List<Map<String, Object>> getFieldsEditable(String objName) {

        List<Map<String, Object>> result = new List<Map<String, Object>>();
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        system.debug(fieldMap);

        for (FieldDefinition field : SObjectSelector.selectFields(objName)) {
            Map<String, Object> f = new Map<String, Object>();
            f.put('label', field.Label);
            f.put('value', field.QualifiedApiName);
            f.put('editable', fieldMap.get(field.QualifiedApiName)?.getDescribe()?.isUpdateable() ?? false );
 
            result.add(f);
        }
        return result;
    }

    public static List<EntityDefinition> getObjects() {
        return SObjectSelector.selectCustomObjects();
    }
    public static List<SObject> getRecords(String objName,List<string> fields) {
        return SObjectSelector.selectRecords(objName,fields);
    }

}

