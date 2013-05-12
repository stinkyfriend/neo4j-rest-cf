component accessors="true" persistent="true" 
{
	property name="Handle";
	property name="FirstName";
	property name="LastName";
	property name="FullName";
	property name="NodeID";
	
	this.objCypher = CreateObject("component","core.cypher");
	
	public any function init( identifier ) {
		var qry = findPerson( identifier=arguments.identifier );
		setHandle( qry.handle );
		setFirstName( qry.firstname );
		setLastName( qry.lastname );
		setFullName( qry.firstname & ' ' & qry.lastname );
		setNodeID( qry.node_id );
		
		return this;
	}
		
	public any function findPerson( identifier ) hint="Retrieve a person from the the DB." {
		var s = "START 		node = node:person(username = '#arguments.identifier#') 
				 RETURN 	node.firstname AS firstname, 
							node.lastname AS lastname, 
							node.username AS handle, 
							ID(node) AS node_id";
		
		var data = this.objCypher.query(queryString=s, convertToQuery=true);
		
		return data;
	}
	
	public any function getFollowing( ) hint="Retrieve a person's followers from the the DB." {
		var s = "START 		node = node( #getNodeID()# ) 
				 MATCH		node-[:FOLLOWS]-> followed 
				 RETURN		followed.firstname AS firstname, 
				 			followed.lastname AS lastname, 
				 			followed.username AS handle
				 ORDER BY 	followed.lastname ASC, followed.firstname ASC";
		
		var data = this.objCypher.query(queryString=s, convertToQuery=true);

		return data;
	}
	
	public any function getFollowers( ) hint="Retrieve a person's followers from the the DB." {
		var s = "START		node=node( #getNodeID()# ) 
				 MATCH		node<-[:FOLLOWS]- followers 
				 RETURN		followers.firstname AS firstname, 
				 			followers.lastname AS lastname, 
				 			followers.username AS handle";
		
		var data = this.objCypher.query(queryString=s, convertToQuery=true);

		return data;
	}
	
	public any function getActivites( howmany ) hint="Retrieve a person's activity from the the DB." {
		var s = "START 		node=node( #getNodeID()# ) 
				 MATCH 		node-[r:PENNED]->activities 
				 RETURN 	activities.message AS message,
				 			r.posted_on AS posted_on
				 ORDER BY 	r.posted_on DESC
				 LIMIT 		#arguments.howmany#";
		
		var data = this.objCypher.query(queryString=s, convertToQuery=true);
		
		return data;
	}
	
	public any function getFollowedActivites( howmany ) hint="Retrieve a person's followers activity from the the DB." {
		var s = "START		node = node( #getNodeID()# ) 
				 MATCH		node-[:FOLLOWS]->followers-[r:PENNED]-> activities 
				 RETURN		activities.message AS message,
				 			followers.firstname AS firstname,
				 			followers.lastname AS lastname,
				 			followers.username AS handle,
				 			r.posted_on AS posted_on
				 ORDER BY 	r.posted_on DESC
				 LIMIT 		#arguments.howmany#";
		
		var data = this.objCypher.query(queryString=s, convertToQuery=true);
		
		return data;
	}
	
	/*private any function getNodeID( result ) hint="Determine the id of the node." {
		if (StructKeyExists(arguments.result, "data")
				AND IsArray(arguments.result.data)
				AND ArrayLen(arguments.result.data) gte 1
				AND IsArray(arguments.result.data[1])) {
			result["node"] = ListLast(arguments.result.data[1][1]["self"], '/'); 
		}
		return result;
	}*/
	
}