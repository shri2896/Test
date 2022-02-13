@IsTest
public class BatchTestClass 
{
	public static testmethod void IsTest()
    {
		List<contact> lst = new List<contact>{ new Contact(firstname='Raj', lastname='Dhol'),
          										new Contact(firstname='Raj', lastname='Dhol')
											  };
		insert lst;  
        
        Datetime yesterday = Datetime.now().addDays(-1);
        lst = [select createdDate from contact where createdDate=TODAY];
        for(contact con : lst)
        {
            Test.setCreatedDate(con.Id, yesterday);
        }
        
        update lst;        
        Test.startTest();       	
        UpdateStatusInContact usc = new UpdateStatusInContact();
        database.executebatch(usc);	
        Test.stopTest();
    }
}