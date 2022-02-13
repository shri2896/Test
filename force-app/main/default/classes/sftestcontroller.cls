global class sftestcontroller {
    
    @RemoteAction
    global static List<Contact> GetContacts(){  
        List<Contact> contacts = [select id, Name from contact LIMIT 50];
        
        return contacts;        
    }
    
    @RemoteAction
    global static Contact GetContact(String contactId){  
        Contact contact = [SELECT Id, Name, Email FROM Contact WHERE Id =: contactId];
        
        return contact;        
    }
    
    @RemoteAction
    global static void UpdateContact(String contactId, String email){  
        Contact contact = [SELECT Id, Name FROM Contact WHERE Id =: contactId];
        
        contact.Email = email;
        
        update contact;
    }
    
    @RemoteAction
    global static void NewContact(String firstName, String lastName, String email){  
        Contact newContact = new Contact(FirstName = firstName, LastName = lastName, Email = email);
        
        insert newContact;
    }
    
    @RemoteAction
    global static void DeleteContact(String contactId){  
        Contact contact = [SELECT Id FROM Contact WHERE Id =: contactId];
        
        delete contact;
    }
}