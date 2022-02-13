/**
* @ Description :- Test class for ChangeMailingCity
* @ Author :- Shrikant Mittal
* @ Data :- 15/07/2019
*/

@isTest
public class ChangeMailingCityTest {
	
    public static testMethod void testUpdateCity(){
        List<Account> accountLst = new List<Account>();
        for(Integer i = 0; i < 10; i++){
            Account acc = new Account();
            acc.Name = 'shri'+i;
            acc.Status__c = 'Active';
            acc.BillingCity = 'Amesterdum';
            accountLst.add(acc);            
        }
        
        if(!accountLst.isEmpty()){
            insert accountLst;
        }
        
        Contact cont = new Contact();
        cont.AccountId = accountLst[0].Id;
        cont.LastName = 'Cont1';
        
        insert cont;
        
        Opportunity opertunity = new Opportunity();
        opertunity.AccountId = accountLst[0].Id;
        opertunity.CloseDate = Date.newInstance(2019, 07, 19);
        opertunity.StageName = 'Prospecting';
        opertunity.Name = 'Opp1';

        insert opertunity;
        
        Account acc = [Select ID, Status__c, BillingCity from Account LIMIT 1];
        
        acc.BillingCity = 'LA';        
        insert acc;        
        acc.Status__c = 'Not Active';
        acc.BillingCity = 'LA';

        insert acc;
    }
}