@isTest
public class SetSequenceTestClass{          
    //before Insert
    SetSequenceInContact setSeq = new SetSequenceInContact();    
	
    public static testMethod void testSequence(){
        SetSequenceTestClass testObj = new SetSequenceTestClass();
        testObj.testInsert();        
		testObj.testDelete();        
        testObj.testBeforeUpdate();          
		testObj.testAfterUpdate();        
    }
     public void testInsert(){
         Account acct1 = new Account(name='Manjeet');
         insert acct1;
         Account acct2 =	new Account(name='Ranjeet');
         insert acct2;
         List<Contact> cont;    
         Contact con = new Contact();
         con.LastName='John';
         con.AccountId=acct1.id;            
         insert con;
         cont = new List<Contact>{new Contact(lastName='Shri1', AccountId=acct1.id),
                                     new Contact(lastName='Shri1', AccountId=acct2.id),
                                     new Contact(lastName='Shri2', AccountId=acct1.id),
                                     new Contact(lastName='Shri3', AccountId=acct2.id),
                                     new Contact(lastName='Shri4', AccountId=acct2.id),
                                     new Contact(lastName='Shri5', AccountId=acct1.id),
                                     new Contact(lastName='Shri6', AccountId=acct2.id),
                                     new Contact(lastName='Shri7', AccountId=acct1.id),
                                     new Contact(lastName='Shri8', AccountId=acct2.id),
                                     new Contact(lastName='Shri9'),
                                     new Contact(lastName='Shri9'),
                                     new Contact(lastName='Shri10'),
                                     new Contact(lastName='Shri11'),
                                     new Contact(lastName='Shri12'),
                                     new Contact(lastName='Shri13')
                 				};
            insert cont;
     }
    
    public void testDelete() {        
        List<Contact>del1 = [select lastName, sequenceNumber__c from Contact where lastName = 'shri9'];
        delete del1;
        RecursiveController.recursionController = true;
        List<Contact> del = [select AccountId from contact where lastName = 'shri2'];           
        delete del;                   
        RecursiveController.recursionController = true;
        undelete del;              
        
    }
   
    public void testBeforeUpdate() {    
        try{            
            RecursiveController.recursionController = true;                 
            Contact updateContact = [select sequenceNumber__c, lastName from Contact where sequenceNumber__c = 2 limit 1];             
            List<Contact> contactRec = new List<Contact>(); 
            
            Account acct1 = new Account(name='Manjeet');
         	insert acct1;
            
            updateContact.sequenceNumber__c = 1;
		    contactRec.add(updateContact);
            
            updateContact = [select sequenceNumber__c, lastName from Contact where sequenceNumber__c = 1 limit 1];             
            updateContact.sequenceNumber__c = 2;
		    contactRec.add(updateContact);
            
            updateContact = [select sequenceNumber__c, lastName from Contact where sequenceNumber__c = 3 limit 1];             
            updateContact.sequenceNumber__c = 0;
		    contactRec.add(updateContact);
            
            updateContact = [select sequenceNumber__c, lastName from Contact where sequenceNumber__c = 4 limit 1];             
            updateContact.sequenceNumber__c = 50;
		    contactRec.add(updateContact);
            
            updateContact = [select sequenceNumber__c, lastName from Contact where sequenceNumber__c = 5 limit 1];             
            updateContact.sequenceNumber__c = null;
		    contactRec.add(updateContact);                        
            
          /* for(Contact con : updateContact){               
               if(con.sequenceNumber__c == 2){
                    con.sequenceNumber__c = 1;
                    contactRec.add(con);
               }
               else if(con.SequenceNumber__c == 1){
                	con.sequenceNumber__c = 2;   
                   	contactRec.add(con);
               } 
               else if(con.SequenceNumber__c == 3){
                   con.sequenceNumber__c = 0;   
                   	contactRec.add(con);
               }
               else if(con.SequenceNumber__c == 4){
                   con.sequenceNumber__c = 50;   
                   	contactRec.add(con);
               }
               else if(con.SequenceNumber__c == 5){
                   con.sequenceNumber__c = null;   
                   	contactRec.add(con);
               }  
               else if(con.SequenceNumber__c == 6){
                   con.accountId = acct1.Id;   
                   contactRec.add(con);
               }  
           }   */                                  
           update contactRec;                                     
         }
        catch(Exception e)
        {
            system.debug('Exception in beforeUpdate: ' + e.getMessage());
        }
    }
        
    public void testAfterUpdate()
    {
        RecursiveController.recursionController = true;
        List<Contact> updateToContact = [select lastName, sequenceNumber__c, accountId from Contact  ];
        List<Contact> updateContact = new List<Contact>();
         Account acct2 =	new Account(name='Ranjeet');
         insert acct2;
        for(Contact con :  updateToContact)
        {
            if(con.SequenceNumber__c==1)
            {
            	con.accountId=null;
                updateContact.add(con);
            }
            else if(con.SequenceNumber__c==2)               
            {
                con.accountId=acct2.id;
                updateContact.add(con);
            }                           
        }
       RecursiveController.deleteController=true;  
       update updateContact;
    }        
}