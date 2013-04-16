component extends="core"
{
	this.path = "cypher";
	this.core = CreateObject("component","core").init();
	
	public any function query( queryString ) hint="Add a node." {
		var str = {};
		
		this.core.setEndPoint( this.path );
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		this.core.setBreakpoint( false );
		
		str = {"query"=arguments.queryString,
				"params"={}};
		this.core.setContentType( "application/json" );
		
		this.core.setData( str );
		
		result = this.core.makeRequest( );
				
		return result;
	}	
}