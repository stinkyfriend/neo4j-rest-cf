component
{
	public any function findPerson( identifier ) hint="Retrieve a person from the the DB." {
		var s = "START node=node:person(username = '#arguments.identifier#') RETURN node";
		
		objCypher = CreateObject("component","core.cypher");
		
		str = getNodeId( objCypher.query(queryString=s) );
		
		return str;
	}
	
	public any function getAllUsers( ) hint="Retrieve all users from the the DB." {
		var s = "START n=node(#application.requires.USERS_REFERENCE#) MATCH n-[:USERS]-> allUsers RETURN allUsers";
		
		objCypher = CreateObject("component","core.cypher");
		
		arr = objCypher.query(queryString=s);
		
		return arr;
	}
	
	public any function getFollowing( identifier ) hint="Retrieve a person's followers from the the DB." {
		var s = "START node=node(#arguments.identifier#) MATCH node-[:FOLLOWS]-> followed RETURN followed.firstname, followed.lastname, followed.username";
		
		objCypher = CreateObject("component","core.cypher");
		
		str = objCypher.query(queryString=s);

		return str;
	}
	
	public any function getFollowers( identifier ) hint="Retrieve a person's followers from the the DB." {
		var s = "START node=node(#arguments.identifier#) 
					MATCH node<-[:FOLLOWS]- followers 
					RETURN followers.firstname, followers.lastname, followers.username";
		
		objCypher = CreateObject("component","core.cypher");
		
		str = objCypher.query(queryString=s);

		return str;
	}
	
	public any function getFollowedActivites( identifier, howmany ) hint="Retrieve a person's followers from the the DB." {
		var s = "START node=node(#arguments.identifier#) 
					MATCH node-[:FOLLOWS]->followers-[r:PENNED]-> activities 
					RETURN activities.message, followers.firstname, followers.lastname, followers.username, r.posted_on 
					ORDER BY r.posted_on DESC 
					LIMIT #arguments.howmany#";
		
		objCypher = CreateObject("component","core.cypher");
		
		str = objCypher.query(queryString=s);
		
		return str;
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