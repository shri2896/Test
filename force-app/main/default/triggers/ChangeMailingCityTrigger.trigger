/**
* @ Description :- For update contact mailing city field
* @ Author :- Shrikant Mittal
* @ Data :- 15/07/2019
*/

//When Account biling state change accounts child records must be update
trigger ChangeMailingCityTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
	if(Trigger.isInsert && Trigger.isBefore)
    {
	    
    }
    else if(Trigger.isInsert && Trigger.isAfter)
    {
	    	
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        ChangeMailingCity.onBeforeUpdate(Trigger.newMap);      
    }
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
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

//Mountain View