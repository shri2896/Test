/**
* @ Description :- For update contact mailing city field
* @ Author :- Shrikant Mittal
* @ Data :- 15/07/2019
*/

//Update Contact.Mailing city when account.billingcity change and check when account.status__c change from active to not active chk all the child records to if they have any open oppertunity.
public class ChangeMailingCity {
	
    

	public static void onBeforeUpdate(Map<ID, Account> mapToUpdateAccount){        
        checkOpportunityIsOpen(mapToUpdateAccount);
    }    

    //if account status change check it has any open oppertunity in their child records. if presents then prevent to the user for change the status from active to not active
    public static void checkOpportunityIsOpen(Map<ID, Account> mapToUpdateAccount){

    	Map<ID, Account> mapOfChange = new Map<ID, Account>();

    	//check status is update or not
    	for(ID recId : mapToUpdateAccount.keyset()){
    		if(mapToUpdateAccount.get(recId).Status__c == 'Not Active'){
    			mapOfChange.put(recId, mapToUpdateAccount.get(recId));
    		}
    	}


    	//Get all the records who have open oppertunity so we can add error on those records.
    	List<Opportunity> lstOfOppertunity = [SELECt Id, StageName, AccountID FROM Opportunity where AccountID IN :mapOfChange.keyset() AND StageName NOT IN ('Closed Lost', 'Closed Won') LIMIT 50000 ];

    	for(Opportunity opp : lstOfOppertunity){
    		String errorMsg = mapOfChange.get(opp.AccountID).Name + ' has an open opportunity.';
    		
    		mapOfChange.get(opp.AccountID).adderror(errorMsg);
    	}    	
    }

}