<!--- Random text generator for generating messages. --->

<!--- The cypher query to get all users --->
<cfset s = "START 	n=node(#application.requires["USERS_REFERENCE"]#)
			MATCH 	n-[:USERS]->allUsers
			RETURN ID(allUsers)">
<cfset objCypher = CreateObject("component","core.cypher")>
<cfset str = objCypher.query(queryString=s)>

<cfset arr = []>
<cfset present = now()>
<cfset randomText = "http://www.randomtext.me/api/gibberish/p-100/10-30">

<!--- Loop over the array of users and get their node ids. --->
<cfloop from="1" to="#ArrayLen(str.data)#" index="person">
	<cfset ArrayAppend(arr, str.data[person][1])>
</cfloop>

<cfscript>
	function GenerateRandomDate( ) {
		minutes = randRange(1, 43200, "SHA1PRNG");
		date = DateAdd("n", -minutes, present);
		return date;
	}
</cfscript>

<!--- If the message_reference node does not exist then create it --->
<cfif application.requires["MESSAGES_REFERENCE"] is "">
	<cfset objNodes = CreateObject("component", "core.nodes")>
	<cfset msgReference = objNodes.create()>
	<cfset application.requires["MESSAGES_REFERENCE"] = msgReference.node>

	<cfset objRelationships = CreateObject("component", "core.relationships")>
	<cfset objRelationships.create(	from_node=application.requires["REFERENCE_NODE"], 
									to_node=application.requires["MESSAGES_REFERENCE"], 
									type="MESSAGES_REFERENCE")>
</cfif>

<cfset objBatch = CreateObject("component","core.batch")>

<cftry>
	<cfoutput>
	<ul>
	<cfloop array="#arr#" index="person">
		<li>#person#</li>

		<!--- Set up where we're getting the random text from --->
		<cfset httpparams = {method="get", url=randomText, result="resp"}>

		<!--- Incase you access interwebs via a proxy --->
		<cfif StructKeyExists(application, "import_proxyserver") AND len(application.import_proxyserver)>
			<cfset httpparams["proxyserver"] = application.import_proxyserver>
		</cfif>

		<!--- Now go GET some random text for the current user --->
		<cfhttp attributeCollection="#httpparams#">

		<!--- Assuming the random text generator has been kind enough to give you some ... --->
		<cfif StructKeyExists(resp, "mimetype") AND resp.mimetype is "application/json"
				AND StructKeyExists(resp, "statuscode") AND resp.statuscode is "200 ok">
			
			<cfset json = DeserializeJSON(resp.FileContent.toString())>
			
			<cfif StructKeyExists(json, "text_out")>

				<!--- The random text generator gives you 50 items each between <p></p> 
					so we treat this as an xml document and loop over each message. --->
				<cfset alltext = "<t>" & json.text_out & "</t>">
				<cfset xmlDoc = XmlParse(allText)>
				
				<cfset messages = XmlSearch(xmlDoc, "/t/p")>
				<ol>
				<cfloop array="#messages#" index="message">
					<cfset str = {}>
					<cfset str["message"] = trim(message.xmlText)>
					
					<!--- Add the message node to the batch queue and get back the id of the job 
							because we need to relate the message to the MESSAGE REFERENCE node. --->
					<cfset batchID = objBatch.build("node", str)>
					
					<!--- Using the job id we relate the message to the MESSAGE REFERENCE node --->
					<cfset ref_relationship = {	from_node=application.requires["MESSAGES_REFERENCE"], 
												to_node="{#batchID#}", 
												type="MESSAGES"}>
					<cfset objBatch.build("relationship", ref_relationship)>
					
					<!--- Create a relationship between the user's node and the message and add it to the batch queue. --->
					<cfset relationship = {	from_node=person, 
											to_node="{#batchID#}", 
											type="PENNED", 
											data={"posted_on"=application.lib.GetEpochTime(GenerateRandomDate())}}>
					<cfset objBatch.build("relationship", relationship)>
					<li>#batchID#: #str["message"]#</li>
				</cfloop>
				</ol>
				
				<cfset objBatch.send()>
				
			</cfif>
		</cfif>
	</cfloop>
	</ul>
	</cfoutput>
	
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>

</cftry>