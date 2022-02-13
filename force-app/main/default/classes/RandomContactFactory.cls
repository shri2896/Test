public class RandomContactFactory {
	
    public static List<Contact> generateRandomContacts(Integer noOfContact, String name){
        
        List<Contact> con = new List<Contact>();
        for(Integer i=0; i<noOfContact; i++){
            Contact c = new Contact(FirstName = '' + i, LastName = name);
            con.add(c);
        }
        return con;
    }
}