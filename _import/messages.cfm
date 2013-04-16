<!---

DELETE everyones ACTIVITIES and the relationships to the activities
 
<cfset s = "START node=node(0) 
			MATCH node-[:MESSAGES_REFERENCE]-> activities
			DELETE activities
			DELETE r">

<cfset objCypher = CreateObject("component","core.cypher")>
<cfset str = objCypher.query(queryString=s)>

<cfabort>--->

<!--- Random text generator for generating messages. --->

<!--- The cypher query to get all users --->
<cfset s = "START n=node(1) MATCH n-[:USERS]-> allUsers RETURN allUsers">
<cfset objCypher = CreateObject("component","core.cypher")>
<cfset str = objCypher.query(queryString=s)>

<cfset stack = {}>
<cfset arr = []>
<cfset present = now()>
<cfset randomText = "http://www.randomtext.me/api/gibberish/p-100/10-30">

<!--- Loop over the array of users and get their node ids. --->
<cfloop from="1" to="#ArrayLen(str.data)#" index="person">
	<cfset ArrayAppend(arr, ListLast(str.data[person][1].self, '/'))>
</cfloop>

<cfdump var="#arr#">

<cfscript>
	function GetEpochTime( datetime ) {
	    return int(DateDiff("s", "January 1 1970 00:00", datetime));
	}
	
	function GetTimeFromEpoch( epoch ) {
	    return dateAdd("s", epoch, "january 1 1970 00:00:00");
	}
	
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
	<cfset objRelationships.create(application.requires["REFERENCE_NODE"], application.requires["MESSAGES_REFERENCE"], "MESSAGES_REFERENCE")>
</cfif>

<cfset objBatch = CreateObject("component","core.batch")>

<cftry>
	<cfoutput>
	<ul>
	<cfloop array="#arr#" index="person">
		<li>#person#</li>
		<cfset httpparams = {method="get",url=randomText,result="resp"}>
		<cfif StructKeyExists(application, "import_proxyserver") AND len(application.import_proxyserver)>
			<cfset httpparams["proxyserver"] = application.import_proxyserver>
		</cfif>
		
		<cfhttp attributeCollection="#httpparams#">
			
		<cfif StructKeyExists(resp, "mimetype") AND resp.mimetype is "application/json"
				AND StructKeyExists(resp, "statuscode") AND resp.statuscode is "200 ok">
			
			<cfset json = DeserializeJSON(resp.FileContent.toString())>
			
			<cfif StructKeyExists(json, "text_out")>
				
				<cfset alltext = "<t>" & json.text_out & "</t>">
				<cfset xmlDoc = XmlParse(allText)>
				
				<cfset messages = XmlSearch(xmlDoc, "/t/p")>
				<ol>
				<cfloop array="#messages#" index="message">
					<cfset str = {}>
					<cfset str["message"] = trim(message.xmlText)>
					
					<cfset batchID = objBatch.build("node", str)>
					
					<cfset ref_relationship = {from_node=application.requires["MESSAGES_REFERENCE"], to_node="{#batchID#}", type="MESSAGES"}>
					<cfset objBatch.build("relationship", ref_relationship)>
					
					<!--- Create a relationship between the user's node and the message and add it to the batch queue. --->
					<cfset relationship = {from_node=person, to_node="{#batchID#}", type="PENNED", data={"posted_on"=GetEpochTime(GenerateRandomDate())}}>
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