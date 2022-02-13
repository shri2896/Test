public class ObjectWrapper {
	public String label{get;set;}
	public String name{get;set;}

	public class GetObjNameId{
		String id{get;set;}
		String name{get;set;}

		public GetObjNameId(String id, String nam){
			this.id = id;
			name = nam;
		}
	}
}