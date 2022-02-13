public with sharing class ExpensesController {
    
    @AuraEnabled    
    public static List<Expense__c> getExpenses(){
        String[] fieldsToCheck = new String[] {
          	'Id', 'Name', 'Amount__c', 'Client__c', 'Date__c', 'Reimbursed__c', 'CreatedDate'            
        };
        Map<String, Schema.SObjectField> fieldDescribeToken = Schema.SObjectType.Expense__c.fields.getMap();
        
        for(String 	field : fieldsToCheck ){
            if( ! fieldDescribeToken.get(field).getDescribe().isAccessible()){
                throw new System.NoAccessException();
            }
        }
        return [Select Id, Name, reimbursed__c, Date__c, createdDate from Expense__c ];
    }
    
    @AuraEnabled
    public static Expense__c saveExpenses(Expense__c expense){
        upsert expense;
        return expense;
    }
}