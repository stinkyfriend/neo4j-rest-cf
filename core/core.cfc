component accessors="true" persistent="true" 
{
	
	property name="Endpoint";
	property name="Method" default="GET";
	property name="Data" default="";
	property name="Accept" default="application/json; stream=true;";
	property name="ContentType";
	property name="Breakpoint" default="false";
	property name="ConvertToQuery" default="false";
	
	public core function init( ) {

		return this;
	}
	
	private string function formatData( ) hint="Get the 'data' but return it as a JSON string." {
		// Ensure integers are sent as integers not strings.
		setData(REReplace(IsJSON(getData()) ? getData() : SerializeJSON(getData()), ':"([0-9]{1}|[1-9][0-9]*)"', ":\1", "all"));
	}
		
	public string function buildURL( ) hint="Build the URL based on the request." {
		var urlEndpoint = application.urlNeo4j & "/" & getEndpoint();
		
		return urlEndpoint;
	}
	
	public any function makeRequest( ) hint="Make the request. This takes all the porperties that have been set required to make the call to the API." {
		var httpRequest = new http();
		var FileContent = "";
		var response = "";
		var data = "";
		
		httpRequest.setURL( buildURL( ) );
		httpRequest.setMethod( getMethod() );
		
		if (StructKeyExists(application, "ProxyServer")) {
			httpRequest.setProxyServer( application.ProxyServer );
		}
		
		httpRequest.addParam(name="Accept", value=getAccept(), type="header");
		
		if (len(getContentType()) gt 0) {
			httpRequest.addParam(name="Content-Type", value=getContentType(), type="header");
		}

		data = not isNull(getData()) ? getData() : "";
		if ((isStruct(data) AND structCount(data)) OR (isArray(data) AND arrayLen(data)) ){
			formatData( );
			httpRequest.addParam(value=getData(), type="body");
		}		

		httpResponse = httpRequest.send().getPrefix();
		
		FileContent = httpResponse.filecontent.toString();
		
		/* Process the returned results */
		response = processResults( httpFileContent=FileContent );
		
		/* if (getBreakpoint()) {
			writeDump(data);
			writeDump(response);
			abort; 
			} */
		
		return response;
	}
	
	private any function processResults( httpFileContent ) {
		var response = "";
		var returnValue = "";
		
		if (isJSON(arguments.httpFileContent)) {
			
			response = DeserializeJSON(arguments.httpFileContent);
			
			if (getConvertToQuery()) {
				returnValue = fconvertToQuery( neoData=response );
			} else {
				returnValue = response;
			}
			
		} else {
			writeDump(arguments.httpFileContent);
			abort;
				throw (message="neo4j Error: The response from neo4j is not as expected.");
		}
		
		return returnValue;
	}
	
	private any function fconvertToQuery( neoData ) {
		var qry = QueryNew("");
		var iterColumns = arguments.neoData.columns.iterator();
		var iterData = [];
		var position = 0;
				
		while(iterColumns.hasNext()){
			position++;
			columnName = iterColumns.next();
			values = [];
			
			iterData = arguments.neoData.data.iterator();
			while(iterData.hasNext()){
				ArrayAppend(values, iterData.next()[position]);
			}
			QueryAddColumn(qry,columnName,values);
			
		}
		
		return qry;
	}
}