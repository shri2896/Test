public class PaginationController {
	  


   //Properties
    public integer PageSize {get;set;}
    public integer PageNumber {get;set;}
    public integer RecordCount {get;set;}
    public List<accountwrapper> objAWList {get;set;}
    private Set<id> selectedAccountIds;
    public boolean displayPopup {get; set;}  
    public List<account> objSelectedAccounts {get; set;}  
      
    //Constructor
    public PaginationController() {
        PageSize = 10;
        PageNumber = 1;   
        RecordCount = [Select Count() From Account];
        selectedAccountIds = new Set<id>();
        objAWList = new List<accountwrapper>();
        objSelectedAccounts  = new List<account>();
          
    }
      
    //Close Popup
    public void closePopup() {        
        displayPopup = false;    
    }     
      
    //Show Popup
    public void showPopup() {  
        setSelectedAccounts();      
        displayPopup = true;    
        objSelectedAccounts  = GetSelectedAccounts();
    }
      
    //Get Selected Accounts
    public Integer getSelectedCount(){
        return this.selectedAccountIds.size();
    }
      
    //Get Selected Accounts Detail
    public List<account> GetSelectedAccounts(){    
        List<account> objAccList = [Select Id, Name, Industry, Website, AccountNumber 
                                    From Account  Where ID IN : selectedAccountIds];       
        return objAccList;
    }
      
      
    private void setSelectedAccounts()
    {
        for(AccountWrapper item: objAWList)
        {
            if(item.IsSelected)
            {    
                if(!this.selectedAccountIds.contains(item.AccountId))
                {
                    this.selectedAccountIds.add(item.AccountId);
                }
            }
            else
            {
                if(this.selectedAccountIds.contains(item.AccountId))
                {
                    this.selectedAccountIds.remove(item.AccountId);
                }
            }
        }        
    }
      
    public integer PageIndex {
        get { return (PageNumber - 1); }
    }    
      
    public integer PageCount {
        get { return getPageCount(); }
    }
      
    public integer Offset {
        get { return (PageSize * PageIndex); }
    }
      
    public List<accountwrapper> GetAccountList() {
        objAWList = new List<accountwrapper>();
        try {
            Account[] objAccList = [Select Id, Name, Industry, Website, AccountNumber
                                    From Account order by Name 
                                    Limit :PageSize
                                    offset :Offset];
                                      
             for(Account acc : objAccList){
                AccountWrapper objAW = new AccountWrapper();
                objAW.AccountId = acc.Id;
                objAW.AccountName = acc.Name;
                objAW.Industry = acc.Industry;
                objAW.Website = acc.Website;
                objAW.AccountNumber = acc.AccountNumber;
                if(this.selectedAccountIds.contains(acc.Id)){
                    objAW.IsSelected = true;
                }
                else{
                    objAW.IsSelected = false;
                }
                objAWList.Add(objAW);
           }             
        return objAWList;
    }
    catch (QueryException e) {
        ApexPages.addMessages(e);   
        return null;
        }
    }
      
    public integer LNumber {
        get { return RecordCount == 0 ? 0 : (Offset + 1); }
    }
  
    public integer UNumber {
        get { 
            integer iUNum = ((LNumber + PageSize) - 1);
            return (iUnum > RecordCount) ? RecordCount : iUNum; 
        }
    }
      
    public boolean AllowMoveNext {
        get{ return ((PageIndex + 1) < PageCount); } } public boolean AllowMovePrev { get{ return (PageIndex > 0); }
    }
      
    public void Prev() {
        setSelectedAccounts();
        PageNumber--;
  
        if (PageNumber <= 0) { PageNumber = 1; } } public void Next() { setSelectedAccounts(); PageNumber++; if (PageNumber > PageCount) {
            PageNumber = PageCount;
        }
    }
      
    public void Last() {
        setSelectedAccounts();
        PageNumber = PageCount; 
    }
  
    public void First() {
        setSelectedAccounts();
        PageNumber = 1;
    }
      
    private integer getPageCount() {
        integer iPageCount = 1;
  
        if (RecordCount != 0 && PageSize != 0) {
            iPageCount = (RecordCount/PageSize) + ((Math.mod(RecordCount, PageSize)) > 0 ? 1 : 0);
        }
        return iPageCount;
    }
      
    //Wrapper Class for Account
    public class AccountWrapper
    {
        public Id AccountId {get;set;}
        public String AccountName {get;set;}
        public String Industry {get;set;}
        public String Website {get;set;}
        public String AccountNumber {get;set;}
        public Boolean IsSelected{get;set;}
        
        public AccountWrapper()
        {
        }
    }    
}