public class Example 
{
	public void dmlAction()
    {     
        /*Student__c stdnt = new Student__c(First_Name__c='Abhi',Faculty__c='a0B6F00001MnUaZUAV');        
        List<Student__c> lst = new List<Student__c>();
		lst.add(stdnt);        
        insert lst;
        
        List<Student__c> lst = new List <Student__C> { new Student__c(First_Name__c='Abhi' , Faculty__c='a0B6F00001MnUaZUAV', Subject__c='Java'), 
            										   new Student__c(First_Name__C='Yash', Faculty__c='a0B6F00001MnUaZUAV', Subject__c='Java'),
                                                       new Student__c(first_name__c='Sidd', Faculty__c='a0B6F00001MnUaZUAV', subject__c='salesforce')             
                                                      };
        insert lst;
        List<student__c> updatestudent = new List<student__c>();
        
        for(Student__c s : lst)
        {
            if(s.Faculty__c=='a0B6F00001MnUaZUAV' && s.subject__c=='salesforce')
            {
                s.subject__c='java';
				updatestudent.add(s);
            } 
        }
        update updatestudent;
        
        Contact cntct = new Contact(FirstName='Josh',LastName='Kaplan',Department='Finance');
        insert cntct;
        
        cntct.Description = 'Josh\'s record has been updated by the upsert operation.';        
        Contact kathy = new Contact(FirstName='Kathy',LastName='Brown',Department='Technology');
        
        List<Contact> contacts = new List<Contact> { cntct, kathy };
            
		upsert contacts;        
        Student__c student = new student__c();
        student.first_name__c='Ashok';
        student.faculty__c='a0B6F00001MnTF3UAN';
        student.subject__c='Java';
        
        insert student;
        student.first_name__c='Manish';
       // Student.faculty__c='a0B6F00001MnTF3UAN';
        student.DOB__c=	system.today();
        
        upsert(student);*/
        
        List <Student__c> lst = new List<student__c> {new student__c(first_name__c='Shakal', subject__c='Salesforce', faculty__c='a0B6F00001MnTF3UAN'), new student__c()};
        Database.saveresult[] DS = Database.insert(lst, false);
        
        for(Database.saveresult sr : DS)
        {
            if(sr.issuccess())
            {
                System.debug('Record insert successfully...!!! contact id is :- ' + sr.getid());
            }
            else
            {
                for(Database.error err : sr.getErrors())
                {
                    System.debug(err.getstatuscode() + ' : ' + err.getMessage());
                    System.debug('Affected fields are : ' + err.getfields());
                }
            }
        }
           
	}
}