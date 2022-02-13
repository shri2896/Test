@isTest
public class CalculateSalaryHandlerTest {
	
    public static testMethod void checkSalary(){
		//CalculateSalaryHandler.updateRecordSalaryOnInsert();
		Total_Salary__c totalSal = new Total_Salary__c();
        totalSal.Total_Salary__c = 0;
        insert totalSal;
        Account acc = new Account();
        acc.Total_Salary__c = 1000;
        acc.Name = 'shri';
        
        insert acc;
        
        Account acc1 = new Account();
        acc1.Total_Salary__c = 1000;
        acc1.Name = 'shri';
        acc1.Account_Parent__c = acc.Id;
        insert acc1;
		
         Account acc2 = new Account();
        acc2.Total_Salary__c = 1000;
        acc2.Name = 'shri';
        acc2.Account_Parent__c = acc1.Id;
        insert acc2;
        
		List<Contact> lstCont = new List<Contact>();
		Contact cont = new Contact();
        
        for(Integer i = 0; i < 5; i++){
            cont = new Contact();
            cont.AccountID = acc2.Id;
            cont.Employee_Salary__c = 1000;
            cont.lastName = 'Shri'+i;
            lstCont.add(cont);
        }
        insert lstCont;   
            
        lstCont[0].AccountId = acc1.Id;
        update lstCont[0];        
                
        lstCont[0].Employee_Salary__c = 5000;
        update lstCont[0];
        
        lstCont[0].Employee_Salary__c = 500;
        update lstCont[0];
        
        lstCont[0].Employee_Salary__c = 1000;
        lstCont[0].AccountId = acc2.Id;
        update lstCont[0];
        
        delete lstCont;
        
        lstCont.clear();
        lstCont = [Select ID, Employee_Salary__c from Contact All Rows];
        undelete lstCont;
    }
}