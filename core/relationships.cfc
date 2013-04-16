component
{
	this.path1 = "relationship";
	this.path2 = "relationships";
	this.core = CreateObject("component","core");
	
	public any function create( from_node, to_node, type ) hint="Create a relationship between two nodes." {
		var str = {};
		
		this.core.setEndPoint( 'node/' & arguments.from_node & '/' & this.path2 );
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		
		this.core.setData( {"to"=application.urlNeo4j & '/node/' & arguments.to_node, "type"=arguments.type} );
		
		result = getRelationshipID( this.core.makeRequest( ) );
		
		return result;
	}
	
	public any function get( relationship ) hint="Get a relationship." {
		this.core.setEndPoint( this.path1 & '/' &  arguments.relationship);
		this.core.setMethod( "GET" );
				
		result = getRelationshipID( this.core.makeRequest( ) );
		return result;
	}
	
	public any function getTypes( ) hint="Get all the relationship types." {
		this.core.setEndPoint( this.path1 & '/types');
		this.core.setMethod( "GET" );
				
		result = this.core.makeRequest( );
		return result;
	}
	
	private any function getRelationshipID( result ) hint="Determine the id of the node." {
		if (StructKeyExists(arguments.result, "self")) {
			result["node"] = ListLast(result.self, '/'); 
		}
		return result;
	}
}