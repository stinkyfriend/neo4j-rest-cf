<cfparam name="url.start" default="1">

<cftry>
	
	<!--- Read the data from the file, essentially. Just an array of people's firstnames and lastnames --->
	<cfset filePath = ExpandPath("./data/") & "users-sample.json">

	<cffile action="read" file="#filePath#" variable="fileContents">

	<cfif IsJSON(fileContents)>
		<cfset users =  deserializeJSON(fileContents)>
	<cfelse>
		<cfthrow message="can't convert the contents of #filePath#">
	</cfif>
	
	<!--- If the USERS_REFERENCE does not exist then we need to 
		create the node and then hook up a relationship 
		betweeen the REFERENCE node and the USERS_REFERENCE --->
	<cfif application.requires["USERS_REFERENCE"] is "">
		<cfset objNodes = CreateObject("component", "core.nodes")>
		<cfset userReference = objNodes.create()>
		<cfset application.requires["USERS_REFERENCE"] = userReference.node>
	
		<cfset objRelationships = CreateObject("component", "core.relationships")>
		<cfset objRelationships.create(from_node = application.requires["REFERENCE_NODE"], to_node = userReference.node, type = "USERS_REFERENCE")>
	</cfif>

	<!--- Batch object helps create a batch of jobs. It add each job to an array.
			if to jobs in the batch are related then you reference the position of the array --->
	<cfset objBatch = CreateObject("component", "core.batch")>

	<cfoutput>
	<!--- Looping over the array of users we create a struct or properties that we want to attach to the 'person' node --->
	<cfloop array="#users#" index="user">
		<cfset str = {}>
		<cfset str["firstname"] = trim(user.f_name)>
		<cfset str["lastname"] = trim(user.l_name)>
		<cfset str["username"] = trim(lcase(user.f_name & "_" & user.l_name))>
		<cfset str["startdate"] = dateAdd("d", -(randRange(1, 2000, "SHA1PRNG"))/2, now())>

		<!--- Attach person struct to the batch array. 
				The batch build() method returns the id of the job so we can 
				reference it in index and relationship operations in the same batch. --->	
		<cfset batchID = objBatch.build("node", str)>
		#str.firstname#, #str.lastname#, #str.username#, #str.startdate#, #batchID#<br />
		
		<!--- An index on usernames (twitter-esque handles). --->
		<cfset indexUsername = {"data"={"uri"="{#batchID#}", "value"=str.username, "key"="username"}, "index"="person"}>
		
		<!--- Add the indexes to the batch queue --->
		<cfset objBatch.build("index", indexUsername)>
		
		<!--- Create a relationship between the user reference node and the user node and add it to the batch queue. --->
		<cfset relationship = {"from_node"=application.requires["USERS_REFERENCE"], to_node="{#batchID#}", type="USERS"}>
		<cfset objBatch.build("relationship", relationship)>

	</cfloop>
	</cfoutput>

	<!--- Send the batch array, this should add nodes, index staffids and usernames and also set up a relationship to the users reference. --->
	<cfset objBatch.send()>

	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>

