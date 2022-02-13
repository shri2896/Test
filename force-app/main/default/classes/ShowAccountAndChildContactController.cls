public with sharing class ShowAccountAndChildContactController {
    // public ShowAccountAndChildContactController() {

    // }

    public List<Account> accLst{get;set;}
    public List<Contact> contLst{get;set;}
    public String recId{get;set;}
    
    public List<AccountContactWrapper> wrapperObj{get;set;}
    public List<Contact> contactList{get;set;}
    public Map<Id, Contact> contMap{get;set;}
    
    public ShowAccountAndChildContactController(){
    }

      

    public void fetchAccounts(){
        contMap = new Map<Id, Contact>();
        wrapperObj = new List<AccountContactWrapper>();        
        accLst = [Select Id, Name, Type, Industry, (Select id, Name, LastName from Contacts) from Account];

        for(Integer i = 0; i < accLst.size(); i++){
            AccountContactWrapper tempObj = new AccountContactWrapper();
            tempObj.id = accLst[i].Id;
            tempObj.name = accLst[i].Name;
            tempObj.type = accLst[i].Type;
            tempObj.industry = accLst[i].Industry;
            tempObj.cont = accLst[i].Contacts;            
            tempObj.hasShow = false;            

            system.debug('temp : ' + tempObj);

            wrapperObj.add(tempObj);                        
        }
		
        
            contactList = new List<Contact>();
            //contactList = [Select Id, LastName from Contact];
            
            for(Integer i = 0; i < contactList.size(); i++){
                //contMap.put(contactList[i].Id, contactList[i]);
            }
        system.System.debug('all accounts records are : ' + accLst);
    }

    public void fetchChildRecords(){        
        //contLst = [Select Id, Name, LastName, FirstName from Contact where AccountId = :recId];
        //showContactRecordTable = true;        

        for(Integer i = 0; i < wrapperObj.size(); i++){
            if(wrapperObj[i].id == recId){
                wrapperObj[i].hasShow = true;
            }
        }

        for(Integer i = 0; i < wrapperObj.size(); i++){
            system.debug('account id : ' + wrapperObj[i].id + ' Name : ' + wrapperObj[i].Name + ' show  : ' + wrapperObj[i].hasShow);
            system.debug('contact : ' + wrapperObj[i].cont);
        }

    }

    public class AccountContactWrapper{
        public Id id{get;set;}
        public String name{get;set;}
        public String type{get;set;}
        public String industry{get;set;}
        public List<Contact> cont{get;set;}
        public boolean hasShow{get;set;}
    }
}