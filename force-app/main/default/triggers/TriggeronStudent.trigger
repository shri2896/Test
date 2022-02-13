trigger TriggeronStudent on Student__c (after insert, after delete, after undelete, after update, before update) 
{
    countofstudent student = new countofstudent();
    if(trigger.isinsert)
    {     
        student.studentCount();        
        
        System.debug('Size of new operator is : ' + trigger.new.size());
        System.debug('New Records are : ');
        for(Student__c s : trigger.new)
        {
            System.debug('Student Name is : ' + s.First_Name__c);
            System.debug('Id is : ' + s.id);
            System.debug('Faculty Name is : ' + s.faculty__c);
        }
    }
    else if(trigger.isdelete)
    {
        student.studentCount();
        system.debug('Old Records are : ' + trigger.old.size());
        for(Student__c st: trigger.old)
        {
        	System.debug('Student Name is : ' + st.first_name__c );
            system.debug('Faculty Name is : ' + st.Faculty__c);
        }
        
        
    }
    if(trigger.isundelete)
    {
		 student.studentCount();
    }
    if(trigger.isUpdate)
    {
        student.studentcount();
        system.debug('Trigger.old size : ' + trigger.old.size());
        system.debug('Trigger.new size : ' + trigger.new.size());
        
        for(Student__c st : trigger.new)            
        {
        	System.debug('Student Name is ');    
        }
    }
}