<!--- The cypher query to get all users --->
<cfset s = "START n=node(1) MATCH n-[:USERS]-> allUsers RETURN allUsers">
<cfset objCypher = CreateObject("component","core.cypher")>
<cfset str = objCypher.query(queryString=s)>

<cfset stack = {}>
<cfset arr = []>

<!--- Loop over the array of users and strip out the unnecessary stuff. We also 
want to set up a pointer struct. --->
<cfloop from="1" to="#ArrayLen(str.data)#" index="person">
	<cfset ArrayAppend(arr, ListLast(str.data[person][1].self, '/'))>
</cfloop>

<cfdump var="#arr#">

<cfset objBatch = CreateObject("component","core.batch")>
<cftry>
<cfoutput>
<ul>
<cfloop from="1" to="#arrayLen(arr)#" index="person">
	<cfset followed = arr[person]>
	<li>Node: #followed#;
	<cfset copy = duplicate(arr)>
	<cfset ArrayDeleteAt(copy, person)>

	<cfset howManyFollowers = randRange(0, arrayLen(copy), "SHA1PRNG")>
	How many followers: #howManyFollowers#
	
	<ul>
	<cfloop from="1" to="#howManyFollowers#" index="i">

		<cfset followerIndex = randRange(1, ArrayLen(copy), "SHA1PRNG")>
		<cfset follower = copy[followerIndex]>
		<li>Follower: #follower#; Index: #followerIndex#</li>

		<!--- TODO: Add to the batch stack --->
		<cfset relationship = {"from_node"=follower, "to_node"=followed, "type"="FOLLOWS"}>
		<cfset objBatch.build("relationship", relationship)>

		<cfset ArrayDeleteAt(copy, followerIndex)>
	</cfloop>
	</ul>
	</li>
</cfloop>
</ul>
</cfoutput>

<cfset objBatch.send()>

<cfcatch>
<cfdump var="#cfcatch#">
</cfcatch>

</cftry>