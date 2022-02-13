public class CampingListController {
	
    @auraenabled
    public static List<Camping_item__c> getItems (){
        System.debug('Data : ' + [select id, Name, price__c, packed__c, quantity__c from Camping_item__c]);
        return [select id, Name, price__c, packed__c, quantity__c from Camping_item__c];                
    }
    
    @auraenabled
    public static Camping_item__c saveItem(Camping_item__c item){
        insert item;
        return item;
    }
}