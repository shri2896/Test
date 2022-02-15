@isTest
public class TestRestrictContactByName {

    @TestSetup
    static void makeData(){
        List<Opportunity> oppLSt = new List<Opportunity>();
        List<Account> accLst = new List<Account>();

        for(Integer i = 0; i < 5; i++){
            oppLSt.add(new Opportunity(Name='test opp'));
        }
        insert oppLSt;

        for(Integer i = 0; i < 5; i++){
            accLst.add(new Account(Name='test Account'));
        }
        insert accLst;

        delete accLst[0];
    }
    
	// @isTest static void checkLastName(){
    //         List<contact> cont = new List<contact>{new contact(lastName='shri'),
    //             									new contact(lastName='invalidName')
                
    //         };       
    //         insert cont;
        	
    //     	for(contact c : cont){
    //             if(c.lastName!='invalidName'){
    //             	c.lastName = 'invalidName';
    //             }
    //         }
    //     update cont;
    // }
}