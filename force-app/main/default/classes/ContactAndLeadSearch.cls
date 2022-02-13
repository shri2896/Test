public class ContactAndLeadSearch {
	public static List<List<SObject>> searchContactsAndLeads(String str)
    {
        List<List<SObject>> lst = [find 'smith' in all fields Returning Contact(lastName), lead(lastName)];
        return lst;
    }
}