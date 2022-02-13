public with sharing class KanbanController {
	public KanbanController() {
		
	}

	@AuraEnabled
	public static List<Drag_Drop_Wrapper> getAccountRecords(){
		List<Account>lstOfAccount = [Select Name, id, AccountNumber, Industry from Account Limit 100];		

		List<Drag_Drop_Wrapper> id_Name_lst = new List<Drag_Drop_Wrapper>();

		for(Account acc : lstOfAccount){
			id_Name_lst.add(new Drag_Drop_Wrapper(acc.name, acc.id, acc.AccountNumber, acc.Industry));
		}		
		return id_Name_lst;
	}
}