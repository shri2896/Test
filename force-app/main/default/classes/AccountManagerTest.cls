@isTest
public with sharing class AccountManagerTest {
    public AccountManagerTest() {

    }

    @isTest static void getAccount(){
        Account acc = new Account();
        acc.name = 'shri';
        insert acc;

        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.salesforce.com/services/apexrest/Account/'+ acc.Id;
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account a = AccountManager.getAccount();
        system.System.debug('account create successully : ' + a);
    }
    
}


/*

change in doc :-
1) Piramal_PTM_Doc :- <div style="font-size:10pt;"> to <div style="font-size:9pt;">
                    <p align="justify" style="font-size:14px"> to <p align="justify" style="font-size:12px"> ex :- We assure you that the said unit and the land appurte
                    <p style="font-size:15px">Thanking you,</p> to <p style="font-size:14px">Thanking you,</p>

2) SOA_Doc :-       <div style="font-size:10pt;"> <p align="justify"><b>Notes</b></p> to <div style="font-size:9.5pt;"> <p align="justify"><b>Notes</b></p>

More content :- Reminder1_Doc, Reminder2_Doc, Reminder3_Doc, Reminder4_Doc, Transfer_Nomination_Letter_Doc


error :- Timely_Payment_Rebate_Letter_doc



*/