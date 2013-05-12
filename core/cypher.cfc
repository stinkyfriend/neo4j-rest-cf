component extends="core"
{
	this.path = "cypher";
	this.core = CreateObject("component","core").init();
	
	public any function query( queryString, convertToQuery ) hint="Prepare a cypher query to be sent." {
		var str = {};
		
		this.core.setEndPoint( this.path );
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		this.core.setBreakpoint( false );
		this.core.setConvertToQuery( not isNull( arguments.convertToQuery ) ? arguments.convertToQuery : false );
		
		str = {"query"=arguments.queryString,
				"params"={}};
		this.core.setContentType( "application/json" );
		
		this.core.setData( str );
		
		result = this.core.makeRequest( );
				
		return result;
	}	
}