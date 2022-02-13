public class CountofStudent 
{      
    public void studentCount()
    { 
        List<faculty__c> fact = [select id, name, (select id from students__r) from faculty__c];
        for(faculty__c fac : fact)
        {                    
            fac.Count_of_Child_Student__c=fac.students__r.size();  
        }        
		update fact;             
        
    }     
}