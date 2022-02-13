@RestResource(urlMapping='/Account/*')

global with sharing class AccountManager {
    public AccountManager() {

    }

    @HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        system.System.debug('request : ' + request);
        system.System.debug('request url : ' + request.requestURI);
        Id accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        system.System.debug('account Id : ' + accountId);

        Account acc = [Select Id, Name, (Select Id, Name, LastName from Contacts) from Account where ID = :accountId];

        return acc;
    }
}