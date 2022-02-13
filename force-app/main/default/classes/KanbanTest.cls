@isTest
public with sharing class KanbanTest {
	public KanbanTest() {				
	}

	public static testMethod void kanbanTestMethod(){

		List<Account> lst = new List<Account>();

		for(Integer i = 0; i < 5; i++){
			Account acc = new Account();
			acc.Name = 'shri ' + i;
			acc.AccountNumber = '10201' + i;
			acc.Industry = 'Chemical ' + i;

			lst.add(acc);
		}

		insert lst;

		Test.startTest();
			KanbanController.getAccountRecords();
		Test.stopTest();
	}
}
/*
public class sObjectPagination {
    
    // intialize getter setter of all variabels 
    public List<selectOption> listOfObjects{get;set;} 
    public List<selectOption> listOfFieldSet{get;set;} 
    public List<sObject> sobjectRecordList{get;set;}
    public List<sObject> reversibleList{get;set;}
    public List<string> listOfFields{get;set;}
    public Map<String,Schema.SObjectType> mapSObjectDescribe{get;set;}
    public string curruntObject{get;set;}
    public string curruntfieldSet{get;set;}
    public string flag = '';
    public id comparedrId;
    public Integer count{get;set;}
    public Integer totalRecords{get;set;}
    
    public sObjectPagination(){
        sobjectRecordList = new List<sObject>();
        reversibleList = new List<sObject>();
        curruntfieldSet  = 'none';
		count = 20;         
        //Intialize selectOption List
        listOfObjects = new list<SelectOption>(0);
        
        //Intialize selectOption List
        listOfFieldSet = new list<SelectOption>();
        
        //Map to get list of all Objects
        mapSObjectDescribe = Schema.getGlobalDescribe();
        
        //Intialize Currunt Object with none
        curruntObject='None';
        
        // add default fieldset in select list value
        listOfFieldSet.add(new selectOption(curruntfieldSet,curruntfieldSet));
        
        List<string> s = new list<string>(mapSObjectDescribe.keySet());
        s.sort();
        
        // add objects in select list value
        listOfObjects.add(new selectOption(curruntObject,curruntObject));
        for(String objectName : s) {
            listOfObjects.add(new SelectOption(objectName,objectName));
        }
    }
    
    public  void fieldSetOfObject(){
        if(curruntObject != 'none'){
            //Intialize selectOption List
            listOfFieldSet = new list<SelectOption>();
            Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(curruntObject);
            if( sObjType != NULL ) {
                Map<String, Schema.FieldSet> fieldSetNameToItsRecord = sObjType.getDescribe().fieldsets.getMap();
                
                //Intialize Currunt Object with none
                listOfFieldSet.add( new SelectOption('none','none'));
                
                if(fieldSetNameToItsRecord != null){
                    for(String fieldset : fieldSetNameToItsRecord.keySet()) {
                        listOfFieldSet.add( new SelectOption(fieldset,fieldset));
                    }
                }
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select an Object'));
        }
    }
    
    public  void sobjectRelatedData(){
        if(curruntfieldSet != 'none' && curruntObject != 'none' ){
            listOfFields = new List<string>();
            string fieldType = '';
            List<string> fieldsName = new List<string>();
            String query='SELECT ' ;
            
            //Global describe call for find field set of parent object
            Schema.SObjectType objectDescribe = Schema.getGlobalDescribe().get(curruntObject);
            
            //Loop over field set describe call add add fields in the field set list
            for(Schema.FieldSetMember fieldMember : objectDescribe.getDescribe().fieldSets.getMap().get(curruntfieldSet).getFields()){
                listOfFields.add(fieldMember.getFieldPath());
                query = query+fieldMember.getFieldPath()+',';
            }
            if(flag == 'next'){
                query = query+'ID '+'FROM '+ curruntObject +' where id >: comparedrId order by id Asc limit 5';
            }
            else if(flag == 'prev'){
                query = query+' ID '+'FROM '+ curruntObject +' where id <: comparedrId order by id DESC limit 5';
            }
            else if(flag == 'Last'){
                query = query+' ID '+'FROM '+ curruntObject +' order by id DESC limit 5';
            }
            else{
                query = query+'ID '+'FROM '+ curruntObject +' order by id Asc limit 5';
                String soql = 'SELECT COUNT() FROM ' + curruntObject;  
                totalRecords = Database.countQuery(soql);
            }
            sobjectRecordList = new List<sObject>();
            sobjectRecordList = database.query(query);
            
            if(sobjectRecordList.size() > 0){   
                reversibleList = sobjectRecordList;
                if(flag == 'prev' || flag == 'Last'){
                    reversibleList = NEw List<sObject>();
                    for(Integer i = sobjectRecordList.size()-1 ; i>=0 ; i--){
                        reversibleList.add(sobjectRecordList[i]);
                    }
                    sobjectRecordList =  reversibleList;
                    reversibleList = sobjectRecordList;
                }
            }
            else{
                if(flag == 'prev'){
                    count += 20;
                }
                sobjectRecordList = reversibleList;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'no more record here'));
            }
            flag = '';
            if(count > totalRecords){
            count = totalREcords;
        }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a fieldset'));
        }
        
    }
    
    public void next(){
        count += 20;
        flag = 'next';
        comparedrId = (id)sobjectRecordList[sobjectRecordList.size()-1].get('id');
        sobjectRelatedData();
        
    }
    
    public void prev(){
        count -= 20;
        flag = 'prev';
        if(sobjectRecordList.size() < 20){
            comparedrId = (id)sobjectRecordList[0].get('id');
        }
        else
            comparedrId = (id)sobjectRecordList[sobjectRecordList.size()-20].get('id');
        sobjectRelatedData(); 
    }
    
    public void first(){
        count = 20;
        flag = '';
        sobjectRelatedData();
    }
     public void Last(){
        count = totalRecords;
        flag = 'Last';
        sobjectRelatedData();
    }
}
*/