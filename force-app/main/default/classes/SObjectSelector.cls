public with sharing class SObjectSelector {

    public static List<EntityDefinition> selectCustomObjects() {

        return [SELECT Label, QualifiedApiName 
                FROM EntityDefinition 
                WHERE isCustomizable = true 
                AND isQueryable = true 
                ORDER BY Label];

    }
    public static List<FieldDefinition> selectFields(String objName) {
        return [SELECT Label, QualifiedApiName 
                FROM FieldDefinition 
                WHERE EntityDefinition.QualifiedApiName = :objName 
                ORDER BY Label];
    }

    public static List<SObject> selectRecords(String objName, List<String> fields) {
        String fieldsStr = String.join(fields, ',');
        String query = 'SELECT ' + fieldsStr + ' FROM ' + objName;
        return Database.query(query);
    }

}