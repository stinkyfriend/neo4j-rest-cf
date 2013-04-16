<cfparam name="url.start" default="1">

<cftry>

	<cfset filePath = ExpandPath("./data/") & "users-sample.json">

	<cffile action="read" file="#filePath#" variable="fileContents">

	<cfif IsJSON(fileContents)>
		<cfset users =  deserializeJSON(fileContents)>
	<cfelse>
		<cfthrow message="can't convert the contents of #filePath#">
	</cfif>

	<cfif application.requires["USERS_REFERENCE"] is "">
		<cfset objNodes = CreateObject("component", "core.nodes")>
		<cfset userReference = objNodes.create()>
		<cfset application.requires["USERS_REFERENCE"] = userReference.node>
	
		<cfset objRelationships = CreateObject("component", "core.relationships")>
		<cfset objRelationships.create(application.requires["REFERENCE_NODE"], userReference.node, "USERS_REFERENCE")>
	</cfif>

	<cfset objBatch = CreateObject("component", "core.batch")>

	<cfoutput>
	<cfloop array="#users#" index="user">
		<cfset staffid = generateStaffID()>
		<cfset str = {}>
		<cfset str["firstname"] = trim(user.f_name)>
		<cfset str["lastname"] = trim(user.l_name)>
		<cfset str["staffid"] = trim(staffid)>
		<cfset str["username"] = trim(lcase(user.f_name & "_" & user.l_name))>
		<cfset str["startdate"] = dateAdd("d", -staffid/2, now())>

		<!--- Attach the struct to the batch array. The batch array returns the id of the action so we can reference it in index and relationship operations in the same batch. --->	
		<cfset batchID = objBatch.build("node", str)>
		#str.firstname#, #str.lastname#, #str.staffid#, #str.username#, #str.startdate#, #batchID#<br />
		<!--- An index on staffids --->
		<cfset indexStaffID = {"data"={"uri"="{#batchID#}", "value"=str.staffid, "key"="staffid"}, "index"="person"}>
		
		<!--- An index on usernames (twitter-esque handles). --->
		<cfset indexUsername = {"data"={"uri"="{#batchID#}", "value"=str.username, "key"="username"}, "index"="person"}>
		
		<!--- Add the indexes to the batch queue --->
		<cfset objBatch.build("index", indexStaffID)>
		<cfset objBatch.build("index", indexUsername)>
		
		<!--- Create a relationship between the user reference node and the user node and add it to the batch queue. --->
		<cfset relationship = {"from_node"=userReference.node, to_node="{#batchID#}", type="USERS"}>
		<cfset objBatch.build("relationship", relationship)>

	</cfloop>
	</cfoutput>

	<!--- Send the batch array, this should add nodes, index staffids and usernames and also set up a relationship to the users reference. --->
	<cfset objBatch.send()>

	<cffunction name="generateStaffID">
		<cfset staffid = randRange(1, 2000, "SHA1PRNG")>
		<cfif not structKeyExists(variables, "allStaffIDs")>
			<cfset allStaffIDs = {}>
		</cfif>
		<cfif structKeyExists(variables.allStaffIDs, staffid)>
			<cfset staffid = generateStaffID()>
		</cfif>
		<cfreturn staffid>
	</cffunction>

	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>

