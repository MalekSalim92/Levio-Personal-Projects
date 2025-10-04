public with sharing class TriggerUtils {
 
    public static boolean isTriggerActive(String sObjectName){
 
        List<TriggerHandler__mdt> allMdts = TriggerHandler__mdt.getAll().values();
        for(TriggerHandler__mdt	mdt : allMdts){
            if(mdt.sObject__c == sObjectName){
                return mdt.Active__c;
             }
        }
        return true;
    }
}