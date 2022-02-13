global class UpdateStatusInContact implements Database.Batchable<sObject>
{
	global Database.QueryLocator start(Database.batchablecontext bc)
    {      
  		Date currentDate = system.today();        
        Date previousDate = system.today()-2;               
        
        return Database.getQueryLocator(
            							'select firstname , lastname , status__c , mailingcity from contact where createdDate = YESTERDAY'
            						);
           }
    
    global void execute(Database.BatchableContext bc, List<contact> allContact)
    {
        System.debug('All Records are \n ');
        for(Contact cont : allContact)
        {
            cont.Status__c = 'Ready for Approval';    
        } 
        
        update allcontact;
        
        for(contact cont : allcontact)
        {
            System.debug('First Name is : ' + cont.firstname);
            System.debug('LastName is : ' + cont.lastName);
            System.debug('Status is : ' + cont.Status__c);
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        List<contact> cont = [select firstname , lastname , email from contact where createdDate = YESTERDAY];   
        
        String header = 'FirstName , LastName , Email \n';
        String Data = header;
        
        for(Contact con : cont)
        {
            String rec = con.FirstName + ' , ' + con.LastName + ' , ' + con.Email +  ' \n ';
            Data  = Data + rec;
        }
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(Data);
        string csvname= 'ContactRecord.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'shrikant.mittal@briskminds.com'};
        String subject ='Contact Records CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Contact CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        system.debug(Data);
    }
}