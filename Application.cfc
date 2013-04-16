component output="false" {
	
	/* An example application showing how to use the Neo4j REST API.	*/
	
	this.name = "Neo4j";
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,5,0);
	this.mappings["/"] = getDirectoryFromPath(getCurrentTemplatePath());
		
	public boolean function onApplicationStart( ) {
		/* The base url for Neo4j */
		application.urlNeo4j = "http://localhost:7474/db/data";
		application.import_proxyserver = "";
		
		setup();
		
		return true;
	}
	
	public void function onSessionStart() {
		
		return;
	}
	
	public boolean function onRequestStart( ) {
		var arrError = [];
				
		/* If you have changed any application scoped vars e.g. Neo4j URL endpoint then append ?restart=1 to your URL */
		if(StructKeyExists(url, "restart")) {
			onApplicationStart( );
		}

		/* If any of the checks fail we throw the error. Note we pass a JSON _array_ so that we can show all errors. */		
		if (ArrayLen(arrError) gt 0) {
			//throw (message="#serializeJSON(arrError)#", errorcode="4000") ;
		}
						
		return true;
	}
	
	public function setup() {
		
		/* You can explicitly tell your application what relationships you want from your reference node */
		application.requires = {"MESSAGES_REFERENCE"="","USERS_REFERENCE"=""};

		objServiceRoot = CreateObject("component","core.serviceRoot");
		str = objServiceRoot.getServiceRoot();
		
		application.requires["REFERENCE_NODE"] = StructKeyExists(str, "reference_node") ? ListLast(str.reference_node, '/') : "";
		
		if (application.requires["REFERENCE_NODE"] is not "") {
			objNode = CreateObject("component","core.nodes");
			arrOutRels = objNode.outgoing(application.requires["REFERENCE_NODE"]);
			for (i = 1; i LTE ArrayLen(arrOutRels); i++) {
				if (StructKeyExists(application.requires, arrOutRels[i].type)) {
					application.requires["#arrOutRels[i].type#"] = ListLast(arrOutRels[i].end, "/");
				}
			}

		}
	}

	public void function onError( exception ) {
		/* The error handling bit.
			If setting up the application fails then we include the error.cfm.
		 */
		var errorMessage = "";
		var errorCode = "";
		var errorBody = "";
		
		if (StructKeyExists(arguments.exception, "message")) {
			errorMessage = arguments.exception.message;
			errorCode = arguments.exception.errorCode;
		}
		
		if (StructKeyExists(arguments.exception, "cause") 
			AND StructKeyExists(arguments.exception.cause, "message")) {
			errorMessage = arguments.exception.cause.message;
			errorCode = arguments.exception.cause.errorCode;
		}

		if (len(trim(errorMessage))) {
			
			if (isJSON(errorMessage)) {
				tempVal = DeserializeJSON(errorMessage);
				
				if (isArray(tempVal)) {
					var errorBody = '<hr /><ul id="error">'; 
						for (var element in tempVal) {
							errorBody = errorBody & "<li>#element#</li>";
						} 
						errorBody = errorBody & "</ul>";
					}
			} else {
				errorBody = '<hr /><ul id="error"><li>' & errorMessage & '</li></ul>';
			}
		} else {
			writeDump(arguments.exception);
			abort;
		}

		if (errorCode eq 4000) {
			include "error.cfm";
		} else {
			writeDump(arguments.exception);
			abort;
			writeOutput(errorBody & "</div></div></body></html>");
		}
		
	}
}