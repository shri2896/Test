public class TriggerTrailheadHelperClass {
   	List<Task> tasklst = new List<Task>();
    List<Opportunity> oprt = new List<opportunity>();
    public void beforeInsert(List<opportunity> lst){
        for(Opportunity oprt : lst){  
            if(oprt.stageName =='closed won'){
                Task t = new Task();     
                t.Status = 'open';
                t.Priority = 'normal';      
                t.subject = 'Follow Up Test Task';
                t.whatId = oprt.id;
                tasklst.add(t);
           }
     	}       
        //insert tasklst;
        
    }
    public void beforeUpdate(List<opportunity> lst){
        for(Opportunity oprt : lst){  
            if(oprt.stageName =='closed won'){
                Task t = new Task();     
                t.Status = 'open';
                t.Priority = 'normal';      
                t.subject = 'Follow Up Test Task';
                t.whatId = oprt.id;
                tasklst.add(t);
           }
     	}       
        //update tasklst;
    }
}