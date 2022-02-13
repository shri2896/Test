/**
 * @ description : For RecordSharingTriggerHelper. Test conditions with insert, update, delete & undelete.
 * @ Author : Shrikant Mittal
 * @ Data : 03/07/2019
 */

@isTest
//For RecordSharingTriggerHelper. Check code coverage when records are insert, delete, update & undelete 
public class RecordSharingTest {

	public static testMethod void recShare(){
        //Fetch profile id for assign to user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        //Create user record.               
        User tuser = insertUser('testu', 'Testuseru', 'testmailtest@gmail.com', 'testmailtest@gmail.com');
        insert tuser; 
        
        //Insert dummy record for matter object
        Matter__c mater = new Matter__c();
        mater = insertMatterRecord('Matter1');
        
        insert mater;
                
        // insert matter member record.
        Matter_Member__c member = new Matter_Member__c();
        member.MatterName__c = mater.Id;
        member.User__c = tuser.Id;
        member.isFirstUser__c = true;
        insert member;
        
        //Fetch Matter Member records for record updation.                
        //mater = insertMatterRecord('Matter2');       
        //insert mater;
        
        //Update matter member record with check following case :- When only matter member update
        PreventingRecursiveTrigger.preventTrigger = false;
        Matter_Member__c lstofrec = new Matter_Member__c();
        lstofrec = updateMatterMember(mater.Id, tuser.Id);
        update lstofrec;
        
        //Insert new user     
		tuser = insertUser('testu2', 'Testuseru2', 'testmailtest2@gmail.com', 'testmailtest2@gmail.com');		
        insert tuser;
        
        //Update matter member record with the following case :- When only user change and matter remains same.
        lstofrec = updateMatterMember(mater.Id, tuser.Id);
        update lstofrec;
        
        lstofrec = new Matter_Member__c();
        lstofrec = member;
        lstofrec.Name = 'MatterMember Name change';
        
        update lstofrec;
        
        //Insert new matter record
        mater = insertMatterRecord('Matter3');    
        insert mater; 
        
        tuser = insertUser('testu3', 'Testuseru3', 'testmailtest23@gmail.com', 'testmailtest23@gmail.com');		
        insert tuser;
		
        //Update matter member record with the following case :- When user and matter both are change.
        lstofrec = updateMatterMember(mater.Id, tuser.Id);
        update lstofrec;
               
        //Check delete record case.
        delete lstofrec;
        
        //Check record undelete case.
        List<Matter_Member__c> undelRec = [Select MatterName__c, User__c from Matter_Member__c ALL ROWS];
        undelete undelRec;                   
               
        mater = insertMatterRecord('Matter2');       
        insert mater;
        
        member = new Matter_Member__c();
        member.MatterName__c = mater.Id;
        member.User__c = tuser.Id;
        member.isFirstUser__c = true;
        insert member;
        
        lstofrec = member;
        lstofrec.isFirstUser__c = false;
        
        update lstofrec;
    }
    
    public static User insertUser(String firstName, String lastName, String userName, String email){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
    	User tuser = new User();
        tuser.FirstName = firstName;
        tuser.LastName  = lastName;
        tuser.Email     = email;
        tuser.Username  = userName;
        tuser.Alias     = 'testy';
        tuser.ProfileId = p.Id;
        tuser.TimeZoneSidKey = 'America/Denver';
        tuser.LocaleSidKey   = 'en_US';
        tuser.EmailEncodingKey  = 'UTF-8';
        tuser.LanguageLocaleKey = 'en_US';   
        
        return tuser;
    }
    
    public static Matter__c insertMatterRecord(String matterName){
        Matter__c mater = new Matter__c();
        mater.Name = matterName;
        
        return mater;
    }
    
    public static Matter_Member__c updateMatterMember(ID mater, ID tuser){
        List<Matter_Member__c> lstofrec = [Select MatterName__c, User__c from Matter_Member__c LIMIT 50000];
        lstofrec[0].MatterName__c = mater;
        lstofrec[0].User__c = tuser;                    
        return lstofrec[0];
    }
    
    public static Matter_Member__c updateFirstUser(String matterName, ID mater, Boolean checkboxValue, ID tuser, ID recId){
        List<Matter_Member__c> lstofrec = [Select MatterName__c, User__c from Matter_Member__c where ID = :recID LIMIT 50000];
        lstofrec[0].MatterName__c = mater;
        lstofrec[0].User__c = tuser;
        lstOfRec[0].Name = matterName;
        lstOfRec[0].isFirstUser__c = checkboxValue;
        return lstofrec[0];
    }
}