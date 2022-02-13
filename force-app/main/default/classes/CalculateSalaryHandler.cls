/*
* @ Description :- CalculateSalaryHandler for when user insert, update, delete any contact record than it will recalculate the parent record salary.
* @ Author :- Shrikant Mittal
* @ Data :- 08/07/2019
*/

//as per the context of Trigger(CalculateSalaryTrigger) and available registered handlers method of this handler will call
public with sharing class CalculateSalaryHandler 
{      

    static Map<ID, ID> mapOfParentRecord = new Map<ID, ID>();
    static Map<ID, Integer> mapOfSalaryDifference = new Map<ID, Integer>();

    public static void onAfterInsert(Map<ID, Contact> insertedContact){

        Map<ID, Integer> mapOfInsertedRecId_Salary = updateRecordSalaryOnInsert(insertedContact);  
        updateToAccountSalaryField(mapOfInsertedRecId_Salary);      
    }    

    public static void onAfterUpdate(Map<ID, Contact> mapOfUpdatedRecord, Map<ID, Contact> mapOfOldContact){
        updateContact(mapOfUpdatedRecord, mapOfOldContact);
    }

    public static void onAfterDelete(Map<ID, Contact> mapOfOldContact){
        removeParent(mapOfOldContact);
    }

    public static void onUndelete(Map<ID, Contact> mapofNewContact){
        Map<ID, Integer> mapOfInsertedRecId_Salary = updateRecordSalaryOnInsert(mapofNewContact);  
        updateToAccountSalaryField(mapOfInsertedRecId_Salary);
    }


    //Calculate the salary for each parent record and assign it to the map with recid and calculated salary
    public static Map<Id, Integer> updateRecordSalaryOnInsert(Map<ID, Contact> insertedContact){
        Map<ID, Integer> mapOfInsertedRecId_Salary = new Map<ID, Integer>();
                
        for(ID recId : insertedContact.keySet()){

            //When record not contain in the map
            if(mapOfInsertedRecId_Salary.get(insertedContact.get(recId).AccountId) == null){
                mapOfInsertedRecId_Salary.put(insertedContact.get(recId).AccountId, Integer.valueOf(insertedContact.get(recId).Employee_Salary__c));
            }
            else{

                ID accId = insertedContact.get(recId).AccountId;
                Integer updatedSal = Integer.valueOf(insertedContact.get(recId).Employee_Salary__c);
                Integer oldSal = mapOfInsertedRecId_Salary.get(insertedContact.get(recId).AccountId);
                updatedSal = updatedSal + oldSal;

                if(accId != null){
                    mapOfInsertedRecId_Salary.put(accId, updatedSal);
                }
                else{
                    mapOfInsertedRecId_Salary.put(accId, updatedSal);
                }                
            }
        }        

        return mapOfInsertedRecId_Salary;        
    }       

    //Check the condition Either parent change or salary change or both.
    public static void updateContact(Map<ID, Contact> mapOfUpdatedContact, Map<ID, Contact> mapOfOldContact){

        //When contact change their parent. it will hold all the new parent of the contact
        Map<ID, Contact> mapOfChangeParent = new Map<ID, Contact>();

        //When contact change their parent. it will hold all the old contact record for deduct salary
        Map<ID, Contact> mapOfRemoveParent = new Map<ID, Contact>();   
       
       //When only salary change.
        Map<ID, Contact> mapToAddSalary = new Map<ID, Contact>();
        Map<ID, Contact> mapToDeductSalary = new Map<ID, Contact>();
        
        for(ID recId : mapOfUpdatedContact.keyset()){

            //When only parent account change and salary remains same
            if(mapOfUpdatedContact.get(recId).AccountId != mapOfOldContact.get(recId).AccountId && mapOfUpdatedContact.get(recId).Employee_Salary__c == mapOfOldContact.get(recId).Employee_Salary__c){
                mapOfChangeParent.put(recId, mapOfUpdatedContact.get(recId));
                mapOfRemoveParent.put(recId, mapOfOldContact.get(recId));
            }
            
            //When only salary change and parent account remains same
            else if(mapOfUpdatedContact.get(recId).AccountId == mapOfOldContact.get(recId).AccountId && mapOfUpdatedContact.get(recId).Employee_Salary__c != mapOfOldContact.get(recId).Employee_Salary__c){
                if(mapOfUpdatedContact.get(recId).Employee_Salary__c > mapOfOldContact.get(recId).Employee_Salary__c){
                    mapToAddSalary.put(recId, mapOfUpdatedContact.get(recId));
                }
                else if(mapOfUpdatedContact.get(recId).Employee_Salary__c < mapOfOldContact.get(recId).Employee_Salary__c){
                    mapToDeductSalary.put(recId, mapOfUpdatedContact.get(recId));
                }

            }
            
            //When parent account and salary both are change
            else if(mapOfUpdatedContact.get(recId).AccountId != mapOfOldContact.get(recId).AccountId && mapOfUpdatedContact.get(recId).Employee_Salary__c != mapOfOldContact.get(recId).Employee_Salary__c){
                mapOfChangeParent.put(recId, mapOfUpdatedContact.get(recId));
                mapOfRemoveParent.put(recId, mapOfOldContact.get(recId));
            }            
            
            else{
                system.debug('else....!!!!');
            }
        }

        if(!mapOfChangeParent.isEmpty()){
            Map<ID, Integer> mapOfInsertedRecId_Salary = updateRecordSalaryOnInsert(mapOfChangeParent);
            updateToAccountSalaryField(mapOfInsertedRecId_Salary);
        }

        if(!mapOfOldContact.isEmpty()){
            removeParent(mapOfRemoveParent);
        }       

        if(!mapToAddSalary.isEmpty()){
            salaryToAdd(mapToAddSalary, mapOfOldContact);
        }

        if(!mapToDeductSalary.isEmpty()){
            deductSalaryToAccount(mapToDeductSalary, mapOfOldContact);
        }
    }    


    //Update to account for those records who have record inserted in their contact
    public static void updateToAccountSalaryField(Map<ID, Integer> recMapToUpdateToSalaryField){
        //Prevent trigger to execute preventTrigger method
        PreventingRecursiveTrigger.preventTrigger = false;

        List<Account> lstAccount = [Select Name, Total_Salary__c, Account_Parent__c, ID from Account where ID IN :recMapToUpdateToSalaryField.keySet()];
        List<Account> recToUpdate = new List<Account>();

        for(Account acc : lstAccount){
            //system.debug('acc.Total_Salary__c : ' + recMapToUpdateToSalaryField.get(acc.ID));
            acc.Total_Salary__c = acc.Total_Salary__c + recMapToUpdateToSalaryField.get(acc.ID);
            recToUpdate.add(acc);
        }

        update recToUpdate;

        UpdateSalaryOnAccount.updateSalaryToParent();
    }

    //Deduct salary from those record from where child transfer to another parent record.
    public static void removeParent(Map<ID, Contact> mapToRemoveParent){
        //Prevent trigger to execute preventTrigger method
        PreventingRecursiveTrigger.preventTrigger = false;
        //system.debug('remove to parent : ' + mapToRemoveParent);
        Map<ID, Integer> mapOfOldRecord = updateRecordSalaryOnInsert(mapToRemoveParent);
        List<Account> accountLst = [Select Id, Total_Salary__c, Account_Parent__c from Account where ID IN :mapOfOldRecord.keySet()];    

        //system.debug('account lst : ' + accountLst);
        //system.debug('mapOfOldRecord : ' + mapOfOldRecord);
        if(!accountLst.isEmpty()){
            updateSalary(accountLst, mapOfOldRecord);
        }
                
        List<Account> lstOfAccount = [Select Id, Total_Salary__c, Account_Parent__c from Account where ID IN :mapOfParentRecord.values()];

        //system.debug('lstOfAccount : ' + lstOfAccount);
        if(!lstOfAccount.isEmpty()){
            updateSalaryParentToParent(lstOfAccount);
        }

        lstOfAccount.clear();

        lstOfAccount = [Select Id, Total_Salary__c, Account_Parent__c from Account where ID IN :mapOfParentRecord.values()];

        ///system.debug('lstOfAccount : ' + lstOfAccount);
        if(!lstOfAccount.isEmpty()){
            updateSalaryAtFinalLevel(lstOfAccount);
        }

    }

    //Update salary for direct parent of a contact
    public static void updateSalary(List<Account> accountLst, Map<ID, Integer> mapOfOldRecord){
        List<Account> accountToUpdate = new List<Account>();

        mapOfParentRecord.clear();
        mapOfSalaryDifference.clear();

        for(Account acc : accountLst){

            mapOfParentRecord.put(acc.ID, acc.Account_parent__c);

            Integer oldSal = Integer.valueOf(acc.Total_Salary__c);
            oldSal = Integer.valueOf(oldSal - mapOfOldRecord.get(acc.Id));            
            acc.Total_Salary__c = oldSal;
            mapOfSalaryDifference.put(acc.Account_Parent__c, mapOfOldRecord.get(acc.Id));
            accountToUpdate.add(acc);
        }

        update accountToUpdate;

        UpdateSalaryOnAccount.updateSalaryToParent();
    }

    //Update salary level 3 to 2
    public static void updateSalaryParentToParent(List<Account> accountLst){
        mapOfParentRecord.clear();
        List<Account> accountToUpdate = new List<Account>();

        for(Account acc : accountLst){
            mapOfParentRecord.put(acc.ID, acc.Account_parent__c);
            acc.Total_Salary__c = acc.Total_Salary__c - (mapOfSalaryDifference.get(acc.Id));
            //mapOfSalaryDifference.put(acc.Account_Parent__c, mapOfOldRecord.get(acc.Id));
            mapOfSalaryDifference.put(acc.Account_Parent__c, mapOfSalaryDifference.get(acc.Id));
            accountToUpdate.add(acc);
        }

        update accountToUpdate;

        UpdateSalaryOnAccount.updateSalaryToParent();
    }

    //Update salary at level 2 to 1;
    public static void updateSalaryAtFinalLevel(List<Account> accountLst){

        mapOfParentRecord.clear();
        List<Account> accountToUpdate = new List<Account>();

        for(Account acc : accountLst){
            acc.Total_Salary__c = acc.Total_Salary__c - (mapOfSalaryDifference.get(acc.Id));
            accountToUpdate.add(acc);
        }

        update accountToUpdate;
        UpdateSalaryOnAccount.updateSalaryToParent();
    }
    

    //When only change in salary and updated salary is greater from old. add salary to their parent.
    public static void salaryToAdd(Map<Id, Contact> mapToIncreasedSalaryRecord, Map<ID, Contact> mapToOldContact){
        Map<ID, ID> mapToIdAndParentId = getParentIdAndRecordMap(mapToIncreasedSalaryRecord);
        List<Account> accountLst = [Select ID, Name, Total_Salary__c, Account_Parent__c from Account where ID IN :mapToIdAndParentId.values()];
        Map<ID, Account> mapToIdAccount = mapToIdAccount(accountLst);

        accountLst.clear();

        //For update salary in the account of direct parent of the contact. and remining parent account update by the 'UPDATESALARYONACCOUNT' trigger.
        for(ID recId : mapToIncreasedSalaryRecord.keyset()){
            Integer sal = 0;

            if(mapToIncreasedSalaryRecord.get(recId).Employee_Salary__c - mapToOldContact.get(recId).Employee_Salary__c != null){
                sal = Integer.valueOf(mapToIncreasedSalaryRecord.get(recId).Employee_Salary__c - mapToOldContact.get(recId).Employee_Salary__c);
            }
            
            if(mapToIdAccount.get(mapToIncreasedSalaryRecord.get(recId).AccountId).Total_Salary__c != null){
                sal = sal + Integer.valueOf(mapToIdAccount.get(mapToIncreasedSalaryRecord.get(recId).AccountId).Total_Salary__c);
            }
            
            mapToIdAccount.get(mapToIncreasedSalaryRecord.get(recId).AccountId).Total_Salary__c = sal;
            accountLst.add(mapToIdAccount.get(mapToIncreasedSalaryRecord.get(recId).AccountId));
        }        

        update accountLst;

    }

    //when only changes in salary. it will deduct salary from parent object and remaining updation by account trigger
    public static void deductSalaryToAccount(Map<Id, Contact> mapToReduceSalary, Map<ID, Contact> mapToOldContact){
        
        //Allow account trigger to access preventTrigger method for update parent to parent salary updation.
        PreventingRecursiveTrigger.preventTrigger = true;

        Map<ID, ID> mapToIdAndParentId = getParentIdAndRecordMap(mapToReduceSalary);
        List<Account> accountLst = [Select ID, Name, Total_Salary__c, Account_Parent__c from Account where ID IN :mapToIdAndParentId.values()];
        Map<ID, Account> mapToIdAccount = mapToIdAccount(accountLst);

        //reuse for record updation
        accountLst.clear();

        //For update salary in the account of direct parent of the contact. and remining parent account update by the 'UPDATESALARYONACCOUNT' trigger.
        for(ID recId : mapToReduceSalary.keyset()){
            Integer sal = Integer.valueOf(mapToOldContact.get(recId).Employee_Salary__c - mapToReduceSalary.get(recId).Employee_Salary__c );

            sal = Integer.valueOf(mapToIdAccount.get(mapToReduceSalary.get(recId).AccountId).Total_Salary__c) - sal;

            mapToIdAccount.get(mapToReduceSalary.get(recId).AccountId).Total_Salary__c = sal;
            accountLst.add(mapToIdAccount.get(mapToReduceSalary.get(recId).AccountId));
        }        

        update accountLst;
    }

    //Return map of contact id and parent recordId(AccountId)
    public static Map<ID, ID> getParentIdAndRecordMap(Map<ID, Contact> mapOfOldContact){
        Map<ID, ID> mapToRecIdAndParentId = new Map<ID, ID>();

        for(ID recId : mapOfOldContact.keySet()){
            mapToRecIdAndParentId.put(recId, mapOfOldContact.get(recId).AccountId);
        }

        return mapToRecIdAndParentId;
    }   

    //Conver list<Account> to Map<ID, Account>
    public static Map<ID, Account> mapToIdAccount(List<Account> accountLst){
        Map<ID, Account> mapOfIdAccount = new Map<ID, Account>();

        for(Account acc : accountLst){
            mapOfIdAccount.put(acc.Id, acc);
        }

        return mapOfIdAccount;
    }

}