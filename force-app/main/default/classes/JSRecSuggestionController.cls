public class JSRecSuggestionController {
    
    static List<sObject> suggestedRec = new List<sObject>();
    static List<ObjectWrapper.GetObjNameId> objwrapper = new List<ObjectWrapper.GetObjNameId>();
   
    public JSRecSuggestionController(){    	
    }
    @RemoteAction
    public static Set<String> searchRecord(String obj, String fld, String arg){
    	Set<String> data = new Set<String>();		    	    	    	
    	suggestedRec = Database.query('SELECT ' + fld + ' FROM ' + obj +' WHERE ' + fld +' LIKE \''+ arg +'%\'');    	
    	if(suggestedRec == null){    		
    		return null;
    	}
    	else{    		
    		for(Integer i = 0; i < suggestedRec.size(); i++){
    			data.add(String.valueOf(suggestedRec[i].get(fld))); 
    			objwrapper.add(new ObjectWrapper.GetObjNameId(String.valueOf(suggestedRec[i].get('id')), String.valueOf(suggestedRec[i].get(fld))));   			
    		}
    		
    	}	
    	return data;
    }

    @RemoteAction
    public static List<ObjectWrapper.GetObjNameId> getRecords(String obj, String fld, String arg){
    	searchRecord(obj, fld, arg);    	
    	return objwrapper;    	
    }
    @RemoteAction
    public static void updateRecords(String rec, String obj, String fld){    

    	List<List<String>> lst = (List<List<String>>)JSON.deserialize(rec, List<List<String>>.class); 	
    	
    	Set<String> uid = new Set<String>();       	
    	Map<String, String> recMap = new Map<String, String>();    	

    	for(Integer i = 0; i < lst.size(); i++){
    		List<String> str = lst.get(i);    		    					
			uid.add(str[0]);
			recMap.put(str[0], str[1]);    							
    	}    	
    	
    	List<sObject> reclst = Database.query('Select ' + fld + ' from ' + obj + ' where ID IN :uid');
    	List<sObject> updateRec = new List<sObject>();    	    			

    	for(sObject val : reclst){
    		sObject selectObj = Schema.getGlobalDescribe().get(obj).newSobject();    		    		       		
    		String str = String.valueOf(val.get(fld));
    		String id = String.valueOf(val.get('id'));	    		
    		selectObj.put('id', id);    		   	

    		System.debug('id : ' + selectObj); 
    		if(recMap.containsKey(id)){
    			selectObj.put(fld, recMap.get(id));    			
    		}    		
    		updateRec.add(selectObj);
    	}
    	update updateRec;    
    }
}