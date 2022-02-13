public class SetSequenceInContact 
{   
    public void beforeInsertTrigger(List<Contact> newRecord)
    {       
        try
        {   
			Map<ID , Decimal> relateRecordSize = new Map<ID , Decimal>();
            Set<Id> uid = new Set<ID>();        	         
            
            for(Contact cont : newRecord)
            {
                uid.add(cont.AccountId);                
            }        
			
            List<Account> relateChildRecord = [select ID , (select AccountId from Contacts) from Account where Id IN :(uid)];
            List<AggregateResult> maxSize = [Select max(SequenceNumber__c)maxSeq from Contact where AccountId = null];
          
            for(Account singleRec : relateChildRecord)
            {
                if(singleRec.contacts.size()>0)
                {
                     relateRecordSize.put(singleRec.Id , singleRec.contacts.size());                                          
                }
                else
                {
                    relateRecordSize.put(singleRec.Id , singleRec.contacts.size());                    
                }
            }
            
            for(Contact cont : newRecord)
            {               
                if(relateRecordSize.containsKey(cont.AccountId))
                {
                    cont.SequenceNumber__c = relateRecordSize.get(cont.AccountId)+1;                    
                    relateRecordSize.remove(cont.AccountId);
                    relateRecordSize.put(cont.AccountId,cont.SequenceNumber__c);                 
                }
                else
                {                    
                    cont.sequenceNumber__c = ((Decimal)(maxSize[0].get('maxSeq'))+1);                   
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Exception is : ' + e);
        }    
    }
    
    public void afterDeleteTrigger(Map<ID , Contact> delRecord)
    {
        try
        {
            if(RecursiveController.recursionControllerMethod())
            {
                boolean st=false;
                Set<ID> AccId = new Set<ID>();
                for(String key : delRecord.keySet())
                {
                    Contact cont = delRecord.get(key);
                    if(cont.AccountId==null)
                    {
                        st=true;
                    }
                    else
                    {
                    	AccId.add(cont.AccountId);
                    }
                }
                        
                Integer seq = 1;
                Integer noParentRecord = 1;
                
                List<Account> reNumbringToContact = [select ID , (select sequenceNumber__c , lastName , AccountId from Contacts ORDER BY SequenceNumber__c asc) from Account where ID IN :(AccId)];
                    
                List<Contact>upDateToContact = new List<Contact>();
                //Resequence to null parent Record
                List<Contact> lst = [select sequenceNumber__c,AccountId , LastName from Contact where AccountId = null Order By sequenceNumber__c asc]; 
                if(st==true)
                {
                    //System.debug('Cont size is : ' + lst.size());
                    for(Contact cont : lst)
                    {
                        cont.sequenceNumber__c = seq++;
                        upDateToContact.add(cont);
                    }                     
                    update upDateToContact;
                }
                seq=1;
                upDateToContact.clear();
                
                for(Account singleRecord : reNumbringToContact)
                {
                    system.debug('in del : ' + singleRecord.id + ' Size : ' + singleRecord.contacts.size());
                    for(Contact cont : singleRecord.Contacts)
                    {         
                        system.debug('Cont is : ' + cont.lastName );
                        cont.SequenceNumber__c = seq;
                       //system.debug('Record is : ' + cont + ' seq number is : ' + seq);
                        seq++;
                        upDateToContact.add(cont);
                    }
                    seq=1;                                	
             	}
                update upDateToContact;                
            }
        }
       	catch(Exception e)
        {
            system.debug('Exception is : ' + e.getMessage());
        }
    }
    
    public void afterUpdate(List<Contact> updateOldRecords , List<Contact> updateNewRecords , Map<Id , Contact> oldContactRec , Map<Id , Contact> newContactRec)
    {
        //System.debug('in After update : RecursiveController.recursionController' + RecursiveController.recursionController);
        if((RecursiveController.recursionControllerMethod()) && (RecursiveController.deleteController==true) )
        {            
            Set<ID> oldRecId = new Set<ID>();
            AggregateResult[] rs = [select max(sequenceNumber__c)maxSeq from Contact where AccountId = null ];
            List<Contact>noParentRecUpdate = new List<Contact>();
            Integer maxSeqOfNoParent = Integer.valueOf(rs[0].get('maxSeq'));
            //system.debug('Max Seq of No parent Record is : ' + maxSeqOfNoParent);
            Set<ID> reSeq = new Set<ID>();
            for(Contact oldRec : updateOldRecords)
            {                       
                for(Contact NewRec : updateNewRecords)
                {      
                    //system.debug('(oldRec.ID : ' + oldRec.AccountID + ' newRec.AccountID : ' + newRec.AccountID);
                     if((oldRec.ID == newRec.ID) && (oldRec.AccountID <> null && newRec.AccountID == null))
                     {
                        //update to those record whose AccountId is null but after updation change there Account Id
                        //update to those records whose accountid is null                                              	
                        Contact cont = new Contact(Id=newRec.id);
                        cont.SequenceNumber__c = ++maxSeqOfNoParent;
                        noParentRecUpdate.add(cont);
                        oldRecId.add(oldRec.accountId);
                    }
                    //Same Record change their parent
                    else if((oldRec.ID == newRec.ID) && (oldRec.AccountID <> newRec.AccountID))
                    {                             
                        //system.debug('oldRec.Id ' + oldRec.ID + ' New Rec.ID ' + newRec.ID + ' old AccountId : ' + oldRec.AccountID + ' New Account Id : ' + newRec.AccountID);
                        oldRecId.add(oldRec.AccountId);                       
                        break;
                    }
                }
            }
         	update noParentRecUpdate;
			//system.debug('Old Record size is : ' + oldRecId.size());  
			//Reseq. to old Record who change their Account id.          
            if(oldRecId.size()>0)
            {
                Integer seq=1;
                List<Account> allParentRec = [select ID , (select lastName , AccountId , sequenceNumber__c, Employee_Salary__c from Contacts Order By sequenceNumber__c asc) from Account where ID IN : (oldRecId)];
                List<Contact> updateAllContact = new List<Contact>();
                //Resuq. to those records who had accountId is null but after the updation account id is not null
    			List<Contact> updateToNullRec = [select AccountId, sequenceNumber__c, lastName, Employee_Salary__c from Contact where AccountId=null ORDER BY sequenceNumber__c asc];
                for(Contact cont : updateToNullRec)
                {
                    cont.sequenceNumber__c = seq++;
                    cont.Employee_Salary__c = cont.Employee_Salary__c;
                    updateAllContact.add(cont);
                }
                update updateAllContact;
                updateAllContact.clear(); 
                seq=1;
                for(Account acc : allParentRec)
                {
                    for(Contact cont : acc.Contacts)
                    {
                        cont.sequenceNumber__c = seq++;
                        updateAllContact.add(cont);
                    }
                    seq=1;
                }
                update updateAllContact;
                updateAllContact.clear();   
                //system.debug('Update size after clear ' + updateAllContact.size());
            }
            
         // Recursive if Block Close   
        }		
        // after update function close
    }
    
    public void beforeUpdate(List<Contact> newContact , List<Contact> oldContact , Map <Id , Contact> oldContactRec)
    {             
        if(RecursiveController.recursionControllerMethod())
        {              
            boolean status = true ;
            boolean status1 = false;
            Map<Id , Integer> relatedRecordSize = new Map<Id , Integer>();
            List<Account> allParentRecord = [select Id, (select AccountId , lastName , sequenceNumber__c from Contacts ORDER BY sequenceNumber__c asc) from Account];
            for(Account acc : allParentRecord)
            {                
            	relatedRecordSize.put(acc.Id , acc.contacts.size());                
            }
            //Same Parent butt sequence Number change  
            set<ID> newRecId = new Set<ID>();        
            for( Contact oldRec : oldContact)
            {                       
                for(Contact NewRec : newContact)
                {           
                    if((newRec.SequenceNumber__c<1) )
                    {
                        newRec.SequenceNumber__c = oldRec.SequenceNumber__c;
                        status = false;
                    }
                    if(newRec.sequenceNumber__c > relatedRecordSize.get(newRec.AccountId))
                    {
                        //System.debug('Seq. Number is : ' + relatedRecordSize.get(newRec.AccountId));
                        newRec.SequenceNumber__c = oldRec.SequenceNumber__c;
                        status = false;
                    }                    
                    if((oldRec.ID == newRec.ID) && (oldRec.AccountId == newRec.AccountId) && (oldRec.SequenceNumber__c <> newRec.SequenceNumber__c))
                    {                        
                        newRecId.add(NewRec.AccountId);  
                        status = false;
                    }
                    if((oldRec.ID == newRec.ID) && (oldRec.AccountId == newRec.AccountId) && (oldRec.SequenceNumber__c <> null && newRec.sequenceNumber__c==null))
                    {
                       newRec.SequenceNumber__c = oldRec.SequenceNumber__c;                         
                    }                   
                    if((oldRec.ID == newRec.ID) && (oldRec.AccountId <> newRec.AccountId))
                    {                        
                        status1 = true;
                    }
                }
            }
			
            if(newRecId.size()>0)
            {                          
                List<Account> allParentRec = [select Id , (select sequenceNumber__c , lastName , AccountId from Contacts ORDER BY sequenceNumber__c asc ) from Account where ID In :(newRecID)];            
                Map<ID , List<Contact>> oldContactRecMap = new Map<Id , List<Contact>>();            
                
                for(Account acc : allParentRec)
                {
                    List<Contact> AssignContactToMap = new List<Contact>();   
                    for(Contact cont : acc.contacts)
                    {                    
                        AssignContactToMap.add(cont);                      
                    }               
                    oldContactRecMap.put(acc.ID, AssignContactToMap);                
                }			
               List<Contact> cont = new List<Contact>();
                for(Contact newRec : newContact)
                {                          
                    for(Contact oldContactSingleRec : oldContactRecMap.get(newRec.AccountId))
                    {   						
                        if((oldContactRec.get(newRec.Id).sequenceNumber__c) >= newRec.SequenceNumber__c)
                        {                            
                            if(newRec.Id == oldContactSingleRec.Id)
                            {
                                //system.debug('Break : ' + newRec.id);
                                break;
                            }
                            else if(newRec.SequenceNumber__c <= oldContactSingleRec.SequenceNumber__c)
                            {                                         
                                oldContactSingleRec.SequenceNumber__c = oldContactSingleRec.sequenceNumber__c + 1;                                
                                //system.debug(' Last Name is : ' +  oldContactSingleRec.LastName +  ' oldContactSingleRec.SequenceNumber__c : ' + oldContactSingleRec.SequenceNumber__c );
                                cont.add(oldContactSingleRec);
                            }
                        }
                        else 
                        {
                            if(oldContactSingleRec.sequenceNumber__c > newRec.SequenceNumber__c)
                            {
                                //system.debug('LastName : ' + oldContactSingleRec.LastName + ' Seq. : ' + oldContactSingleRec.sequenceNumber__c);
                                break;
                            }                            
                            else if((oldContactSingleRec.sequenceNumber__c > oldContactRec.get(newRec.Id).sequenceNumber__c) && (oldContactSingleRec.sequenceNumber__c <= newRec.SequenceNumber__c))
                            {
                                oldContactSingleRec.SequenceNumber__c = oldContactSingleRec.sequenceNumber__c - 1;                                
                                //system.debug(' Last Name is : ' +  oldContactSingleRec.LastName +  ' oldContactSingleRec.SequenceNumber__c : ' + oldContactSingleRec.SequenceNumber__c );
                                cont.add(oldContactSingleRec);
                            }  	                                             
                        }
                    }
                }    
                update cont;
            }  
            if(status1==true)
            {
                 // Change Parent of the record
                 // ReSeq. to new contact
                Set<ID> uId = new Set<ID>();        
                for(Contact cont : newContact)
                {
                    uid.add(cont.AccountId);
                }            
                List<Account> AccountParentRecord = [select ID , (select sequenceNumber__c , AccountId , LastName from Contacts ORDER BY sequenceNumber__c asc) from Account where ID IN :(uid)];
                List<Contact> updateToContact = new List<Contact>();
                Integer seq = 1;
               	//system.debug('AccountParentRecord : ' + AccountParentRecord);
                for(Account acc : AccountParentRecord)
                {
                    seq = acc.Contacts.size()+1;
                    for(Contact cont : newContact)
                    {            
                        if(cont.AccountId == acc.Id)
                        {
                            //system.debug('Record is : ' + cont.lastName + ' Size : ' + seq);
                            cont.SequenceNumber__c = seq++;
                            updateToContact.add(cont);
                        }
                    }
                    seq=1;
                }
            // status if block close
            }            
        // Recursive Block Close
        }                
    }
    
     public void afterUndelete(List<Contact> newRecord)
     {
         if(RecursiveController.recursionControllerMethod())
         {              
            Set<ID> uId = new Set<ID>();
             for(Contact cont : newRecord)
             {
                 uId.add(cont.AccountId);
             }
             List<Account> allParentRec = [select Id, (select AccountId , lastName , sequenceNumber__c from contacts ORDER BY sequenceNumber__c asc) from Account where ID IN :(uId)];
             
             Integer maxSize = 0;
             Map<ID , Integer> sizeOfRelatedRec = new Map<ID , Integer>();
             Map<ID , Integer> sizeOfNewRec = new Map<ID , Integer>();
             
             for(Account acc : allParentRec)
             {
                 sizeOfRelatedRec.put(acc.Id , acc.contacts.size());
                 //system.debug('Id is : ' + acc.id + ' Size of Related record is : ' + acc.contacts.size());
             }             
             for(ID newId : uId) 
             {             
                 for(Contact cont : newRecord)
                 {
                     if(newId == cont.AccountId)
                     {
                         maxSize++;
                     }
                 }    
                 sizeOfNewRec.put(newId , maxSize);
                 maxSize = 0;
             }
             List<Contact> temp = new List<Contact>();             
             
             for(Contact cont : newRecord)
             {                     
                 //system.debug('sizeOfNewRec.get(cont.AccountId) : ' + sizeOfRelatedRec.get(cont.AccountId));                
				 System.debug(' sizeOfNewRec.get(cont.AccountId)  : ' +  sizeOfNewRec.get(cont.AccountId) );                 
                 maxSize =  sizeOfRelatedRec.get(cont.AccountId) - sizeOfNewRec.get(cont.AccountId) + 1;                                                      
                //system.debug('maxSize : ' + maxSize);                                  
                 Contact con=new Contact(Id = cont.id , AccountId = cont.AccountId);                 
                 con.SequenceNumber__c = maxSize;                                                               
                 temp.add(con);                 
                 maxSize = sizeOfNewRec.get(cont.AccountId);
                 sizeOfNewRec.remove(cont.AccountId);
                 //Reduce the size by 1 from newRecord who have already updated
                 sizeOfNewRec.put(cont.AccountId , (maxSize-1));                                                               
             }
             update temp;
         }
     }
}