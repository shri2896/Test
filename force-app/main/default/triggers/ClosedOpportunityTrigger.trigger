trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
    TriggerTrailheadHelperClass t = new TriggerTrailheadHelperClass();
    if(trigger.isInsert){
        t.beforeInsert(Trigger.new);
    }
    if(trigger.isUpdate){
        t.beforeUpdate(Trigger.new);
    }
}