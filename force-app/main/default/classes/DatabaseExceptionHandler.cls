public class DatabaseExceptionHandler{
    public static Account insertNewAccount(String name)
    {
        Account ac ;
        try
        {
            ac = new Account(Name=name);  
            insert ac;
            return ac;
        }
        catch(DMLException e)
        {
            System.debug('DML exception is : ' + e.getMessage());
            return null;
        }
        
    }
}