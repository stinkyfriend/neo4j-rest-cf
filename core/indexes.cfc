component
{
	this.path = "index";
	this.core = CreateObject("component","core");
	
	public any function add( uri, value, key, index ) hint="Add a node to an index." {
		var str = "";
		
		this.core.setEndPoint( this.path & "/node/" & arguments.index);
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		this.core.setContentType( "application/json" );
		
		str = {"value" = "#arguments.value#",
				"uri" = "#arguments.uri#",
				"key" = "#arguments.key#"};
		
		this.core.setData( str );
		
		result = this.core.makeRequest( );
				
		return result;
	}
	
	public any function createNodeIndex( name ) hint="Add a node to an index." {
		var str = {"name" = arguments.name};
		
		this.core.setEndPoint( this.path & "/node/");
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		this.core.setContentType( "application/json" );
		
		this.core.setData( str );
		
		result = this.core.makeRequest( );
				
		return result;
	}
		
}