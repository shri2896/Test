/**
* @ Description :- For update account's parent record. Parent record describe by self lookup field(ParentAccount)
* @ Author :- Shrikant Mittal
* @ Data :- 08/07/2019
*/

//According to the record deletion, updation updateSalaryOnAccount handler method will call.
trigger UpdateSalaryOnAccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

	if(Trigger.isInsert && Trigger.isBefore)
    {
	    UpdateSalaryOnAccount.onBeforeInsert(Trigger.new);	
    }
    else if(Trigger.isInsert && Trigger.isAfter)
    {
	    	
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        
    }
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
    	UpdateSalaryOnAccount.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore)
    {
        
    }
    else if(Trigger.isDelete && Trigger.isAfter)
    {
        
    }
    else if(Trigger.isundelete)
    {
        
    }
}