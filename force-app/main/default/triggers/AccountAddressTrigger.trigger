trigger AccountAddressTrigger on Account (before insert, before update) {
    TrailheadHelperClass t = new TrailheadHelperClass();
	if(trigger.isInsert)
    {
        t.afterInsert(trigger.new);
    }
    else if(trigger.isUpdate)
    {
        t.afterUpdate(trigger.new);
    }
}