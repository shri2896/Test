/**
* @ Description :- For when user insert, delete, update any record it will recalculate the salary again with the help of 
* @ Author :- Shrikant Mittal
* @ Data :- 08/07/2019
*/


//According to the insert, update, delete & undelete record will modify
trigger CalculateSalaryTrigger on Contact ( after insert, after update, after delete, after undelete, before insert) {

    if(Trigger.isInsert && Trigger.isBefore){       
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        CalculateSalaryHandler.onAfterInsert(Trigger.newMap);   
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        CalculateSalaryHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        CalculateSalaryHandler.onAfterDelete(Trigger.oldMap);
    }
    else if(Trigger.isundelete){
        CalculateSalaryHandler.onUndelete(Trigger.newMap);   
    }

}