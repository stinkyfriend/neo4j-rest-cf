component
{
	this.path = "node";
	this.core = CreateObject("component","core.core");
	
	public any function create( props ) hint="Add a node." {
		var str = {};
		
		this.core.setEndPoint( this.path );
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		
		if (StructKeyExists(arguments, "props")) {
			str = arguments.props;
			this.core.setContentType( "application/json" );
		}
		
		this.core.setData( str );
		
		result = getNodeID( this.core.makeRequest( ) );
		
		return result;
	}
	
	/* TODO: handle missing node i.e. 404 http://docs.neo4j.org/chunked/snapshot/rest-api-nodes.html */
	
	public any function get( node ) hint="Get a node." {
		this.core.setEndPoint( this.path & '/' &  arguments.node);
		this.core.setMethod( "GET" );
				
		result = getNodeID( this.core.makeRequest( ) );
		return result;
	}
	
	public any function delete( node ) hint="Delete a node." {
		this.core.setEndPoint( this.path & '/' &  arguments.node);
		this.core.setMethod( "DELETE" );
				
		result = getNodeID( this.core.makeRequest( ) );
		return result;
	}
	
	public any function outgoing( node ) hint="Get a outgoing relationships for a node." {
		this.core.setEndPoint( this.path & '/' &  arguments.node & '/relationships/out');
		this.core.setMethod( "GET" );
				
		result = this.core.makeRequest( );
		return result;
	}
	
	public any function incoming( node ) hint="Get a outgoing relationships for a node." {
		this.core.setEndPoint( this.path & '/' &  arguments.node & '/relationships/in');
		this.core.setMethod( "GET" );
				
		result = this.core.makeRequest( );
		return result;
	}
	
	private any function getNodeID( result ) hint="Determine the id of the node." {
		if (StructKeyExists(arguments.result, "self")) {
			result["node"] = ListLast(result.self, '/'); 
		}
		return result;
	}
}