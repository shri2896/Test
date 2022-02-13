public class getAllsObject {	    
   	
    public String selectedObj{get;set;}    
	  public list<SelectOption> SObjlst { get; set; }
    public List<SObject> slctObjRecord{get;set;}
    public Set<String> flds{get;set;}
    Map<String, String> mapOfApiName = new Map<String, String>();
    public List<String> selectedField{get;set;}
    Public List<SelectOption> fields{get;set;}    
    public List<String> lstflds{get; set;}
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public List<selectOption>secondListFields{get;set;}
    List<selectOption> allFields = new List<selectOption>();
    public List<String> secondListSelectdField{get;set;}
    public boolean btnshw{get;set;}
    public boolean btnRightShft{get;set;}
    public boolean btnLeftShft{get;set;}
    public boolean secPickList{get;set;}
    public boolean recshwhide{get;set;}
    String nameField = '';
    Map<string,Schema.SObjectField> mpConField = new Map<String, Schema.SObjectField>();     
    public Integer noOfRec{get;set;}
    Public Integer totalRecPage{get;set;}
    public boolean frst{get;set;}
    public boolean nxt{get;set;}
    public boolean prv{get;set;}
    public boolean lst{get;set;}
    public Integer pageNo{get;set;}
    public List<String> allAlphabet{get;set;}
    public Integer delRecId{get;set;}
    Public String str='';
    Public List<DynamicWrapper> RecordWraps{get;set;}
    public String recordNo{get;set;}     
    public boolean lastPanelShowHide{get;set;}

    public getAllsObject()
    {                  
        recordNo = '1-';
        lastPanelShowHide=false;        
        allAlphabet=new List<String>{'A ','B ','C ','D ','E ','F ','G ','H ','I ','J ','K ','L ','M ','N ','O ','P ','Q ','R ','S ','T ','U ','V ','W ','X ','Y ','Z ','Other ','All'};
        pageNo=1;  
        noOfRec=10;
        prv=true;
        nxt=false;
        btnLeftShft=recshwhide=secPickList=btnRightShft=btnshw=false;         
        secondListFields = new List<SelectOption>();            
        secondListSelectdField = new List<String>();
        fields = new List<SelectOption>();         
        SObjlst = new List<SelectOption>();
        
        SObjlst.add(new Selectoption('','--None--'));
        list<schema.SobjectType> lst=schemaMap.values();
        
		    for(schema.SobjectType sObj : lst){
            if(sObj.getDescribe().isAccessible() && sObj.getDescribe().isDeletable() && sObj.getDescribe().isQueryable() && sObj.getDescribe().isUndeletable() && sObj.getDescribe().isUpdateable() && sObj.getDescribe().iscreateable() && sObj.getDescribe().issearchable()){
                 if(sObj.getDescribe().getName().contains('__c')){
                    SObjlst.add(new SelectOption(sObj.getDescribe().getLocalName(),sObj.getDescribe().getLabel()));                                        
                 }
                else{
                    SObjlst.add(new SelectOption(sObj.getDescribe().getLocalName(),sObj.getDescribe().getLocalName()));                   
                }
            }
        }
        if(SObjlst.size()>0){
        	SObjlst.sort();
        }
    }
    
   public void getFieldsList()
   {   
        System.debug('Enter');  
       try
       {    
           pageNo=1;          
           btnshw=false;                                 
           recshwhide=false;
           lastPanelShowHide=false;
          //System.debug('value : ' + recshwhide);
           if(selectedObj==null)
           {               
               btnRightShft=false;              
               secPickList=false;
               btnLeftShft=false;               
               fields.clear(); 
               allFields.clear();              
               if(secondListFields.size()>0)
               {
                  secondListFields.clear();
               } 
               if(slctObjRecord.size()>0){
                  slctObjRecord.clear();                 
               }
           }
           else{   
                btnRightShft=true; 
                btnLeftShft=false;                
               allFields.clear();                            
               fields.clear();               
               mpConField=schemaMap.get(selectedObj).getDescribe().fields.getMap();
               flds = mpConField.keySet();                           
               for(String singleField : flds){                                          
                   Schema.DescribeFieldResult fldResult = mpConField.get(singleField).getDescribe(); 
                   if(fldResult.isNameField()){
                        nameField = fldResult.getName();
                        System.debug('Name Field is : ' + nameField);
                   } 
                   if(fldResult.isAccessible() && fldResult.isUpdateable()){
                       mapOfApiName.put(fldResult.getLabel(), fldResult.getName());                                      
                       fields.add(new SelectOption(fldResult.getName(),fldResult.getLabel()));                        
                       fields.sort();  
                    }
               }                                                         
               if(secondListFields.size()>0)
               {
                  secondListFields.clear();
               } 
           }           
       }
       catch(Exception e){
           System.debug('Error in : ' + e);
       }
   }
    
   public void showRecords()
   {     
       slctObjRecord = new List<SObject>();
       pageNo=1;
       if(SchemaMap.get(selectedObj)==null)
       {
            apexPages.addMessage(new apexPages.Message(ApexPages.severity.ERROR, 'Select at least one object...!!!'));        	
           	slctObjRecord.clear();
       }
       else{ 
            // Clear all the previous records 
           if(slctObjRecord.size()>0){
           		slctObjRecord.clear();
           }
           if(secondListFields.size()>0){ 
              //System.debug(secondListFields);   
              String allflds = getSplitFieldName();             
              System.debug('Fields : ' + allflds);     
              System.debug('count : ' + noOfRec);     
              totalRecPage = (Database.countQuery('select COUNT()  from ' + selectedObj));   
              
              if((Math.mod(totalRecPage,noOfRec))==0){
                  totalRecPage = totalRecPage/noOfRec;
              }              
              else{
                  totalRecPage = totalRecPage/noOfRec+1;
              }
              
              System.debug('Rec : '+ totalRecPage);                                   
              slctObjRecord = Database.query('select ' + allflds + ' from ' + selectedObj + ' Limit ' + noOfRec);
              recshwhide=true;      
              lastPanelShowHide=true;
               if(slctObjRecord.size()==0){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'No record found...!!!'));
                   recshwhide=false;
                   lastPanelShowHide=false;
               }                                    
           }           
           else
           {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Selectoption at least one Field...!!!'));               
           }
       }
       if(noOfRec>slctObjRecord.size()){
          recordNo=pageno+'-'+ slctObjRecord.size() +' of ' + slctObjRecord.size();
       }
       else{
          recordNo=pageno+'-'+noOfRec+' of ' +  (Database.countQuery('select COUNT()  from ' + selectedObj));  
       }
       getRecords();
   }        
    
    public String getSplitFieldName()
    {     
        recshwhide=false; 
        lastPanelShowHide=true;                           
        List<String> strApiName = new List<String>{};
        lstflds = new List<String>();
        String spltName = '';

        for(SelectOption opt : secondListFields){
            if(opt.getValue()!=nameField){
              String str = opt.getLabel();
              if(str.startsWith(' '))
              {
                  str = str.substring(1, str.length());  
              }  
			         str.trim();
              if(mapOfApiName.containsKey(str)){                
                  strApiName.add(mapOfApiName.get(str));                
                  lstflds.add(mapOfApiName.get(str));                
              }
              else{
                  System.debug('key not contain : ' + str);
              }
            }            
        }        
        spltName='';
        for(String fieldName : strApiName){
            spltName = fieldName + ' , ' + spltName;
        }
        //spltName = spltName + nameField;            
        //spltName = spltName.substring(0,spltName.length()-2);                 
        spltName = spltName + NameField;
        //System.debug(nameField);
        //System.debug(Database.query('select ' + spltName + ' from ' + selectedObj));           
        return spltName;        
    }

    public void setSecondListFields()
    {
        if(selectedField.size()>0){ 
            secPickList=true;
            btnLeftShft=true;
            btnshw=true;     
            recshwhide=false;                            
            lastPanelShowHide=false;
            for(String spltFieldName : selectedField){
                Schema.DescribeFieldResult fldSchma = mpConField.get(spltFieldName).getDescribe();
                secondListFields.add(new SelectOption(fldSchma.getName(),fldSchma.getLabel()));
                fields.remove(fields.indexOf(new SelectOption(fldSchma.getName(), fldSchma.getLabel())));
            }  
            if(fields.size()>0){
              fields.sort();
            }       
            if(secondListFields.size()>0){
              secondListFields.sort();
            }
        }
        else
        {
            System.debug('selectedField is : ' + selectedField);            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ' Select at least one field 1'));
        }        
    }   

    public void shiftFieldTofrstLst(){        
        if(secondListFields.size()>0 && selectedObj<>null){
          if(secondListSelectdField.size()>0){                               
            recshwhide=false;            
            lastPanelShowHide=false;
            for(String str : secondListSelectdField){                                          
              Schema.DescribeFieldResult fieldSchema = mpConField.get(str).getDescribe();
              fields.add(new Selectoption(fieldSchema.getName(), fieldSchema.getLabel()));                                                                       
              secondListFields.remove(secondListFields.indexOf(new Selectoption(fieldSchema.getName(), fieldSchema.getLabel())));                                                
              
              if(secondListFields.size()<1){
                btnshw=false;
                btnLeftShft=false;
              }
            }

            if(fields.size()>0){
              fields.sort();
            }       
            if(secondListFields.size()>0){
              secondListFields.sort();
            }
          }
          else{            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, ' Select at least one field 2'));
          }
        // Close if block
        }
        else{
            btnLeftShft=false;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,' No elements found in the list...!!!'));
        }
    }
    
    public void next(){
        prv=true;
        slctObjRecord.clear();
        pageNo++;        
        System.debug('PageNo : ' + pageNo + ' Total : ' + totalRecPage);
        if(pageNo>=totalRecPage){
           pageNo=totalRecPage;
            nxt=true;
            System.debug(nxt);
            List<SObject> tmp = Database.query('select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);
            recordNo = ((pageNo-1)*noOfRec+1) + '-'+ tmp.size() + ' of ' + tmp.size();
            for(Integer i=(pageNo-1)*noOfRec; i<tmp.size(); i++){
                slctObjRecord.add(tmp[i]);   
            }
        }
        else{
            List<SObject> tmp = Database.query('select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);
            recordNo = ((pageNo-1)*noOfRec+1) + '-' + (pageNo*noOfRec) + ' of ' + tmp.size();
            for(Integer i=(pageNo-1)*noOfRec; i<(pageNo*noOfRec); i++){                
                slctObjRecord.add(tmp[i]);   
            }
        }                
        lastPanelShowHide=recshwhide=true;

    }

    public void first(){
        //prv=false;
        System.debug('Enter');
        pageNo=1;
        slctObjRecord.clear();
        str=str.remove(' ');
        System.debug('noOfRec : ' + noOfRec );        
        List<SObject> tmp = Database.query('select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);              
        for(Integer i=0; i<noOfRec; i++){
            slctObjRecord.add(tmp[i]);
        }
        recordNo = '1-'+noOfRec+' of ' + tmp.size();
        lastPanelShowHide=recshwhide = true;
    }

    public void last(){
        pageNo=totalRecPage;
        System.debug('pageno : ' + pageNo);
        slctObjRecord.clear();
        List<SObject> tmp = Database.query('select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);  
        System.debug('Size : ' + tmp.size());
        for(Integer i=tmp.size()-1; i>=tmp.size()-noOfRec; i--){
            System.debug(' i : + ' + i);
            slctObjRecord.add(tmp[i]);
        }
        recordNo = ((pageNo-1)*noOfRec+1)+'-'+tmp.size()+' of ' + tmp.size();
        lastPanelShowHide=recshwhide = true;
    }

    public void previous(){
      pageNo--;
      System.debug('Enter');       
        if(pageNo<1)
        {   
            System.debug('Enter');       
            pageNo=1;
            List<SObject> tmp = Database.query('Select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);
            slctObjRecord.clear();
            for(Integer i=0; i<noOfRec; i++){                 
                slctObjRecord.add(tmp[i]);
                System.debug(i);
            }
            System.debug('Last Page : ');
        }
        else{
            List<SObject> tmp = Database.query('Select ' + getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + 2000);
            slctObjRecord.clear();
            for(Integer i=(pageNo-1)*noOfRec; i<(pageNo*noOfRec); i++){
                slctObjRecord.add(tmp[i]);
                System.debug(i);
            }
        }
        lastPanelShowHide=recshwhide = true;
    }

    public void delRec(){
        try{
            str = apexPages.currentpage().getParameters().get('index');
            String delqry = 'Select id from ' + selectedObj + ' where id = \''+ str + '\' ';        
            System.debug(delqry);
            delete Database.query(delqry);        

            for(Integer i=0; i<slctObjRecord.size(); i++)
            {
                if(slctObjRecord.get(i).get('id')==str){
                    slctObjRecord.remove(i);
                    break;
                }
            }
        }
        catch(Exception e){
            apexPages.addMessage(new apexPages.Message(ApexPages.severity.ERROR, 'Can not delete record...!!!'));
            System.debug(e);
        }
    }

    public void charRecShow(){
        str = apexPages.currentPage().getParameters().get('param');
        System.debug('str is : '+str);
        str=str.remove(' ');
        slctObjRecord.clear();
        String qryResult='';
        if(str=='All'){            
            qryResult = 'Select '+ getSplitFieldName() + ' from ' + selectedObj + ' Limit ' + noOfRec;                        
            totalRecPage = (Database.countQuery('select COUNT()  from ' + selectedObj));                 
              if((Math.mod(totalRecPage,noOfRec))==0){
                  totalRecPage = totalRecPage/noOfRec;
              }              
              else{
                  totalRecPage = totalRecPage/noOfRec+1;
              }
        }
        else if(str=='Other'){
            qryResult = 'Select '+ getSplitFieldName() + ' from ' + selectedObj + ' where name like \'' + str + '%\'';                        
        }
        else{            
             qryResult = 'Select '+ getSplitFieldName() + ' from ' + selectedObj + ' where name like \'' + str + '%\'';  
             totalRecPage = (Database.countQuery('select COUNT()  from ' + selectedObj + ' where name like \'' + str + '%\''));                 
              if((Math.mod(totalRecPage,noOfRec))==0){
                  totalRecPage = totalRecPage/noOfRec;
              }              
              else{
                  totalRecPage = totalRecPage/noOfRec+1;
              }                      
        }
        slctObjRecord = Database.query(qryResult);
        System.debug('Size is : ' + slctObjRecord.size());
        if(slctObjRecord.size()==0){
            lastPanelShowHide = false;
            recordNo = 'No record found...!!!';
        }
        else{
            lastPanelShowHide=true;
            recordNo = '1-'+slctObjRecord.size();
        }
        System.debug(qryResult);        
        recshwhide=true;  
    }
    public PageReference showRecordsOfPage(){
      System.debug('Apex Fun. call ' + pageNo);
      slctObjRecord.clear();
      List<sObject> tmp = Database.query('Select ' + getSplitFieldName() + ' from ' + selectedObj + ' LIMIT ' + 2000);
      System.debug(tmp);
      if(pageNo>totalRecPage){
        pageNo=totalRecPage;        
      }
      else if(pageNo<1){
        pageNo=1;
        System.debug('lowest' + pageNo);
      }
      System.debug('(pageNo-1)*totalRecPage : ' + (pageNo-1)*noOfRec + ' totalRecPage : ' + noOfRec);
      for(Integer i=(pageNo-1)*noOfRec; i<=noOfRec*pageNo; i++){
          System.debug('i is : ' + i);
          if(i==tmp.size()-1){
            slctObjRecord.add(tmp[i]);              
            break;
          }
          slctObjRecord.add(tmp[i]);                        
      }
      lastPanelShowHide=recshwhide=true;
      System.debug('slctObjRecord is : ' + slctObjRecord);
      return null;
    }
    Public List<DynamicWrapper> getRecords(){                       
        RecordWraps = new List<DynamicWrapper>();
        //Schema.SObjectType sobjType = schemaMap.get(selectedObj);
        //System.debug('SobjectType : ' + sobjType);
        System.debug('lstflds is : ' + lstflds);
        Integer j=0;
        for(SObject so : slctObjRecord)
        {
            DynamicWrapper tmp = new DynamicWrapper(so);   
           if(j++==0){
              tmp.lstflds1.addAll(lstflds);           
           }

                //System.debug(lstflds);
            	 //tmp.setField(lstflds);
              

            RecordWraps.add(tmp);
        }
        
        new DynamicWrapper(lstflds);
        for(Integer i=0; i<RecordWraps.size(); i++){
            RecordWraps[i].show();            
        }      
        
        return RecordWraps;        
    }
    public class DynamicWrapper
    {
        public sObject sObjectRec {get;set;}
        public Boolean selected {get; set;}
         Public List<String>lstflds1{get;set;}
      
        public DynamicWrapper(List<String>str){          
            lstflds1 = new List<String>();
            lstflds1.addAll(str);
            System.debug('Str : ' + str);
        }
        public DynamicWrapper(sObject so){
            lstflds1 = new List<String>();
            sObjectRec = so;
            selected = true;            
        }

        public void setField(List<String> str){
            lstflds1.addAll(str);   
            
        }

        public void show(){
            System.debug('sObjectRec : ' + sObjectRec);
            System.debug('selected : ' + selected);
            System.debug('lstflds : ' + lstflds1);
        }
    }            

}