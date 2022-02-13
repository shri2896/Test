public class TriggerDMLAssignment
{           
    public static void insertRecord(List<student__c> lst,integer num)
    {  
        List<Student__c> stu=[select first_name__c,faculty__c from student__c where first_name__c like 'y%'];
        for(student__c st : stu)
        {
            st.Faculty__c='a0B6F00001MnUaZUAV';
        }
        
        if(num==1)
        {
            insert lst;
            System.debug('num1');
        }
        else if(num==2)
        {
            update lst;
            system.debug('num2');
        }
       else
       {
           //delete lst;
           system.debug('num3');               
               
       }
           
    }
}