@isTest
public class TestVerifyDate {
	@isTest static void checkRange()
    {
        test.startTest();
        Date d = VerifyDate.CheckDates(Date.newInstance(1960, 2, 17), Date.newInstance(1960, 2, 17));
         d = VerifyDate.CheckDates(Date.newInstance(1960, 2, 17), Date.newInstance(1962, 2, 17));

        test.stopTest();
    }
}