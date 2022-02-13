trigger SequenceNuberContact on Contact (before Insert , after delete , after Update , before update , after undelete)  
{    
 	SetSequenceInContact manageSequence = new SetSequenceInContact();

    if(Trigger.isbefore && Trigger.isInsert)
    {
       	 manageSequence.beforeInsertTrigger(Trigger.new);
    }     
    if(Trigger.isAfter && Trigger.isDelete)
    {
        system.debug('Del Call');
        //RecursiveController.deleteController = false;
        manageSequence.afterDeleteTrigger(Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        //System.debug('in After update : RecursiveController.recursionController' + RecursiveController.recursionController);
        RecursiveController.recursionController=true;        
        //manageSequence.afterUpdate(Trigger.old , Trigger.new , Trigger.oldMap , Trigger.newMap);        
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {                  
        RecursiveController.deleteController=true;          
        //manageSequence.beforeUpdate(Trigger.new , Trigger.old , Trigger.oldMap);
    }
    
    if(Trigger.isUndelete)
    {
       manageSequence.afterUndelete(Trigger.new);
    }
}