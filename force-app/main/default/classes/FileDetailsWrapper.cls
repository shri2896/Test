public class FileDetailsWrapper{		
	Public List<FileDetail>files = new List<FileDetail>();       	
	Public List<DropBoxFileDetail> entries = new List<DropBoxFileDetail>();		
	
	public class googleDriveAccessTokenResponse{
		public String access_token;
		public Integer expires_in;
		public String scope;
		public String token_type;
		public String refresh_token;
	}
	public class FileDetail {
		Public String id{get;set;}
		Public String name{get;set;}
		Public String mimeType{get;set;}
	}
	 public class DropBoxFileDetail{
	 	Public String tag{get; set;}
	 	Public String name{get; set;}
	 	Public String id{get; set;}
	 }
	 public class DownloadResponse{
	 	public Metadata metadata;
		public String link;
	 }
	 public class Metadata{
	 	Public String name{get;set;}
	 	Public String id{get;set;}
	 	Public String client_modified{get;set;}
	 	Public String server_modified{get;set;}
	 	Public String rev{get;set;}
	 	Public Integer size{get;set;}
	 	Public String path_lower{get;set;}
	 	Public String path_display{get;set;}
	 	Public String content_hash{get;set;}
	 }	 

	public class Restricted_to {		
	}
	/*It's box accesstoken response instead of drop box.. by mistake this name is given.*/
	 public class DropBoxAccessTokenResponse{
 		public String access_token{get;set;}
		public Integer expires_in{get;set;}
		public List<Restricted_to> restricted_to{get;set;}
		public String token_type{get;set;}
		public String refresh_token{get;set;}
	 }

	
	public class ResponseWrapper {
        public ItemCollection item_collection{get;set;}
    }
    
    public class ItemCollection {
        public List<FileDetails> entries{get;set;}
    }
    
    public class FileDetails {
        public String id{get;set;}
        public String name{get;set;}
        public String type{get;set;}
        public FileDetails(String name) {
            this.name = name;    
        }
        public FileDetails(String name,String id) {
            this.id = id;
            this.name = name;
        }
    }

    public class DropboxTokenResponse{
    	public String access_token{get;set;}
		public String token_type{get;set;}
		public String uid{get;set;}
		public String account_id{get;set;}
    }	
}