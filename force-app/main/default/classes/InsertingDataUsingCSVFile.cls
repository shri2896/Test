public class InsertingDataUsingCSVFile 
{
    public Blob csvfiledata{get;set;}
    public String csvdataAsString{get;set;}
    public String[] csvfilelines{get;set;}
    public List <contact> con{get;set;}
    public String printMsg{get;set;}
    public List<contact> unCommittedRecord{get;set;}
    public String msg{get;set;}
    
    public InsertingDataUsingCSVFile()
    {        
        csvfilelines=new string[]{};
        con = new List<contact>();
        unCommittedRecord = new List<Contact>();
    }
    
    public void importData()
    {
        try
        {           
            String checkFileName = csvDataAsString.substringAfter('.');           
            
            if(checkFileName.equalsIgnoreCase('csv')==false)
            {       
                 System.debug('File Extension is ' + checkFileName);
            	apexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid File Selection'));	
            }
            else
            {
                printMsg='Commited Records are : ';
                csvdataAsString = csvfiledata.toString();
                csvfilelines = csvdataAsString.split('\n'); 
                
                for(Integer i=1; i<csvfilelines.size(); i++)
                {                
                    Contact temp = new Contact();
                    String[] singlerecord = csvfilelines[i].split(',');  					
					if(singleRecord.size()-1==3)
                    {
                        temp.firstname = singlerecord[0];
                        temp.lastname = singlerecord[1];
                        temp.MailingCity = singlerecord[2];
                        temp.email = singlerecord[3];              
                        con.add(temp);                                         
                    }
                    else
                    {
                        msg='UnCommittedRecords Are : ';
                     	temp.firstname = singlerecord[0];
                        temp.lastname = singlerecord[1];
                        temp.MailingCity = singlerecord[2];
                        unCommittedRecord.add(temp);
                    }
                   
                }            
                
                Database.SaveResult[] result = Database.insert(con,false);
                for(Database.SaveResult s : result)
                {
                    system.debug('Enter');
                    if(s.isSuccess())
                    {
                        System.debug('Success : ' + s.getId());
                    }
                    else
                    {
                        for(Database.Error err: s.getErrors())
                        {
                            system.debug(err.getMessage());
                        }
                    }
                }
                           
            }   
            
            if((unCommittedRecord.size())>0)
            {
                SendAnEmail.mail(unCommittedRecord);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'UnCommited Record Data Send on Your Email : '));
            }
        }
        catch(Exception e)
        { 
            apexpages.Message errorMessage = new apexPages.Message(ApexPages.Severity.FATAL, 'Error....!!! Invalid Data Enter');
            ApexPages.addmessage(errormessage);
            System.debug('Exception is : ' + e);
        }           
    }    

}



/* 

    String objType=’Account’;
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    Schema.SObjectType leadSchema = schemaMap.get(objType);
    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
    
    for (String fieldName: fieldMap.keySet()) {
    //get all the fields label for Account Object
    String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
    
    //get data types for each fields
    Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
    if(fielddataType != Schema.DisplayType.TextArea) {
    build your logic if the Field data type is TextArea
    }
    if(fielddataType != Schema.DisplayType.String) {
    build your logic if the Field data type is String
    }
    
    if(fielddataType != Schema.DisplayType.Integer) {
    build your logic if the Field data type is Integer
    }
    
    if(fielddataType != Schema.DisplayType.DateTime) {
    build your logic if the Field data type is DateTime
    }
    
    }

*/