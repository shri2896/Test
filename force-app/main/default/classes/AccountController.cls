public with sharing class AccountController {  
  public static List<Account> getAllActiveAccounts() {    
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }

  public static List<Account> getAllActiveAccounts28() {    
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }
  
  public static List<Account> getAllActiveAccounts20() {    
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }

  public static List<Account> getAllActiveAccounts40() {    
    return [SELECT Id,Name,Active__c FROM Account WHERE Active__c = 'Yes'];
  }

}
