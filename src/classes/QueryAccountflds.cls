public class QueryAccountflds 
{
	//This class is used to generate all fields for Account Object dynamically
	public String getAccountQuery()
	{
		Map<String, Schema.Sobjectfield> accntfldMap = Account.sObjectType.getDescribe().fields.getMap();
		List<Schema.sObjectField> accntfldValues = accntfldMap.values();
		String Query = 'SELECT ';
		for(Schema.Sobjectfield accntFld : accntfldValues)
		{
			String fieldName = accntFld.getDescribe().getName();
			Query += fieldName + ',';
		}
		Query = Query.subString(0,Query.length() -1);
		
		//Additional Code
		Query = Query + ',(' + this.getOpptyQuery() + ' FROM Opportunities)';		
		return Query;
	}
	
	public String getOpptyQuery()
	{
		Map<String, Schema.Sobjectfield> opptyfldMap = Opportunity.sObjectType.getDescribe().fields.getMap();
		List<Schema.sObjectField> opptyfldValues = opptyfldMap.values();
		String Query = 'SELECT ';
		for(Schema.Sobjectfield opptyFld : opptyfldValues)
		{
			String fieldName = opptyFld.getDescribe().getName();
			Query += fieldName + ',';
		}
		Query = Query.subString(0,Query.length() -1);
		return Query;
	}
}