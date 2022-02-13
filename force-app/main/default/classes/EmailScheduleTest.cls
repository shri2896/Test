@IsTest
public class EmailScheduleTest {
  
    public static testmethod void testEamilScheduler()
    {
        test.startTest();
        Datetime dt = Datetime.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.Schedule('Sample_Heading', CRON_EXP, new EmailScheduler () );   
        test.stopTest();
    }
    
       
}