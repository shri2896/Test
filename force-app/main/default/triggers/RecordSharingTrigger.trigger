/**
* @ description : RecordSharingTrigger trigger for when user insert or update records it will assign or change the sharing setting on the record.
* @ author      : Shrikant Mittal
* @ date        : 28/06/2019
*/

//For RecordSharingTriggerHandler when record insert, update, delete
trigger RecordSharingTrigger on Matter_Member__c (after insert, after update, after delete, after undelete, before insert) {
	
	List<Matter_Member__c> lstOfMatterMember = new List<Matter_Member__c>();
	if(Trigger.isBefore && Trigger.isInsert){		
    	lstOfMatterMember = RecordSharingTriggerHelper.onBeforeInsert(Trigger.new);
    }

	else if(Trigger.isAfter && Trigger.isInsert){
		system.debug('lstOfMatterMember : ' + lstOfMatterMember);
		if(lstOfMatterMember.isEmpty() || lstOfMatterMember == null){
			system.debug('after insert if : ');
			//When user insert any record of matter member
			RecordSharingTriggerHelper.onAfterInsert(Trigger.new);
		}
		else{
			system.debug('after insert else : ');
			RecordSharingTriggerHelper.onAfterInsert(lstOfMatterMember);
		}
    }

    else if(Trigger.isBefore && Trigger.isUpdate){
    }		

    else if(Trigger.isAfter && Trigger.isUpdate){    	
    	//when user update matter member record
    	if(!PreventingRecursiveTrigger.preventTrigger){
	    	system.debug('enter in update');
			RecordSharingTriggerHelper.onAfterUpdate(Trigger.new, Trigger.old, Trigger.oldMap); 
			RecordSharingTriggerHelper.updateFirstNameWhenRecordUpdate(Trigger.new, Trigger.oldMap);
		}
    }	

    else if(Trigger.isBefore && Trigger.isDelete){
    }		

    else if(Trigger.isAfter && Trigger.isDelete){
    	//Remove sharing of deleted records
    	RecordSharingTriggerHelper.onAfterDelete(Trigger.oldMap);    	
    }		

    else if(Trigger.isAfter && Trigger.isUndelete){
    	//Set undeleted record's sharing
    	RecordSharingTriggerHelper.onAfterUndelete(Trigger.new);
    }		
}