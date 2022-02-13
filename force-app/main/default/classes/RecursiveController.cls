public class RecursiveController {
	public static boolean recursionController = true;
    public static boolean deleteController = false;
    
    public static boolean recursionControllerMethod()
    {
        System.debug('Value of instance is : ' + recursionController);
        if(recursionController)
        {
            recursionController = false;
            return true;        
        }
        else
        {
            return recursionController;
        }
    }
}