component
{
	this.path = "batch";
	this.core = CreateObject("component","core.core");
	this.batch = [];
		
	public any function build( type, data ) hint="build the batch of jobs." {
		var str = {};
		var batchID = ArrayLen(this.batch);
		
		switch(lcase(type)) { 
			case "node": 
				str["method"] = "POST";
				str["to"] = "/node";
				str["body"] = data;
				str["id"] = batchID;
				break;
			case "relationship":
				str["method"] = "POST";
				str["to"] = "/node/" & data.from_node & "/relationships";
				str["body"] = {"to"="/node/" & data.to_node, "type"=data.type};
				if (StructKeyExists(data, "data")) {
					str["body"]["data"] = data.data;
				}
				str["id"] = batchID;
				break;
			case "index": 
				str["method"] = "POST";
				str["to"] = "/index/node/" & data.index;
				str["body"] = data.data;
				str["id"] = batchID;
				break;
			default: 
			
		}
		
		ArrayAppend(this.batch, str);
				
		return batchID;
	}
	
	public any function get( ) hint="Get the batch of jobs." {
		return this.batch;
	}

	public any function send( ) hint="Send the batch of jobs." {
		
		this.core.setEndPoint( this.path );
		this.core.setMethod( "POST" );
		this.core.setAccept( "application/json" );
		this.core.setBreakpoint( true );

		if (StructKeyExists(this, "batch") AND ArrayLen(this.batch)) {
			str = this.batch;
			this.core.setContentType( "application/json" );
		}
		
		this.core.setData( str );
		try {		
			result = this.core.makeRequest( );
		}
		catch(any e) {
			writeDump(e);
			abort;
		}
		
		
		// Reset the batch array once is has been sent
		this.batch = [];
		
		return result;
	}
}