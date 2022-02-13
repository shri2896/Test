public class SendAnEmail 
{
    public static void mail(List<Contact> cont)
    {
         String header = 'FirstName , LastName , Mailing City \n';
        String Data = header;
        
        for(Contact con : cont)
        {
            String rec = con.FirstName + ' , ' + con.LastName + ' , ' + con.mailingCity ;
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
        
        //system.debug(Data);
    }
}