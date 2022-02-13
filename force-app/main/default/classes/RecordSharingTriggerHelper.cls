/**
* @ description : RecordSharingTriggerHelper handler use in RecordSharingTrigger(Trigger) for implement the change sharing setting when record insert or update. 
* @ author      : Shrikant Mittal
* @ date        : 28/06/2019
*/

//For record sharing trigger when matter memeber record insert, update, delete or undele
public with sharing class RecordSharingTriggerHelper {

	static Map<ID, ID> recToRemoveAccess = new Map<ID, ID>();
	static Map<ID, ID> recToAssignAccess = new Map<ID, ID>();

	public static List<Matter_Member__c> onBeforeInsert(List<Matter_Member__c> lstOfNewRec){
		List<Matter_Member__c> lstOfMatterMember = checkRelatedRecExistsOrNot(lstOfNewRec);
		return lstOfMatterMember;
	}

	public static List<Matter_Member__c> checkRelatedRecExistsOrNot(List<Matter_Member__c> lst){
		Set<ID> recId = new Set<ID>();
		for(Matter_Member__c matter : lst){
			recId.add(matter.MatterName__c);
		}

		List<Matter__c> matterLst = new List<Matter__c>();
		Set<ID> recHasNoChild = new Set<ID>();

		matterLst = [Select Name, FirstUserName__c,(Select MatterName__c from Matter_Members__r) from Matter__c where ID IN :recId LIMIT 5000];

		for(Matter__c m : matterLst){
			if(m.Matter_Members__r.size() > 0){
				system.debug('Child exists for the following record : ' + m);
			}
			else{
				recHasNoChild.add(m.ID);
				system.debug('Child notexists for the following record : ' + m);
			}
		}
		system.debug('ID ' + recHasNoChild);
		system.debug('lstOfNewRec ' + lst);

		List<Matter_Member__c> newRecLst = new List<Matter_Member__c>();

		for(Matter_Member__c mater : lst){
			if(recHasNoChild.contains(mater.MatterName__c)){
				mater.isFirstUser__c = true;
			}
			newRecLst.add(mater);
		}

		/*for(Matter_Member__c m : newRecLst){
			system.debug('all new rec lst : ' + m);
		}		*/

		if(!newRecLst.isEmpty()){
			return newRecLst;
		}
		else{
			return null;
		}

	}

	//Call when user creates a new record of matter member and it will be set sharing of new inserted record
	public static void onAfterInsert(List<Matter_Member__c> lstOfNewRec){
		checkIsFirstRecord(lstOfNewRec);		
		insertRecord(lstOfNewRec);
	}

	//Call when user updateAny record it will change the sharing setting and remove from old record
	public static void onAfterUpdate(List<Matter_Member__c> updatedRec, List<Matter_Member__c> recordsBeforeUpdate, Map<ID, Matter_Member__c> mapOfUserName_ID){		
		updateRecordSharing(updatedRec, recordsBeforeUpdate, mapOfUserName_ID);
	}

	//When matter member record delete
	public static void onAfterDelete(Map<ID, Matter_Member__c> mapOfDelRec){
		try{

			//Change Map<ID, MatterMember> to Map<ID, ID>
			for(ID recId : mapOfDelRec.keySet()){
				recToRemoveAccess.put(mapOfDelRec.get(recId).MatterName__c, mapOfDelRec.get(recId).User__c);
			}

			if(!recToRemoveAccess.isEmpty()){
				removeSharing(recToRemoveAccess);
			}

			removeFirstUserName(mapOfDelRec);
		}
		catch(Exception err){
			system.debug('Error in onAfterDelete ' + err);
		}
	}


	//When record undelete to sharing
	public static void onAfterUndelete(List<Matter_Member__c> listOfUndelRec){
		try{
			checkIsFirstRecord(listOfUndelRec);
			insertRecord(listOfUndelRec);		
		}
		catch(Exception err){
			system.debug('Exception in onAfterUndelete : ' + err);
		}
	}

	//Call when insert new record in matter member object
	public static void insertRecord(List<Matter_Member__c> lstOfNewRec){

		try{

			Map<ID, ID> mapOfUserName_ID = new Map<ID, ID>();
			for(Matter_Member__c matterMember : lstOfNewRec){
				if(matterMember.User__c != null){
					mapOfUserName_ID.put(matterMember.MatterName__c, matterMember.User__c);
				}
			}
			
			addSharing(mapOfUserName_ID);
			
	    }
	    catch(Exception error){
	    	system.debug('Error is : ' + error);
	    }
	}

	//call from isAfterUpdate when matter member record update
	public static void updateRecordSharing(List<Matter_Member__c> updatedRec, List<Matter_Member__c> recordsBeforeUpdate, Map<ID, Matter_Member__c> mapOfOldMatter_UserId){

		try{
			

			for(Matter_Member__c matterMember : updatedRec){
				
				//if matter name change but user remains same
				if(matterMember.MatterName__c != mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c && matterMember.User__c == mapOfOldMatter_UserId.get(matterMember.ID).User__c){
					recToRemoveAccess.put(mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c, mapOfOldMatter_UserId.get(matterMember.ID).User__c);
					recToAssignAccess.put(matterMember.MatterName__c, matterMember.User__c);

				}
				//if matter name remains same but user name change
				else if(matterMember.MatterName__c == mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c && matterMember.User__c != mapOfOldMatter_UserId.get(matterMember.ID).User__c){
					recToRemoveAccess.put(mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c, mapOfOldMatter_UserId.get(matterMember.ID).User__c);
					recToAssignAccess.put(matterMember.MatterName__c, matterMember.User__c);

				}
				//matter name and user name change
				else if(matterMember.MatterName__c != mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c && matterMember.User__c != mapOfOldMatter_UserId.get(matterMember.ID).User__c){
					recToRemoveAccess.put(mapOfOldMatter_UserId.get(matterMember.ID).MatterName__c, mapOfOldMatter_UserId.get(matterMember.ID).User__c);
					recToAssignAccess.put(matterMember.MatterName__c, matterMember.User__c);
					
					system.debug('both Name change');
				}	

			}


			//list of all those records whom revoke access
			if(!recToRemoveAccess.isEmpty()){
				removeSharing(recToRemoveAccess);
			}

			//list of records whose to give record access
			if(!recToAssignAccess.isEmpty()){
				addSharing(recToAssignAccess);
			}
			
		}
		catch(Exception error){
			system.debug('Exception is : ' + error);
		}
	}

	//Revoke access from user
	public static void removeSharing(Map<ID, ID> recIdToRemoveAccess){
		try{
			//Fetch all the records where matter name or user change from the records
			List<Matter__Share> recordsToRemoveAccess = [SELECT Id FROM Matter__Share WHERE ParentId  IN :recIdToRemoveAccess.keySet() AND UserOrGroupId IN :recIdToRemoveAccess.keySet() AND RowCause = 'MatterSharingReason__c'];

			//Remove access if matter list not empty
		    if(!recordsToRemoveAccess.isEmpty()){
		    	Database.delete(recordsToRemoveAccess, false);		    	
		    }
		}
		catch(Exception err){
			system.debug('Exception in removeSharing : ' + err);
		}
	}

	//Give access of record to the user.
	public static void addSharing(Map<ID, ID> updatedRec){
		try{
			List<Matter__Share> mtr = new List<Matter__Share>();

			//Set matter and user id to share
		    for(ID recId: updatedRec.keySet()){
		    	Matter__Share matter = new Matter__Share();

	    		matter.ParentId = recId;
	    		matter.UserOrGroupId = updatedRec.get(recId);
	    		matter.AccessLevel = 'edit';
	            matter.RowCause = Schema.Matter__Share.RowCause.MatterSharingReason__c;
	            mtr.add(matter);    		
		    }
				

		    Database.insert(mtr,false);
		}
		catch(Exception err){
			system.debug('Error in addSharing');
		}
	}
	

	//Check record for first child record of the parent. if first record of the matter member for it's parent than checkbox will be selected
	public static void checkIsFirstRecord(List<Matter_Member__c> lstofInsertedRecord){
		
		for(Matter_Member__c m : lstofInsertedRecord){
			system.debug('lstofInsertedRecord : ' + m);
		}	
				
		//Map for store store checked record for each parent
		Map<ID, String> mapOfMatterId_firstName = new Map<ID, String>();
		mapOfMatterId_firstName = getMapofCheckedRecord(lstofInsertedRecord);

		//Get list of all those Matter records which are inserted in matter_Member. For check record created for the first time.
		List<Matter__c> insertedRecList = [Select Name, FirstUserName__c from Matter__c where ID IN :mapOfMatterId_firstName.keySet() LIMIT 50000];				
		system.debug('query result : ' + insertedRecList);			

		if(!insertedRecList.isEmpty()){
			updateFirstNameWhenRecordInsert(insertedRecList, mapOfMatterId_firstName);
		}

		Map<ID, Matter_Member__c> mapForUnchkRec = new Map<ID, Matter_Member__c>();

		//Set format for uncheck records and pass map to uncheckCheckbox function
		for(Matter_Member__c matter : lstofInsertedRecord){	
			if(matter.isFirstUser__c){
				mapForUnchkRec.put(matter.MatterName__c, matter);
			}
		}

		if(!mapForUnchkRec.isEmpty()){
			uncheckCheckbox(mapForUnchkRec);
		}

	}
	
	//Get map of last updated record's matterName and it's value
	public static Map<ID, String> getMapofCheckedRecord(List<Matter_Member__c> lstofInsertedRecord){

		Map<ID, String> mapOfMatterId_firstName = new Map<ID, String>();
		
		for(Matter_Member__c matter : lstofInsertedRecord){
			if(matter.isFirstUser__c ){
				if(mapOfMatterId_firstName.get(matter.MatterName__c) == null){
					mapOfMatterId_firstName.put(matter.MatterName__c, matter.Name);
				}
				else{
					mapOfMatterId_firstName.remove(matter.MatterName__c);
					mapOfMatterId_firstName.put(matter.MatterName__c, matter.Name);	
				}
			}
		}

		system.debug('new inserted record : ' + mapOfMatterId_firstName);
		return mapOfMatterId_firstName;
	}
	

	public static void updateFirstNameWhenRecordInsert(List<Matter__c> recLst, Map<ID, String> mapOfUser){
		

		List<Matter__c> recToUpdate = new List<Matter__c>();
		Set<ID> checkCheckboxRecId = new Set<ID>();

		for(Matter__c mater : recLst){						
			mater.FirstUserName__c = mapOfUser.get(mater.Id);
			recToUpdate.add(mater);

			checkCheckboxRecId.add(mater.ID);
		}

		system.debug('mater record : ' + checkCheckboxRecId);

		update recToUpdate;				

	}



	//Update Firstusername field when matter member record is update
	public static void updateFirstNameWhenRecordUpdate(List<Matter_Member__c> lstofInsertedRecord, Map<ID, Matter_Member__c> mapOfOldRec){		

		//map for store new inserted record's matterName as key and its record as value for 
		Map<ID, Matter_Member__c> recordToAddName = new Map<ID, Matter_Member__c>();
		//Map for when mamtter member's field is update it store new record's matter id and its new value
		Map<ID, String> fieldToUpdate = new Map<ID, String>();
		//Set for remove fields value of old records whose parent is change from matter object
		Set<ID> setToRemove = new Set<ID>(); 
		//For when matter name change and check box chk in old record and unchk in after update than remove firstusername field value from matter's object from old record id
		Set<ID> setToRemoveOldRecUserName = new Set<ID>();


		//Check condition for which value is update
		for(Matter_Member__c matter : lstofInsertedRecord){
			//Checkbox is uncheck before updation and check after record update
			system.debug('####################### ' + matter.isFirstUser__c  + !mapOfOldRec.get(matter.ID).isFirstUser__c);
            system.debug('new name : ' + matter.MatterName__c + ' old : ' + mapOfOldRec.get(matter.ID).MatterName__c);
			if(matter.isFirstUser__c && !mapOfOldRec.get(matter.ID).isFirstUser__c){
				system.debug('@@@@@@@@@checkbox value change..chk in new recod ');
				//setToAdd.add(matter.ID);
				recordToAddName.put(matter.MatterName__c, matter);
			}
			//Matter name same in record updation but checkbox value change from check to uncheck
			else if(!matter.isFirstUser__c && mapOfOldRec.get(matter.ID).isFirstUser__c && matter.MatterName__c == mapOfOldRec.get(matter.ID).MatterName__c){
				system.debug('@@@@@@@@checkbox value change..chk in old recod ');
				setToRemove.add(matter.MatterName__c);
			}
			//Matter name change
			else if(matter.MatterName__c != mapOfOldRec.get(matter.Id).MatterName__c && matter.isFirstUser__c){
				system.debug('@@@@@@@@Matter name change');
				recordToAddName.put(matter.MatterName__c, matter);
				//recordToRemoveName.put(matter.Id, mapOfOldRec.get(matter.ID));
				setToRemove.add(mapOfOldRec.get(matter.Id).MatterName__c);
				//setToAdd.add(matter.ID);
			}
			//matter name and checkbox value change. checkbox is checked in old record and uncheck after update
			else if(matter.MatterName__c != mapOfOldRec.get(matter.Id).MatterName__c && !matter.isFirstUser__c && mapOfOldRec.get(matter.ID).isFirstUser__c){
				system.debug('matter name and checkbox value change. checkbox is checked in old record and uncheck after update');
				setToRemoveOldRecUserName.add(mapOfOldRec.get(matter.Id).MatterName__c);

			}
			//Matter member value change
			else if(matter.Name != mapOfOldRec.get(matter.ID).Name){
				system.debug('@@@@@@@@Name field change : ');
				fieldToUpdate.put(matter.MatterName__c, matter.Name);
			}			
		}

		if(!setToRemove.isEmpty()){
			system.debug('remove checkbox : ' + setToRemove);
			removeFieldName(setToRemove);
		}
		if(!recordToAddName.isEmpty()){
			system.debug('add checkbox : ' + recordToAddName);
			addFirstName(recordToAddName);
			uncheckCheckbox(recordToAddName);
		}	
		if(!fieldToUpdate.isEmpty()){
			updatefieldName(fieldToUpdate);
		}
		if(!setToRemoveOldRecUserName.isEmpty()){
			removeFieldName(setToRemoveOldRecUserName);
		}

	}

	//update matter field 
	public static void updatefieldName(Map<ID, String> mapToUpdateField){
		List<Matter__c> matterLst = [Select Name, Id, FirstUserName__c from Matter__c where ID IN :mapToUpdateField.keySet() LIMIT 50000];
		List<MAtter__c> lstToUpdateRec = new List<Matter__c>();

		system.debug('update to fields : ' + matterLst);

		for(Matter__c matter : matterLst){
			matter.FirstUserName__c = mapToUpdateField.get(matter.ID);
			lstToUpdateRec.add(matter);
			system.debug('field : ' + matter);
		}

		update lstToUpdateRec;
	}

	//Remove first user value from matter object.
	public static void removeFieldName(Set<ID> recmoveRecordId){		

		List<Matter__c> recordToRemove = [Select Name, FirstUserName__c from Matter__c where ID IN :recmoveRecordId LIMIT 50000];
		List<Matter__c> matterRecLst = new List<Matter__c>();

		system.debug('remove records are : ' + recordToRemove);

		for(Matter__c recordToUpdate : recordToRemove){
			recordToUpdate.FirstUserName__c = '';
			matterRecLst.add(recordToUpdate);			
		}

		update matterRecLst;
	}

	//For uncheck all the checkbox of the child record except most recent checked record
	public static void uncheckCheckbox(Map<ID, Matter_Member__c> checkCheckboxRecId){
		//Prevent to trigger to enter in update block when update statement execute
		PreventingRecursiveTrigger.preventTrigger =true;

		List<Matter_Member__c> lstOfMatterMemberRec = [Select Name, isFirstUser__c, MatterName__c from Matter_Member__c where MatterName__c IN : checkCheckboxRecId.keySet() LIMIT 50000];
		List<Matter_Member__c> lstToUpdateRec = new List<Matter_Member__c>();

		//Unchecka all the checked checkbox value except most recent updated record.
		for(Matter_Member__c matter : lstOfMatterMemberRec){
			if(checkCheckboxRecId.get(matter.MatterName__c).ID == matter.ID){
				system.debug('true result : ' + matter);
				matter.isFirstUser__c = true;
				matter.MatterName__c = matter.MatterName__c;
				lstToUpdateRec.add(matter);
			}
			else{
				system.debug('false result : ' + matter);
				matter.isFirstUser__c = false;
				lstToUpdateRec.add(matter);
			}
		}

		update lstToUpdateRec;
	}

	//update firstusername field when record is update
	public static void addFirstName(Map<ID, Matter_Member__c> mapOfUpdateToRecord){
		List<Matter__c> matterRecLst = [Select Name, FirstUserName__c from Matter__c where ID IN :mapOfUpdateToRecord.keySet()];

		system.debug('addFirstName : ' + matterRecLst);
		List<Matter__c> lstToUpdateRec = new List<Matter__c>();

		for(Matter__c matter : matterRecLst){
			matter.FirstUserName__c = mapOfUpdateToRecord.get(matter.Id).Name;
			lstToUpdateRec.add(matter);
		}

		update lstToUpdateRec;
	}
	

	//Remove all the firstnameuser field value whose child record is deleted and their checkbox is selected
	public static void removeFirstUserName(Map<ID, Matter_Member__c> mapOfDelRec){
		Set<ID> recmoveToFirstUser = new Set<ID>();

		for(ID recId : mapOfDelRec.keySet()){
			if(mapOfDelRec.get(recId).isFirstUser__c){
				recmoveToFirstUser.add(mapOfDelRec.get(recId).MatterName__c);
			}
		}
		removeFieldName(recmoveToFirstUser);
	}	
}