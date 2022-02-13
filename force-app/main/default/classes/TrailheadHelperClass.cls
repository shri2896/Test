public class TrailheadHelperClass {
	public void afterInsert(List<Account> lst)
    {
   		for(Account acc : lst)
        {
            if(acc.Match_Billing_Address__c==true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
    public void afterUpdate(List<Account> lst)
    {
        List<Account> ac = new List<Account>();
        for(Account acc : lst)
        {
            if(acc.Match_Billing_Address__c==true){
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
        update ac;
    }
}