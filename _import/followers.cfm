<!--- The cypher query to get all users's node IDs --->
<cfset s = "START 	n=node(1) 
			MATCH 	n-[:USERS]->allUsers 
			RETURN 	ID(allUsers)">
<cfset objCypher = CreateObject("component","core.cypher")>
<cfset str = objCypher.query(queryString=s)>

<cfset arr = []>

<!--- Loop over the array of users put the [node] ID into a vanilla array. --->
<cfloop from="1" to="#ArrayLen(str.data)#" index="person">
	<cfset ArrayAppend(arr, str.data[person][1])>
</cfloop>

<!--- The batch object allows you to add a number of jobs (either creating nodes or indexes and relating nodes)
	and when you're ready send it off to neo4j. --->
<cfset objBatch = CreateObject("component","core.batch")>

<cftry>
	<cfoutput>
	<ul>
	<!--- Looping over each person we create a list of their followers, 
		adding a person and the 'FOLLOWS' relationship to the 'batch'. --->
	<cfloop from="1" to="#arrayLen(arr)#" index="person">
		<cfset followed = arr[person]>
		<li>Node: #followed#;
		
		<!--- A person cannot follow themselves so we remove them from the array. --->
		<cfset copy = duplicate(arr)>
		<cfset ArrayDeleteAt(copy, person)>
	
		<!--- Generate a random number of followers from 0 to the length of the array. --->
		<cfset howManyFollowers = randRange(0, arrayLen(copy), "SHA1PRNG")>
		How many followers: #howManyFollowers#
		
		<ul>
		<!--- Loop over the number of followers and pick a random one from the array. --->
		<cfloop from="1" to="#howManyFollowers#" index="i">
	
			<cfset followerIndex = randRange(1, ArrayLen(copy), "SHA1PRNG")>
			<cfset follower = copy[followerIndex]>
			<li>Follower: #follower#; Index: #followerIndex#</li>
	
			<!--- Now we have the id of a person who will be a follower. 
				So we need to add the relationship to the batch of jobs. --->
			<cfset relationship = {"from_node"=follower, "to_node"=followed, "type"="FOLLOWS"}>
			<cfset objBatch.build("relationship", relationship)>
	
			<!--- Now we remove the follower from the the array because a person can't follow more than once ---> 
			<cfset ArrayDeleteAt(copy, followerIndex)>
		</cfloop>
		</ul>
		</li>
	</cfloop>
	</ul>
	</cfoutput>
	
	<!--- Now we have a bunch of 'FOLLOW' jobs to send to neo4j --->
	<cfset objBatch.send()>
	
	<a href="/">back</a>
	
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>

</cftry>