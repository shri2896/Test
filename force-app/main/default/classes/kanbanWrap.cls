public class kanbanWrap {
	@AuraEnabled
    public List<sObject> records;
    
    @AuraEnabled
    public List<String> pickVals;	  

    //Account Records pagination
    @AuraEnabled
    public Integer pageSize;
    @AuraEnabled
    public Integer pageNumber;
    @AuraEnabled
    public Integer totalRecords;
    @AuraEnabled
    public Integer recordStart;
    @AuraEnabled
    public Integer recordEnd;
    //@AuraEnabled
    //public List<sObject> AccountList;

    
     public kanbanWrap(){}

    public kanbanWrap(List<sObject> recs, List<String> pVals){
        this.records = recs;
        this.pickVals = pVals;    	        
      	                
    }

}

//AccountList