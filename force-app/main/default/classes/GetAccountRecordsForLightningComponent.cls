public class GetAccountRecordsForLightningComponent {
	
    @AuraEnabled
    public static kanbanWrap getAccount(Integer pNumber, Integer pSize){
        //List<Account> acc = [Select name, Type,Industry,AccountNumber, Phone, Sic, LastModifiedDate from Account];
        System.debug('  pageNumber, Integer pageSize : ' +  pNumber + ' : ' +  pSize);       
        Integer offset = (pNumber - 1) * pSize;
        Integer totalRecords = [SELECT COUNT() FROM Account];        
        Integer recordEnd = pSize * pNumber;
        

        kanbanWrap objDT =  new kanbanWrap();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.records = [SELECT Id, Name, Phone, Type, Industry, AccountNumber, Sic, LastModifiedDate,(Select Id, Name from Contacts)  FROM Account ORDER BY Name LIMIT :pSize OFFSET :offset]; 

        //List<Account> acc = [Select name, type, Industry, AccountNumber, phone, Sic, LastModifiedDate, (Select Id, Name from Contacts) from Account ORDER BY Name LIMIT :pSize OFFSET :offset];
        System.debug('records : ' + objDT.records);
        return objDT;
    }
    
    @AuraEnabled
    public static List<Account> insertRecord(Account acc){
        insert acc;
        List<Account> accLst = [Select name, Type,Industry,AccountNumber, Phone, Sic, LastModifiedDate from Account];
        for(Account a: accLst){
        	System.debug('Rec after insert : ' + a);
        }
      
        return accLst;
    }
    
    @AuraEnabled
    public static List<Account> deleteRec(Id recId){
        //System.debug('Del record is : ' + recId);
      	Account acc = Database.query('Select id from Account where Id = :recId');
        //System.debug('Del record is : ' + acc);
        delete acc;
        List<Account> accLst = [Select Name, Id, AccountNumber, AnnualRevenue, LastModifiedDate, Phone from Account];
        //System.debug('List size is : ' + accLst.size());
        return accLst;
    }
    
    @AuraEnabled
    public static Account editRecord(Id recId){
        //System.debug('Enter recId : ' + recId);
        Account rec = Database.query('Select Id, name, Type,Industry,AccountNumber, Phone, Sic, LastModifiedDate from Account where Id = :recId ');
		//System.debug('Edit record : ' + rec);
        return rec;
    }
    
    @AuraEnabled
    public static List<Account> saveUpdateRecord(Account acc){               
       	update  acc;
        List<Account> accLst = [Select Name, Id, AccountNumber, AnnualRevenue, LastModifiedDate, Phone from Account];
        return accLst;
    }
    
    @AuraEnabled
    public static List<Account> showRelatedRecord(Id recId){        
        List<Account> contLst = new List<Account>();
        contLst = Database.query('Select Id, Name, Type, AccountNumber, AnnualRevenue, LastModifiedDate,  (Select Id, Name from Contacts) from Account where Id = :recId');
        //System.debug('All related Account is : ' + contLst);
       
        for(Account acc : contLst){
        	//System.debug('All related Contact is : ' + acc.Contacts);
        }
        return contLst;
    }
    
    @AuraEnabled
    public static List<Contact> createNewContactRecord(Contact cont, Id accId){
        insert cont;
        System.debug('Id : ' + accid);
        List<Contact> lstOfContact = Database.query('Select Name, Id from Contact where AccountId = :accId');
        
        return lstOfContact;
    }
    
    @AuraEnabled
    public static List<Contact> deleteRecord(List<Id> rec){
        
        if(rec.size()>0){                        
            List<Contact> cont = new List<Contact>();
            cont = Database.query('Select Name, Id, AccountId from Contact where ID IN :rec');  
            Id accId = cont[0].AccountId;
            //System.debug('del : ' + cont);
			delete cont;            
            cont = Database.query('Select Name, Id, AccountId from Contact where AccountId = :accId');
            //System.debug('new cont : ' + cont.size());
            return cont;
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Account> insertData(List<Account> lstOfAcc){        
        //System.debug('Data : ' + lstOfAcc);
        insert lstOfAcc;
        List<Account> data = [Select name, type, Industry, AccountNumber, phone, Sic, LastModifiedDate, (Select Id, Name from Contacts) from Account LIMIT  200];
        return data;
    }
    
    //Kanban
    
    @AuraEnabled    
    public static kanbanWrap getKanbanWrap(String objName, List<String>flds, String kanbanField){        
        
    	List<String> lstPickvals=new List<String>();
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues()){        	
            lstPickvals.add(a.getValue());            
        }
    
        String query = 'SELECT Id, ';
        for(String s:flds){
            query += s+' ,';
        }       
        
        query += '(Select Id, Name from Contacts) FROM ' + objName;       
        //System.debug('flds : ' + Database.query(query));
        List<Account> lst = Database.query(query);
       
        return new kanbanWrap(Database.query(query), lstPickvals);	  
    }   
    
     @AuraEnabled
    public static String getUpdateStage(Id recId, String FieldName, String dragValue) {       
        SObject sobj = recId.getSObjectType().newSObject(recId);
        //System.debug('sobj : ' + sobj);
        sobj.put(FieldName,dragValue);
        update sobj;
        return 'Success';
    }
    
    @AuraEnabled
    public static void getAccountData(Integer pageNumber, Integer pageSize){
        Integer pSize = pageSize;        
        Integer pNumber = pageNumber;        
        Integer offset = (pNumber - 1) * pSize;
        Integer totalRecords = [SELECT COUNT() FROM Account];        
        Integer recordEnd = pSize * pNumber;
        

        kanbanWrap objDT =  new kanbanWrap();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.records = [SELECT Id, Name, Phone, Type, Industry, AccountNumber, Sic, LastModifiedDate  FROM Account ORDER BY Name LIMIT :pSize OFFSET :offset];   
        //System.debug('Limited rec : ' + objDT.AccountList.size());      
    }
 	   
}