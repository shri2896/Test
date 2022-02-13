public  class Assignment
{
    public String name{get;set;}
    public string subject{get;set;}
	ApexPages.StandardController conn;
    public Assignment(ApexPages.StandardController con)
    {
        Student__c st =  (Student__c)con.getRecord();        
        System.debug('after page Reload');
    }
    
    public void saveRecords()
    {        
        Student__c st =  (Student__c)conn.getRecord();        
        System.debug('Student Name is : ' + st.First_Name__c);
    }
    
    /*public static void showRecords()
    {
         Date currentDate = system.today();        
        Date previousDate = system.today()-2;                
         List<contact> allContact = [select firstname , lastname , mailingcity from contact where (createdDate > :previousDate) and (createdDate < :currentDate)];        
        
        for(Contact cont : allContact)
        {
            System.debug('Name is : ' + cont.firstname);
            System.debug('Last Name is ' + cont.lastName);
        } 
    }*/
    
}