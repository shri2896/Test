@IsTest
public class CsvTestClass 
{       
   	static String str = 'FirstName,LastName,MailingCity,Email\n Ramesh,Sharma,Ajmer,Rsharma@gmail.com \n Jayesh, pandit , Jaipur , panditji@gmail.com';      
    public static String[] csvFileLines;
	public static Blob csvFileBody;
    
    public static testmethod void checkFileLoad()
    {   		 
        Test.startTest();      
        csvFileBody = Blob.valueOf(str);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        InsertingDataUsingCSVFile importData = new InsertingDataUsingCSVFile();
        importData.csvFileData = csvFileBody;
        importData.importData();
        Test.stopTest();         
    }
    public static testmethod void checkNegativeData()
    {
        String str1 = 'FirstName,LastName,MailingCity,Email\n Ramesh,Sharma,Ajmer,Rsharma@gmail.com \n Jayesh, pandit , panditji@gmail.com';
        Test.startTest();      
        csvFileBody = Blob.valueOf(str1);
        String csvAsString = csvFileBody.toString();
        csvFileLines = csvAsString.split('\n');
        InsertingDataUsingCSVFile importData = new InsertingDataUsingCSVFile();
        importData.csvFileData = csvFileBody;
        try
        {
        	importData.importData();
        	Test.stopTest();         
        }
        catch(Exception e)
        {
            System.debug('Exception is : ' + e);
        }
    }
    
}