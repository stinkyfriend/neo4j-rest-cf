component
{
	public any function findPerson( staffid ) hint="Retrieve a person from the the DB." {
		var s = "START node=node:person(staffid = '#arguments.staffid#') RETURN node";
		
		objCypher = CreateObject("component","neo4j.core.cypher");
		
		str = getNodeId( objCypher.query(queryString=s) );
		
		return str;
	}
	
	public any function getAllUsers( ) hint="Retrieve all users from the the DB." {
		var s = "START n=node(1) MATCH n-[:USERS]-> allUsers RETURN allUsers";
		
		objCypher = CreateObject("component","neo4j.core.cypher");
		
		arr = objCypher.query(queryString=s);
		
		return arr;
	}
	
	private any function getNodeID( result ) hint="Determine the id of the node." {
		if (StructKeyExists(arguments.result, "data")
				AND IsArray(arguments.result.data)
				AND ArrayLen(arguments.result.data) gte 1
				AND IsArray(arguments.result.data[1])) {
			result["node"] = ListLast(arguments.result.data[1][1]["self"], '/'); 
		}
		return result;
	}
	
}