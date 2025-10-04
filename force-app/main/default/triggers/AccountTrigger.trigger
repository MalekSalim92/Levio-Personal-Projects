trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    
    if(!AccountHandler.runTrigger || !TriggerUtils.isTriggerActive('Account')) return ;
     if (Trigger.isAfter && Trigger.isInsert) {
        AccountHandler.afterInsert(Trigger.newMap);
    }
     // test comment 
}