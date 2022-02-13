public with sharing class AuthorizeDotNetWrapper {


	/*@AuraEnabled Public List<DataList> productDataList;*/
	/*@AuraEnabled Public String label;
	@AuraEnabled Public String apiName;*/

	/*@AuraEnabled Public List<DataList> productDataList;*/
	@AuraEnabled public List<Fieldlist> sObjectData;
	@AuraEnabled public Integer index;

	public AuthorizeDotNetWrapper() {
		
	}	 
        
    //List of field wrapper to hold field data
            
    public AuthorizeDotNetWrapper(List<Fieldlist> fieldWraperList,Integer index){
        sObjectData = fieldWraperList;
        this.index  = index;
    }

	public Class DataList{
		@AuraEnabled Public List<Product2> listOfData;
	}

	public Class Fieldlist{

		@AuraEnabled public string fields{get;set;}		
                
        public Fieldlist(string field){
            fields  = field;            
        }
		/*@AuraEnabled Public String label;
		@AuraEnabled Public String apiName;*/

	}

	public class Errors {
		public String errorCode;
		public String errorText;
	}

	public class TransactionResponse {
		public String responseCode;
		public String authCode;
		public String avsResultCode;
		public String cvvResultCode;
		public String cavvResultCode;
		public String transId;
		public String refTransID;
		public String transHash;
		public String accountNumber;
		public String accountType;
		public List<Errors> errors;
	}

	public class Messages {
		public String resultCode;
		public List<Message> message;
	}

	public TransactionResponse transactionResponse;
	public String refId;
	public Messages messages;

	public class Message {
		public String code;
		public String text;
	}	
}