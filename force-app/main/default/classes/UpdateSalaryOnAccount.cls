/**
* @ Description :- When user insert any record in contact than contact trigger update their parent record and UpdateSalaryOnAccountHandler update the account's parent record subsquiently
* @ Author :- Shrikant Mittal
* @ Data :- 08/07/2019
*/

//When account's self lookup field will update(updation from CalculateSalaryTrigger trigger) than it will update their parent account record.
public with sharing class UpdateSalaryOnAccount {	
	
	static Map<ID, Integer> mapToParentIDSal = new Map<ID, Integer>();

	public static void onAfterUpdate(Map<ID, Account> mapOfUpdatedRecord, Map<ID, Account> mapOfOldRecord){		
		calculateSalaryForUpdateToParent(mapOfUpdatedRecord, mapOfOldRecord);		
	}

	//Check if new records salary are null than it will be change with 0
	public static void onBeforeInsert(List<Account> listOfNewRecords){
		isSalaryNull(listOfNewRecords);
	}

	//Make salary 0 if salary is null in inserted records
	public static void isSalaryNull(List<Account> listOfNewRecords){
		system.debug('call : ' + listOfNewRecords);
		
		for(Account acc : listOfNewRecords){
			if(acc.Total_Salary__c == null){
				acc.Total_Salary__c = 0;
			}
		}
	}

	//Make a map of parent record id and difference of old salary and new update record salary. Send to the other method for further processingd
	public static void calculateSalaryForUpdateToParent(Map<ID, Account> mapOfUpdatedRecord, Map<ID, Account> mapOfOldRecord){
		try{

			Map<ID, Integer> mapOfRecID_Sal = new Map<ID, Integer>();
			Map<ID, Integer> mapToDeductSalary = new Map<ID, Integer>();
			Map<ID, Account> mapToOldAccount = new Map<ID, Account>();
			Map<ID, Account> mapToNewAccount = new Map<ID, Account>();

			//Check for old contact record and new contact record parent both are same but changes in salary than it will update to the parent also.
			for(ID recId : mapOfUpdatedRecord.keyset()){
				
				//When changes in salary only. new updated salary is greater than old salary.
				if(mapOfUpdatedRecord.get(recId).Account_Parent__c == mapOfOldRecord.get(recId).Account_Parent__c && mapOfUpdatedRecord.get(recId).Total_Salary__c > mapOfOldRecord.get(recId).Total_Salary__c){
					Integer oldRecSal = Integer.valueOf(mapOfOldRecord.get(recId).Total_Salary__c);
					Integer newRecSal = Integer.valueOf(mapOfUpdatedRecord.get(recId).Total_Salary__c);
					Integer sal = 0;

					if(oldRecSal > newRecSal){
						sal = oldRecSal - newRecSal;
					}
					else{
						sal = sal + newRecSal - oldRecSal;
					}
					
					mapOfRecID_Sal.put(mapOfUpdatedRecord.get(recId).Account_Parent__c, sal);										
				}

				//When contact change their parent and new salary is lesser from old salary
				else if(mapOfUpdatedRecord.get(recId).Account_Parent__c == mapOfOldRecord.get(recId).Account_Parent__c && mapOfUpdatedRecord.get(recId).Total_Salary__c < mapOfOldRecord.get(recId).Total_Salary__c){
					Integer oldRecSal = Integer.valueOf(mapOfOldRecord.get(recId).Total_Salary__c);
					Integer newRecSal = Integer.valueOf(mapOfUpdatedRecord.get(recId).Total_Salary__c);
					Integer sal = 0;

					if(oldRecSal > newRecSal){
						sal = oldRecSal - newRecSal;
					}
					else{
						sal = sal + newRecSal - oldRecSal;
					}
					
					mapToDeductSalary.put(mapOfUpdatedRecord.get(recId).Account_Parent__c, sal);
				}

				//When account change their parent
				else if(mapOfUpdatedRecord.get(recId).Account_Parent__c != mapOfOldRecord.get(recId).Account_Parent__c){
					mapToOldAccount.put(recId, mapOfOldRecord.get(recId));
					mapToNewAccount.put(recId, mapOfUpdatedRecord.get(recId));

					system.debug('Account change parent trigger : ');
				}
			}


			//Add salary to the parent.
			if(!mapOfRecID_Sal.isEmpty()){
				updateParent(mapOfRecID_Sal);
			}

			//deduct salary from the parent
			if(!mapToDeductSalary.isEmpty()){
				deductToAccountSalary(mapToDeductSalary);
			}

			if(!mapToNewAccount.isEmpty()){
				updateAccountParent(mapToOldAccount, mapToNewAccount);
			}
		}
		catch(Exception err){
			system.debug('Error is : ' + err);
		}
	}

	public static void updateAccountParent(Map<ID, Account> mapToOldAccount, Map<ID, Account> mapToNewAccount){
		Map<ID, ID> mapToAccountParent = makeMapToParentId(mapToOldAccount);
		List<Account> accountParentLst = [Select ID, Name, Total_Salary__c, Account_Parent__c from Account Where ID IN :mapToAccountParent.values() LIMIT 50000];
		
		Map<ID, Account> mapToAccount = getParentIdAndRecordMap(accountParentLst);		

		mapToAccountParent.clear();

		mapToAccountParent = deductSalaryFromParent(mapToOldAccount, mapToAccount);

		system.debug('mapToAccountParent : ' + mapToAccountParent);

		if(mapToAccountParent != null){
			accountParentLst.clear();
			accountParentLst = [Select ID, Name, Total_Salary__c, Account_Parent__c from Account Where ID IN :mapToAccountParent.values() LIMIT 50000];
			
			system.debug('accountParentLst : ' + accountParentLst);

			mapToAccount.clear();			
			mapToAccount = getParentIdAndRecordMap(accountParentLst);
			deductSalaryFromTopParent(mapToAccount);
		}

	}

	//Deduct salary from direct parent of child account
	public static Map<ID, ID> deductSalaryFromParent(Map<ID, Account> mapToOldAccount, Map<ID, Account> mapToAccount){				

		List<Account> accountLstToUpdate = new List<Account>();
		Map<ID, ID> mapToParentRecId = new Map<ID, ID>();

		for(ID recId : mapToOldAccount.keyset()){
			Integer parentRecordSal = Integer.valueOf(mapToAccount.get(mapToOldAccount.get(recId).Account_Parent__c).Total_Salary__c);
			Integer childRecordSal = Integer.valueOf(mapToOldAccount.get(recId).Total_Salary__c);
			Integer salDiffrence = parentRecordSal - childRecordSal;

			mapToAccount.get(mapToOldAccount.get(recId).Account_Parent__c).Total_Salary__c = salDiffrence;
			
			accountLstToUpdate.add(mapToAccount.get(mapToOldAccount.get(recId).Account_Parent__c));

			if(mapToOldAccount.get(recId).Account_Parent__c != null){
				mapToParentRecId.put(recId, mapToOldAccount.get(recId).Account_Parent__c);
				//Get parent id and salary for deduction
				mapToParentIDSal.put(mapToAccount.get(recId).Account_Parent__c, childRecordSal);
			}
		}

		if(!accountLstToUpdate.isEmpty()){
			update accountLstToUpdate;	
		}

		return mapToParentRecId;
	}

	//Deduct salary from top level
	public static void deductSalaryFromTopParent(Map<ID, Account> mapToAccount){				

		List<Account> accountLstToUpdate = new List<Account>();

		for(ID recId : mapToAccount.keyset()){
			Integer parentRecordSal = Integer.valueOf(mapToAccount.get(recId).Total_Salary__c);
			Integer childRecordSal = Integer.valueOf(mapToParentIDSal.get(recId));
			Integer salDiffrence = parentRecordSal - childRecordSal;

			mapToAccount.get(recId).Total_Salary__c = salDiffrence;			
			accountLstToUpdate.add(mapToAccount.get(recId));			
		}

		if(!accountLstToUpdate.isEmpty()){
			update accountLstToUpdate;	
		}
	}

	//Return map of recId and parent account id.
	public static Map<ID, ID> makeMapToParentId(Map<ID, Account> mapToOldAccount){
		Map<ID, ID> mapToAccountParent = new Map<ID, ID>();

		for(ID recId : mapToOldAccount.keySet()){
			mapToAccountParent.put(recId, mapToOldAccount.get(recId).Account_Parent__c);
		}

		return mapToAccountParent;
	}

	//Return map of account id and account
    public static Map<ID, Account> getParentIdAndRecordMap(List<Account> accountLst){
        Map<ID, Account> mapToAccount = new Map<ID, Account>();

        for(Account acc : accountLst){
            mapToAccount.put(acc.Id, acc);
        }

        return mapToAccount;
    }   

	//Add salary to the parent account
	public static void updateParent(Map<ID, Integer> mapOfRecToUpdateSal){
		try{

			//Fetch parent record from parent id
			List<Account> lstOfAccountToUpdateToParent = [Select ID, Account_Parent__c, Total_Salary__c, Name from Account Where ID IN :mapOfRecToUpdateSal.keyset() LIMIT 50000];
			List<Account> updateToAccount = new List<Account>();
			
			if(!lstOfAccountToUpdateToParent.isEmpty()){
				for(Account acc : lstOfAccountToUpdateToParent){
					Integer sal = Integer.valueOf(acc.Total_Salary__c);
					
					sal = sal + mapOfRecToUpdateSal.get(acc.Id);
					acc.Total_Salary__c = sal;
					updateToAccount.add(acc);
				}

				update updateToAccount;				
				updateSalaryToParent();
			}			
			
		}
		catch(Exception err){
			system.debug('Error in updateParent method : ' + err);
		}
	}

	//Deduct salary from the parent when changes in salary field
	public static void deductToAccountSalary(Map<ID, Integer> mapOfRecToUpdateSal){
		
		//Prevent trigger in the case of when except only changes in the salary in the contact records.
		if(PreventingRecursiveTrigger.preventTrigger){
			List<Account> lstOfAccountToUpdateToParent = [Select ID, Account_Parent__c, Total_Salary__c, Name from Account Where ID IN :mapOfRecToUpdateSal.keyset()];

			List<Account> updateToAccount = new List<Account>();

			if(!lstOfAccountToUpdateToParent.isEmpty()){
				for(Account acc : lstOfAccountToUpdateToParent){
					Integer sal = Integer.valueOf(acc.Total_Salary__c);
					
					sal =   sal - mapOfRecToUpdateSal.get(acc.Id) ;
					acc.Total_Salary__c = sal;
					updateToAccount.add(acc);
				}

				update updateToAccount;

				updateSalaryToParent();
			}
		}		
	}

	//Update salary to the parent object(Total_Salary__c)
	public static void updateSalaryToParent(){
		system.debug('update sal parent call : ');
		List<Account> accountLst = [Select Name, Account_Parent__c, Total_Salary__c from Account];
		Integer totalSal = 0;

		//Get all the records who is direct parent records.
		for(Account acc : accountLst){
			if(acc.Account_Parent__c == null && acc.Total_Salary__c != null){
				if(acc.Total_Salary__c > 0){
				}
				totalSal = totalSal + Integer.valueOf(acc.Total_Salary__c);					
			}
		}

		Total_Salary__c updateToSal = [Select Total_Salary__c from Total_Salary__c LIMIT 1];
		updateToSal.Total_Salary__c = totalSal;
		update updateToSal;
	}
	
}